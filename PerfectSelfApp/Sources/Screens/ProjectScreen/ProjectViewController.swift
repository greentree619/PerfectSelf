//
//  ProjectViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/26/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ProjectViewController: UIViewController {
    
    @IBOutlet weak var playerBar: UISlider!
    @IBOutlet var startTime: UILabel!
    @IBOutlet var endTime: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var editReadButton: UIButton!
    @IBOutlet weak var newTakeButton: UIButton!
    @IBOutlet weak var editFinalButton: UIButton!
    var savedVideoUrl: URL? = nil
    var savedAudioUrl: URL? = nil
    var savedReaderVideoUrl: URL? = nil
    var savedReaderAudioUrl: URL? = nil
    var doneReaderAVDownload: Bool = false
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var actorPlayerView: PlayerView!
    //Omitted let awsUpload = AWSMultipartUpload()
    var startElapseTime: Date?
    var endElapseTime: Date?
    var actorVTrack: AVMutableCompositionTrack?
    var aPlayerThumbView: UIImageView? = nil
    @IBOutlet weak var rPlayerThumbView: UIImageView!
    
    let actorAV = AVMutableComposition()
    let readerAV = AVMutableComposition()
    
    private var isOnPlay: Bool = true {
        didSet {
            DispatchQueue.main.async {
                if self.isOnPlay
                {
                    self.playButton.setBackgroundImage( UIImage(named: "pause.circle")!.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
                    self.playButton.tintColor = UIColor.white
                    self.playButton.imageView?.tintColor = UIColor.white
                    self.playerView.play()
                    self.actorPlayerView.play()
                }
                else
                {
                    self.playButton.setBackgroundImage( UIImage(named: "play.circle")!.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
                    self.playButton.tintColor = UIColor.white
                    self.playButton.imageView?.tintColor = UIColor.white
                    self.playerView.pause()
                    self.actorPlayerView.pause()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        actorVTrack?.preferredTransform = transformForTrack(rotateOffset: CGFloat(videoRotateOffset))
        
        let actorThumb = "https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/\(selectedTape!.actorTapeKey)-0.jpg"
        let readerTapeKey = (selectedTape!.readerTapeKey == nil ? "" : selectedTape!.readerTapeKey)
        let readerThumb = "https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/\(readerTapeKey!)-0.jpg"
        
        aPlayerThumbView = initPlayerThumbEx(playerView: self.actorPlayerView, url: URL(string: actorThumb))
        _ = initPlayerThumbEx(playerView: self.playerView, url: URL(string: readerThumb), thumbImgView: rPlayerThumbView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = selectedTape!.readerUid else{
            editReadButton.isEnabled = false
            newTakeButton.isEnabled = false
            editFinalButton.isEnabled = false
            Toast.show(message:  "Can't find reader video.", controller:  self)
            return
        }
        
        editReadButton.isEnabled = true
        newTakeButton.isEnabled = true
        editFinalButton.isEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool){
        isOnPlay = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        self.actorPlayerView.delegate = self
        
        downloadLibraryTape {
            self.actorPlayerView.play()
            self.playerView.play()
            
#if OVERLAY_TEST
            var count = 2
            _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                count -= 1
                if count == 0 {
                    timer.invalidate()
                    self.recordNewTakeDidTapped(UIButton())
                }
            })
#endif//OVERLAY_TEST
        }
    }
    
    @IBAction func deleteDidTap(_ sender: UIButton) {
        showConfirm(viewController: self, title: "Confirm", message: "Are you sure to delete?") { [self] UIAlertAction in
            //print("Ok button tapped")
            webAPI.getTapeCountByKey( tapeKey: selectedTape!.actorTapeKey ){ data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                do {
                    let resp = try JSONDecoder().decode(TapeCount.self, from: data)
                    print(resp.tapeCount)
                    if(resp.tapeCount == 1){
                        awsUpload.deleteFile(bucket: selectedTape!.bucketName, key: "\(selectedTape!.actorTapeKey).mp4")
                        awsUpload.deleteFile(bucket: selectedTape!.bucketName, key: "\(selectedTape!.actorTapeKey).m4a")
                    }
                } catch {
                    print(error)
                }
            }
            
            webAPI.getTapeCountByKey( tapeKey: selectedTape!.readerTapeKey ){ data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                do {
                    let resp = try JSONDecoder().decode(TapeCount.self, from: data)
                    print(resp.tapeCount)
                    if(resp.tapeCount == 1){
                        awsUpload.deleteFile(bucket: selectedTape!.bucketName, key: "\(String(describing: selectedTape!.readerTapeKey)).mp4")
                        awsUpload.deleteFile(bucket: selectedTape!.bucketName, key: "\(String(describing: selectedTape!.readerTapeKey)).m4a")
                    }
                } catch {
                    print(error)
                }
            }
            
            webAPI.deleteTapeByUid(uid: selectedTape!.actorUid, tapeKey: selectedTape!.actorTapeKey, roomUid: selectedTape!.roomUid, tapeId: selectedTape!.tapeId) { data, urlResponse, error in
            }
            webAPI.deleteTapeByUid(uid: selectedTape!.readerUid, tapeKey: selectedTape!.readerTapeKey, roomUid: selectedTape!.roomUid, tapeId: selectedTape!.tapeId) { data, urlResponse, error in
            }
            
            backDidTapped(UIButton())
        } cancelHandler: { UIAlertAction in
            //print("Cancel button tapped")
        }
    }
    
    @IBAction func didTapIndicatorView(_ sender: UITapGestureRecognizer) {
        //print("did tap view", sender)
        awsUpload.cancelDownload()
        hideIndicator(sender: nil)
    }
    
    @IBAction func backDidTapped(_ sender: UIButton?) {
        isOnPlay = false
        self.dismiss(animated: false)
    }
    
    @IBAction func recordNewTakeDidTapped(_ sender: UIButton) {
        if(  AVCaptureDevice.authorizationStatus(for: .video) != .authorized ||
               AVCaptureDevice.authorizationStatus(for: .audio) != .authorized ){
            requestCameraAndAudioPermission{ [self] in
                DispatchQueue.main.async { [self] in
                    showOverlayUI()
                }
            }
           return
        }
        showOverlayUI()
    }
    
    /// Marker: Edit Final
    @IBAction func editDidTapped(_ sender: UIButton) {
        guard self.savedVideoUrl != nil else{
            return
        }
        isOnPlay = false
        
        downloadReaderVideoAsync(silent: false, completionHandler: { () in
            guard  let _ = self.savedReaderVideoUrl, let  _ = self.savedReaderAudioUrl else{
                return
            }
            
            let editReadViewController = EditReadViewController(videoUrl: self.savedVideoUrl!, audioUrl: self.savedAudioUrl, readerVideoUrl: self.savedReaderVideoUrl!, readerAudioUrl: self.savedReaderAudioUrl!, isActorVideoEdit: true)
            editReadViewController.modalPresentationStyle = .fullScreen
            self.present(editReadViewController, animated: false, completion: nil)
        })
    }
    
    /// Marker: Edit Read
    @IBAction func editReadDidTapped(_ sender: UIButton)
    {
        guard self.savedVideoUrl != nil else{
            return
        }
        isOnPlay = false
        
        downloadReaderVideoAsync(silent: false, completionHandler: { () in
            guard  let _ = self.savedReaderVideoUrl, let  _ = self.savedReaderAudioUrl else{
                return
            }
            
            let editReadViewController = EditReadViewController(videoUrl: self.savedVideoUrl!, audioUrl: self.savedAudioUrl, readerVideoUrl: self.savedReaderVideoUrl!, readerAudioUrl: self.savedReaderAudioUrl!, isActorVideoEdit: false)
            editReadViewController.modalPresentationStyle = .fullScreen
            self.present(editReadViewController, animated: false, completion: nil)
        })
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        playerView.currentTime = Double( playerBar.value )
        actorPlayerView.currentTime = Double( playerBar.value )
        
        showViewBy(currentTime: Double(playerBar.value), view: aPlayerThumbView)
        showViewBy(currentTime: Double(playerBar.value), view: rPlayerThumbView)
    }
    
    @IBAction func playDidTapped(_ sender: UIButton) {
        self.isOnPlay = !self.isOnPlay
    }
    
    @IBAction func shareDidTap(_ sender: UIButton) {
    }
    
    @IBAction func exportDidTap(_ sender: UIButton?) {
        print("exportDidTap")
        self.isOnPlay = false
        
        if(savedVideoUrl == nil
           || savedAudioUrl == nil
           || savedReaderVideoUrl == nil
           || savedReaderAudioUrl == nil)
        {
            showConfirm(viewController: self, title: "Confirm", message: "You need to download tapes from library. Are you sure to download?") { [self] UIAlertAction in
                //print("Ok button tapped")
                self.downloadLibraryTape {
                    self.exportToLocalGallery()
                }
            } cancelHandler: { UIAlertAction in
                //print("Cancel button tapped")
            }
            return
        }
        
        self.exportToLocalGallery()
    }
    
    func showOverlayUI(){
        guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized, AVCaptureDevice.authorizationStatus(for: .audio) == .authorized else{
            Toast.show(message: "Can't gain the permission to use camera and microphoen.", controller:  self)
            return
        }
        
        guard self.savedVideoUrl != nil else{
            return
        }
        isOnPlay = false
        
        downloadReaderVideoAsync(silent: false, completionHandler: { () in
            guard  let _ = self.savedReaderVideoUrl, let  _ = self.savedReaderAudioUrl else{
                return
            }
            
            let overlayViewController = OverlayViewController()
            overlayViewController.uploadVideourl = self.savedReaderVideoUrl
            overlayViewController.uploadAudiourl = self.savedReaderAudioUrl
            overlayViewController.modalPresentationStyle = .fullScreen
            self.present(overlayViewController, animated: false, completion: nil)
        })
    }
    
    func downloadReaderVideoAsync(silent: Bool, completionHandler: @escaping () -> Void )-> Void
    {
        guard let _ = self.savedReaderVideoUrl, let _ = self.savedReaderAudioUrl else{
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath = URL(fileURLWithPath: "\(documentsPath)/tempReaderFile.mp4")
            do {
                try FileManager.default.removeItem(at: filePath)
                //print("File deleted successfully")
            } catch {
                //print("Error deleting file: \(error.localizedDescription)")
            }
            
            awsUpload.downloadEx(filePath: filePath, bucketName: selectedTape!.bucketName, key: "\(selectedTape!.readerTapeKey ?? "").mp4") { (error) -> Void in
                if error != nil {
                    //print(error!.localizedDescription)
                    self.savedReaderVideoUrl = nil
                    DispatchQueue.main.async {
                        if( !silent ){hideIndicator(sender: nil)}
                        Toast.show(message: "Faild to download reader video from library", controller: self)
                    }
                    completionHandler()
                }
                else{
                    self.savedReaderVideoUrl = filePath
                    
                    //Download audio file
                    let filePath = URL(fileURLWithPath: "\(documentsPath)/tempReaderFile.m4a")
                    do {
                        try FileManager.default.removeItem(at: filePath)
                        //print("File deleted successfully")
                    } catch {
                        //print("Error deleting file: \(error.localizedDescription)")
                    }
                    awsUpload.downloadEx(filePath: filePath, bucketName: selectedTape!.bucketName, key: "\(selectedTape!.readerTapeKey ?? "").m4a") { (error) -> Void in
                        DispatchQueue.main.async {
                            if( !silent ){hideIndicator(sender: nil)}
                        }
                        
                        if error != nil {
                            //print(error!.localizedDescription)
                            self.savedReaderAudioUrl = nil
                            DispatchQueue.main.async {
                                Toast.show(message: "Faild to download reader audio from library", controller: self)
                            }
                        }
                        else{
                            self.savedReaderAudioUrl = filePath
//                            let overlayViewController = OverlayViewController()
//                            overlayViewController.uploadVideourl = self.savedReaderVideoUrl
//                            overlayViewController.uploadAudiourl = self.savedReaderAudioUrl
//                            overlayViewController.modalPresentationStyle = .fullScreen
//                            self.present(overlayViewController, animated: false, completion: nil)
                        }
                        completionHandler()
                    }
                }
            }
            
            Toast.show(message: "Start to download reader video and audio...", controller: self)
            DispatchQueue.main.async {
                if( !silent ){showIndicator(sender: nil, viewController: self, color:UIColor.white)}
            }
            return
        }
        
        completionHandler()
    }
    
    func exportToLocalGallery(){
        //print("exportToLocalGallery")
//        savedAudioUrl
//        savedVideoUrl
//        savedReaderAudioUrl
//        savedVideoUrl
        //DispatchQueue.main.async {
        showIndicator(sender: nil, viewController: self, color:UIColor.white)
       // }
        
        let actorVAsset = AVURLAsset(url: self.savedVideoUrl!)
        let actorAAsset = AVURLAsset(url: self.savedAudioUrl!)
        let readerAAsset = AVURLAsset(url: self.savedReaderAudioUrl!)
        
//        do
//        {
        let mixComposition = AVMutableComposition()
        guard
            let recordTrack = mixComposition.addMutableTrack(
                withMediaType: .video,
                preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        else {
            DispatchQueue.main.async {
                hideIndicator(sender:  nil)
            }
            return
        }
        
        do {
            try recordTrack.insertTimeRange(
                CMTimeRangeMake(start: .zero, duration: actorVAsset.duration),
                of: actorVAsset.tracks(withMediaType: .video).first!,
                at: .zero)
        } catch {
            DispatchQueue.main.async {
                hideIndicator(sender:  nil)
            }
            return
        }
        
        let audioTrack = mixComposition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try audioTrack?.insertTimeRange(
                CMTimeRangeMake(
                    start: .zero,
                    duration: actorVAsset.duration),
                of: actorAAsset.tracks(withMediaType: .audio).first!,
                at: .zero)
        } catch {
            print("Failed to load Audio track")
        }
        
        let uploadedAudioTrack = mixComposition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            let duration = min(actorAAsset.duration, readerAAsset.duration)
            try uploadedAudioTrack?.insertTimeRange(
                CMTimeRangeMake(
                    start: .zero,
                    duration: duration),
                of: readerAAsset.tracks(withMediaType: .audio).first!,
                at: .zero)
        } catch {
            print("Failed to load Audio track")
        }
        
        // Not needed Uploaded video track here right now..
        let mainInstruction = AVMutableVideoCompositionInstruction()
        mainInstruction.timeRange = CMTimeRangeMake(
            start: .zero,
            duration: actorVAsset.duration)
        
        // only video of recorded track so not added time CMTimeAdd(recordAsset.duration, secondAsset.duration)
        let firstInstruction = VideoHelper.videoCompositionInstruction(recordTrack, asset: actorVAsset)
        firstInstruction.setOpacity(0.0, at: actorVAsset.duration)

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
            presetName: AVAssetExportPresetPassthrough)
        else { return }
        exporter.outputURL = url
        exporter.outputFileType = AVFileType.mov
        exporter.shouldOptimizeForNetworkUse = true
        exporter.videoComposition = mainComposition
        
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                hideIndicator(sender:  nil)
//                //print( exporter.status )
//                switch (exporter.status)
//                {
//                case .cancelled:
//                    print("Exporting cancelled");
//                case .completed:
//                    print("Exporting completed");
//                case .exporting:
//                    print("Exporting ...");
//                case .failed:
//                    print("Exporting failed");
//                default:
//                    print("Exporting with other result");
//                }
//                if let error = exporter.error
//                {
//                    print("Error:\n\(error)");
//                }
                
                guard  exporter.status == AVAssetExportSession.Status.completed, let outputURL = exporter.outputURL else { return }
                saveVideoToAlbum(outputURL, nil)
            }
        }
//        }
//        catch
//        {
//            print("Exception when compiling movie");
//        }
    }
    
    func downloadLibraryTape(completionHandler: @escaping () -> Void)-> Void
    {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let filePath = URL(fileURLWithPath: "\(documentsPath)/tempFile.mp4")
        do {
            try FileManager.default.removeItem(at: filePath)
            //print("File deleted successfully")
        } catch {
            //print("Error deleting file: \(error.localizedDescription)")
        }
        
        //Omitted startElapseTime = Date()
        //Omitted showIndicator(sender: nil, viewController: self, color:UIColor.white)
        awsUpload.downloadEx(filePath: filePath, bucketName: selectedTape!.bucketName, key: "\(selectedTape!.actorTapeKey).mp4") { [self] (error) -> Void in
            if error != nil {
                 //print(error!.localizedDescription)
                self.savedVideoUrl = nil
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Faild to download video from library", controller: self)
                }
            }
            else{
                //Omitted self.endElapseTime = Date()
                //Omitted let elapsed = self.endElapseTime!.timeIntervalSince(self.startElapseTime!)
                //Omitted print("Elapsed time: \(elapsed) seconds")
                
                self.savedVideoUrl = filePath
                
                //Download audio file
                let filePath = URL(fileURLWithPath: "\(documentsPath)/tempFile.m4a")
                do {
                    try FileManager.default.removeItem(at: filePath)
                    //print("File deleted successfully")
                } catch {
                    //print("Error deleting file: \(error.localizedDescription)")
                }
                
                awsUpload.downloadEx(filePath: filePath, bucketName: selectedTape!.bucketName, key: "\(selectedTape!.actorTapeKey).m4a") { [self] (error) -> Void in
                    if error != nil {
                         //print(error!.localizedDescription)
                        self.savedAudioUrl = nil
                        hideIndicator(sender: nil)
                        DispatchQueue.main.async {
                            Toast.show(message: "Faild to download audio from library", controller: self)
                        }
                    }
                    else{
                        self.savedAudioUrl = filePath
                        DispatchQueue.main.async { [self] in
                            actorVTrack = initAVMutableComposition(avMComp: actorAV, videoURL: self.savedVideoUrl!, audioURL: self.savedAudioUrl!, rotate: videoRotateOffset)
                            self.actorPlayerView.mainavComposition = actorAV
                            //Omitted self.actorPlayerView.play()
                            
                            //{{Wait until download both
                            DispatchQueue.main.async {
                                _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(100) / 1000, repeats: true, block: { timer in
                                    guard self.doneReaderAVDownload == true else{
                                        return
                                    }
                                    timer.invalidate()
                                    hideIndicator(sender: nil)
                                    completionHandler()
                                })
                            }
                            //}}Wait until download both
                        }
                    }
                }
            }
        }
        
        doneReaderAVDownload = false
        downloadReaderVideoAsync(silent: true) {
            self.doneReaderAVDownload = true
            guard  let _ = self.savedReaderVideoUrl, let  _ = self.savedReaderAudioUrl else{
                return
            }
            
            DispatchQueue.main.async { [self] in
                _ = initAVMutableComposition(avMComp: readerAV, videoURL: self.savedReaderVideoUrl!, audioURL: self.savedReaderAudioUrl!)
                self.playerView.mainavComposition = readerAV
                //Omitted self.playerView.play()
            }
        }
        
        DispatchQueue.main.async { [self] in
            showIndicator(sender: nil, viewController: self, color:UIColor.white)
            let tapGesture = UITapGestureRecognizer(target: self, action:  #selector(didTapIndicatorView(_:)))
            backgroundView!.addGestureRecognizer(tapGesture)
            Toast.show(message: "To cancel download from library, please tap screen.", controller: self)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProjectViewController: PlayerViewDelegate{
    func playerVideo(player: PlayerView, currentTime: Double) {
        //player.pause()
        //self.playerView.updateFocusIfNeeded()
        playerBar.value =  Float(currentTime)
        showViewBy(currentTime: currentTime, view: aPlayerThumbView)
        showViewBy(currentTime: currentTime, view: rPlayerThumbView)
    }
    
    func playerVideo(player: PlayerView, duration: Double) {
        //player.currentTime = duration/100
        //player.player!.seek(to: CMTime(value: 1, timescale: 600))
        
        playerBar.minimumValue = Float(0)
        playerBar.maximumValue =  Float(duration)
        self.startTime.text = getCurrentTime(second:  0)
        self.endTime.text = getCurrentTime(second: duration)
        //player.play()
        
        playerBar.value = 0.0
        playerView.currentTime = Double( 0 )
    }
    
    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayer.Status, error: Error?) {
        
    }
    
    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayerItem.Status, error: Error?) {
                
    }
    
    func playerVideoDidEnd(player: PlayerView) {
        isOnPlay = false
    }
}
