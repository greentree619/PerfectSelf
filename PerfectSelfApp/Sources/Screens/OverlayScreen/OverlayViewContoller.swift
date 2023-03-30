//
//  OverlayViewContoller.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/27/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import WebRTC
import Photos

class OverlayViewController: UIViewController {
    
    @IBOutlet var cameraView: CameraPreviewView!
    @IBOutlet var playerView: PlayerView!
    var uploadVideourl: URL?
    @IBOutlet var activityMonitor: UIActivityIndicatorView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var btnTimer: UIButton!
    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var btnStop: UIButton!
    var count = 5
    var timer: Timer!
    
    private var isOnRecording: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.isOnRecording == false
                {
                    self.btnRecord.titleLabel?.text = "Start Recording"
                }
                else if self.isOnRecording == true
                {
                    self.btnRecord.titleLabel?.text = "Stop Recording"
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.containerView.isHidden = true
        cameraView.delegate = self
        playerView.delegate = self
        guard let url = uploadVideourl else { return }
        playerView.url = url
        //slider.minimumValue = 0
        //btnStop.isEnabled = false
        btnRecord.isEnabled = true
        //btnTimer.isEnabled = true
        lblTimer.isHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playerView.invalidateIntrinsicContentSize()
        if cameraView.captureSession.isRunning == true {
            return
        }
        cameraView.captureSession.startRunning()
    }
    
    @IBAction func startRecordClicked(_ sender: UIButton) {
        if(!isOnRecording)
        {
            lblTimer.isHidden = false
            if timer != nil {
                timer.invalidate()
            }
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                self.count -= 1
                self.lblTimer.text = "\(self.count)"
                if self.count == 0 {
                    self.btnTimer.isEnabled = true
                    self.lblTimer.isHidden = true
                    timer.invalidate()
                    self.startRecordAction()
                    self.isOnRecording = true
                }
            })
        }
        else
        {
            stopRecordAction()
            self.isOnRecording = false
        }
    }
    
    func startRecordAction()
    {
        if !cameraView.isVideoRecording {
            cameraView.startVideoRecording()
            //btnRecord.isEnabled = false
            //btnStop.isEnabled = true
            //btnTimer.isEnabled = false
        }
        playerView.play()
    }
    
    func stopRecordAction()
    {
        if cameraView.isVideoRecording {
            cameraView.stopVideoRecording()
            //btnRecord.isEnabled = true
            //btnStop.isEnabled = false
            //btnTimer.isEnabled = true
        }
        playerView.stop()
    }
    
    @IBAction func backDidTap(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func timerAction(_ sender: UIButton) {
        btnTimer.isEnabled = false
        lblTimer.isHidden = false
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            self.count -= 1
            self.lblTimer.text = "\(self.count)"
            if self.count == 0 {
                self.btnTimer.isEnabled = true
                self.lblTimer.isHidden = true
                timer.invalidate()
                self.startRecordClicked(sender)
            }
        })
    }

    @IBAction func audioInputs(_ sender: UIButton) {
        self.containerView.isHidden = false
    }

    func mergedVideos(recordUrl:URL, uploadUrl:URL) {
        let recordAsset = AVAsset(url: recordUrl)
        let uploadAsset = AVAsset(url: uploadUrl)
        
        activityMonitor.startAnimating()

        let mixComposition = AVMutableComposition()

        guard
            let recordTrack = mixComposition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        else { return }

        do {
            try recordTrack.insertTimeRange(
                CMTimeRangeMake(start: .zero, duration: recordAsset.duration),
                of: recordAsset.tracks(withMediaType: .video)[0],
                at: .zero)
        } catch {
            print("Failed to load first track")
            return
        }

        let audioTrack = mixComposition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try audioTrack?.insertTimeRange(
                CMTimeRangeMake(
                    start: .zero,
                    duration: recordAsset.duration),
                of: recordAsset.tracks(withMediaType: .audio)[0],
                at: .zero)
        } catch {
            print("Failed to load Audio track")
        }

        let uploadedAudioTrack = mixComposition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            let duration = min(recordAsset.duration, uploadAsset.duration)
            try uploadedAudioTrack?.insertTimeRange(
                CMTimeRangeMake(
                    start: .zero,
                    duration: duration),
                of: uploadAsset.tracks(withMediaType: .audio)[0],
                at: .zero)
        } catch {
            print("Failed to load Audio track")
        }

        // Not needed Uploaded video track here right now..

        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(
            start: .zero,
            duration: recordAsset.duration)

        // only video of recorded track so not added time CMTimeAdd(recordAsset.duration, secondAsset.duration)
        let firstInstruction = VideoHelper.videoCompositionInstruction(recordTrack, asset: recordAsset)
        firstInstruction.setOpacity(0.0, at: recordAsset.duration)

        mainInstruction.layerInstructions = [firstInstruction]
        let mainComposition = AVMutableVideoComposition()
        mainComposition.instructions = [mainInstruction]
        mainComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        mainComposition.renderSize = VideoSize

        guard
            let documentDirectory = FileManager.default.urls(
                for: .cachesDirectory,
                in: .userDomainMask).first
        else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        var date = dateFormatter.string(from: Date())
        date += UUID().uuidString
        let url = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")

        guard let exporter = AVAssetExportSession(
            asset: mixComposition,
            presetName: AVAssetExportPresetHighestQuality)
        else { return }
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition

        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                self.exportDidFinish(exporter)
            }
        }
    }
    
    func exportDidFinish(_ session: AVAssetExportSession) {
      // 1
      activityMonitor.stopAnimating()

      // 2
      guard
        session.status == AVAssetExportSession.Status.completed,
        let outputURL = session.outputURL
        else { return }

        guard let vc: VideoCompositionViewController = UIStoryboard.mainStoryboard?.instantiateVC() else {
            return
        }
        vc.videoUrl = outputURL
        self.navigationController?.show(vc, sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containerViewSegue" {
            guard let view = segue.destination as? AvailableAudioInputsViewController else {
                return
            }
            view.delegate = self
        }
    }
    
}

extension OverlayViewController: CameraPreviewDelegate {

    func captureSessionDidStartRunning() {
       //
    }

    func captureSessionDidStopRunning() {
        //
    }

    func videoDidBeginRecording() {
        //
    }

    func videDidEndRecording(with url: URL?, error: Error?) {
//        guard let url = url, let uploadurl = self.uploadVideourl else {
//            return
//        }
        //FIXME self.mergedVideos(recordUrl: url, uploadUrl: uploadurl)
    }

}

extension OverlayViewController: AvailableAudioInputsViewControllerDelegate {
    func didFinishedAudioInput() {
        self.containerView.isHidden = true
    }
}


extension OverlayViewController: PlayerViewDelegate {
    func playerVideo(player: PlayerView, currentTime: Double) {
        //slider.value = Float(currentTime)
    }

    func playerVideo(player: PlayerView, duration: Double) {
        //slider.maximumValue = Float(duration)
    }

    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayer.Status, error: Error?) {
        //
    }

    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayerItem.Status, error: Error?) {
        //
    }
    
    func playerVideoDidEnd(player: PlayerView) {
        //
        //print("End")
        stopRecordAction()
        isOnRecording = false
    }
}
