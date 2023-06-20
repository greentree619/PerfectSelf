//
//  EditReadViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/23/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import Foundation
import WebRTC
import AVFoundation

class EditReadViewController: UIViewController {
    
    var videoURL: URL
    var audioURL: URL?
    var readerVideoURL: URL
    var readerAudioURL: URL
    let movie = AVMutableComposition()
    var videoMTrack: AVMutableCompositionTrack?
    var audioMTrack: AVMutableCompositionTrack?
    var audioMTrack2: AVMutableCompositionTrack?
    var editRange: CMTimeRange?
    var editAudioTrack: AVAssetTrack?
    var onActorVideoEdit: Bool
    var editAudioAsset: AVURLAsset?
    //Omitted var timeSpan: Int = 0
    var trackSegmentRepo: TrackSegmentRepo?
    
    @IBOutlet weak var editBar: UIStackView!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var startTimerLabel: UILabel!
    @IBOutlet weak var endTimerLabel: UILabel!
    @IBOutlet weak var uiTitleLabel: UILabel!
    
    init(videoUrl: URL, audioUrl: URL?,  readerVideoUrl: URL, readerAudioUrl: URL, isActorVideoEdit: Bool) {
        self.videoURL = videoUrl
        self.audioURL = audioUrl
        self.readerVideoURL = readerVideoUrl
        self.readerAudioURL = readerAudioUrl
        self.onActorVideoEdit = isActorVideoEdit

        super.init(nibName: String(describing: EditReadViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var timer = Timer()
    var jobId = ""
    var videoId = ""
    override func viewDidLoad() {
        //print(audioURL, videoURL)
        
        //Omitted        let affineTransform = CGAffineTransform(rotationAngle: degreeToRadian(90))
        //Omitted        playerView.playerLayer.setAffineTransform(affineTransform)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if( !onActorVideoEdit ){
            uiTitleLabel.text = "Edit Read"
        }
        else
        {
            uiTitleLabel.text = "Edit Final"
        }
        
        editBar.isHidden = !self.onActorVideoEdit
        setupPlayer()
    }
    
    func setupPlayer() {
        videoMTrack = movie.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        audioMTrack = movie.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        audioMTrack2 = movie.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        var editMovie = AVURLAsset(url: videoURL) //1
        editAudioAsset = AVURLAsset(url: audioURL!)
        var editAudio2 = AVURLAsset(url: readerAudioURL)
        if( !onActorVideoEdit ){
            editMovie = AVURLAsset(url: readerVideoURL)
            editAudioAsset = AVURLAsset(url: readerAudioURL)
            editAudio2 = AVURLAsset(url: audioURL!)
        }
        
        trackSegmentRepo = TrackSegmentRepo(range: CMTimeRange(start:.zero, duration: editAudioAsset!.duration))
        
        editRange = CMTimeRangeMake(start: CMTime.zero, duration: editMovie.duration) //3
        editAudioTrack = editAudioAsset!.tracks(withMediaType: .audio).first! //2
        let editAudioTrack2 = editAudio2.tracks(withMediaType: .audio).first! //2
        let editVideoTrack = editMovie.tracks(withMediaType: .video).first!
        videoMTrack!.preferredTransform = transformForTrack(editVideoTrack)
        
        do{
            try videoMTrack?.insertTimeRange(editRange!, of: editVideoTrack, at: CMTime.zero) //4
            try audioMTrack?.insertTimeRange(editRange!, of: editAudioTrack!, at: CMTime.zero)
            try audioMTrack2?.insertTimeRange(editRange!, of: editAudioTrack2, at: CMTime.zero)
        } catch {
            //handle error
            print(error)
        }
          
        //{{
        playerView.mainavComposition = movie
        //==
        //playerView.url = videoURL
        //==
        //playerView.avAsset = editMovie
        //}}
//        playerView.playerItem?.videoComposition = videoComposition
        playerView.delegate = self
        slider.minimumValue = 0
        playerView.addObserver(self, forKeyPath: "status", context: nil)
    }
    
    @IBAction func backDidTap(_ sender: UIButton) {
        //print(self.timeSpan)
        playerView.stop()
        showConfirm(viewController: self, title: "Confirm", message: "Are you sure to apply changes?") { [self] UIAlertAction in
            movie.removeTrack(videoMTrack!)
            movie.removeTrack(audioMTrack2!)
            exportAudioWithTimeSpan(uiCtrl:  self, composition: movie
                                    , audioMixInputParam:
                                        trackSegmentRepo!.getMixInputParams(compositionTrack: audioMTrack!)) { [self] (m4aUrl: URL?) in
                if(m4aUrl != nil) {
                    //print(m4aUrl!)
                    var userName = "Anymous"
                    if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
                        // Use the saved data
                        userName = userInfo["userName"] as! String
                    }
                    
                    var tapeKey = "\(selectedTape!.actorTapeKey).m4a"
                    audioURL = m4aUrl
                    if( !onActorVideoEdit ){
                        readerAudioURL = m4aUrl!
                        tapeKey = "\(selectedTape!.readerTapeKey!).m4a"
                    }
                    
                    DispatchQueue.main.async {
                        showIndicator(sender: nil, viewController: self)
                        Toast.show(message: "Uploading audio file...", controller: self)
                    }
                    awsUpload.multipartUpload(filePath: m4aUrl!, bucketName: "video-client-upload-123456798", prefixKey: tapeKey, forceKey: true){ (error: Error?) -> Void in
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                        }
                        
                        if(error == nil)
                        {//Then Upload video
                            log(meetingUid: "editread-save", log:"\(userName) audio upload end successfully.")
                            DispatchQueue.main.async {
                                //Omitted hideIndicator(sender: nil)
                                Toast.show(message: "Completed to upload audio file.", controller: self)
                            }
                        }
                        else
                        {
                            log(meetingUid: "editread-save", log:"\(userName) audio upload failed: \(error!.localizedDescription)")
                            DispatchQueue.main.async {
                                //Omitted hideIndicator(sender: nil)
                                Toast.show(message: "Failed to upload audio file", controller: self)
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: false)
                }
            }
        } cancelHandler: { [self] UIAlertAction in
            self.dismiss(animated: false)
        }
    }
    
    @IBAction func playDidTap(_ sender: UIButton) {
        if playerView.rate > 0 {
            playerView.pause()
            //isPlaying = false
            playButton.setImage( UIImage(named: "play2")!, for: UIControl.State.normal)
        } else {
            playerView.play()
            //isPlaying = true
            playButton.setImage( UIImage(named: "pause.circle")!, for: UIControl.State.normal)
        }
    }
    
    @IBAction func playerSeekValueChanged(_ sender: UISlider) {
        playerView.currentTime = Double( sender.value )
    }
    
    
    @IBAction func settingDidTap(_ sender: UIButton)
    {
        playerView.pause()
    }
    
    @IBAction func addTimePause(_ sender: UIButton) {
        let controller = TimePauseViewController()
        controller.delegate = self
        controller.isAdding = true
        controller.modalPresentationStyle = .overFullScreen
        
        self.present(controller, animated: true)
    }
    
    
    @IBAction func removeTimePause(_ sender: UIButton) {
        let controller = TimePauseViewController()
        controller.delegate = self
        controller.isAdding = false
        controller.modalPresentationStyle = .overFullScreen
        
        self.present(controller, animated: true)
    }
    
    @IBAction func rotateDidTap(_ sender: UIButton)
    {
        playerView.pause()
    }
    
    @IBAction func audioEditDidTap(_ sender: UIButton)
    {
        playerView.pause()
        
        guard let _ = audioURL else {
            return
        }
        
        // do audio enhancement
        showIndicator(sender: nil, viewController: self, color: UIColor.white)
        audoAPI.getFileId(filePath: audioURL!) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Audio Enhancement failed. Unable to upload file.", controller: self)
                }
                return
            }
            do {
                struct FileId : Codable {
                    let fileId: String
                }
                let dataString = String(data: data, encoding: .utf8)
                print("Raw response data: \(String(describing: dataString))")
                
                let respItem = try JSONDecoder().decode(FileId.self, from: data)
                print(respItem.fileId)
                audoAPI.removeNoise(fileId: respItem.fileId) { data, response, error in
                    guard let data = data, error == nil else {
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                            Toast.show(message: "Audio Enhancement failed. Unable to process uploaded file.", controller: self)
                        }
                        return
                    }
                    do {
                        struct JobId : Codable {
                            let jobId: String
                        }
                       
                        let respItem = try JSONDecoder().decode(JobId.self, from: data)
                        print(respItem.jobId)
                        DispatchQueue.main.async {
                            self.jobId = respItem.jobId
                            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                            Toast.show(message: "Audio Enhancement failed. Unable to get job id.", controller: self)
                        }
                    }
                }

            } catch {
                print(error)
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Audio Enhancement failed. Unable to get file id.", controller: self)
                }
            }
        }
    }
    
    @IBAction func gotoFirstDidTap(_ sender: UIButton) {
        slider.setValue(0, animated: false)
        playerView.currentTime = Double( 0)
    }
    
    @IBAction func backwardDidTap(_ sender: UIButton) {
        var curVal = slider.value
        curVal = curVal - 5
        if(curVal < 0) {curVal = 0}
        slider.setValue(curVal, animated: false)
        playerView.currentTime = Double( curVal)
    }
    
    @IBAction func forwardDidTap(_ sender: UIButton) {
        var curVal = slider.value
        curVal = curVal + 5
        if(curVal > slider.maximumValue) {curVal = slider.maximumValue}
        slider.setValue(curVal, animated: false)
        playerView.currentTime = Double( curVal)
    }
    
    @IBAction func gotoEndDidTap(_ sender: UIButton) {
        slider.setValue(slider.maximumValue, animated: false)
        playerView.currentTime = Double( slider.maximumValue)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(object as? NSObject == playerView && keyPath == "status")
        {
            print(playerView.player?.status as Any)
        }
    }
    
    //new function
    @objc func timerAction(){
        audoAPI.getJobStatus(jobId: self.jobId) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Audio Enhancement failed. Unable to get job status.", controller: self)
                    return
                }
                return
            }
            do {
                struct JobStatus: Codable {
                    let state: String
                }
                let respItem = try JSONDecoder().decode(JobStatus.self, from: data)
                print("Job status ====> \(respItem.state)")
                if respItem.state == "succeeded" {
                    DispatchQueue.main.async {
                        self.timer.invalidate()
                    }
                    struct JobStatusSucceed: Codable {
                        let state: String
                        let downloadPath: String
                    }
                    do {
                        let res = try JSONDecoder().decode(JobStatusSucceed.self, from: data)
                        // download file
                        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                        let saveFilePath = URL(fileURLWithPath: "\(documentsPath)/tmpAudio.mp3")
                        do {
                            try FileManager.default.removeItem(at: saveFilePath)
                            print("File deleted successfully")
                        } catch {
                            print("Error deleting file: \(error.localizedDescription)")
                        }
                        
                        audoAPI.getResultFile(downloadPath: res.downloadPath) { (tempLocalUrl, response, error) in
                            
                            if let tempLocalUrl = tempLocalUrl, error == nil {
                                // Success
                                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                    DispatchQueue.main.async {
                                        hideIndicator(sender: nil)
                                        Toast.show(message: "Audio Enhancement completed", controller: self)
                                        self.audioURL = saveFilePath
//                                        self.mergeAudioWithVideo(videoUrl: self.videoURL, audioUrl: self.audioURL)
                                        self.setupPlayer()
                                    }
                                    print("Successfully downloaded. Status code: \(statusCode)")
                                }
                                
                                do {
                                    try FileManager.default.copyItem(at: tempLocalUrl, to: saveFilePath)
                                } catch (let writeError) {
                                    DispatchQueue.main.async {
                                        hideIndicator(sender: nil)
                                        Toast.show(message: "Audio Enhancement failed while copying file to save.", controller: self)
                                    }
                                    print("Error creating a file \(saveFilePath) : \(writeError)")
                                }
                                
                            } else {
                                DispatchQueue.main.async {
                                    hideIndicator(sender: nil)
                                    Toast.show(message: "Audio Enhancement failed while downloading.", controller: self)
                                }
                                print("Error took place while downloading a file. Error description:", error?.localizedDescription as Any);
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                            Toast.show(message: "Audio Enhancement failed. Unable to parse download path", controller: self)
                        }
                    }
                } else if respItem.state == "failed" {
                    DispatchQueue.main.async {
                        self.timer.invalidate()
                        hideIndicator(sender: nil)
                        Toast.show(message: "Audio Enhancement failed. Job status failed.", controller: self)
                    }
                    
                } else {
                   return
                }
                
            } catch {
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Audio Enhancement failed. Unable to parse job status.", controller: self)
                    return
                }
            }
        }
    }
    
    @IBAction func backgroundRemovalDidTap(_ sender: UIButton) {
        print("Edit Read Backgournd Removal func")
        playerView.pause()
        showIndicator(sender: nil, viewController: self, color: UIColor.white)
        backgroundAPI.uploadFile(filePath: videoURL) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Audio Enhancement failed. Unable to upload file.", controller: self)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("statusCode: \(httpResponse.statusCode)")
                // parse data
                do {
                    let res = try JSONDecoder().decode(BackRemoveResult.self, from: data)
                    DispatchQueue.main.async {
                        self.videoId = res.data.id
                        self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.timerActionForBackRemove), userInfo: nil, repeats: true)
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        hideIndicator(sender: nil)
                        Toast.show(message: "Background Removal API response parse error!", controller: self)
                    }
                }
            }
        }
    }
    
    @objc func timerActionForBackRemove() {
        backgroundAPI.getFileStatus(videoId: self.videoId) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Audio Enhancement failed. Unable to upload file.", controller: self)
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("statusCode: \(httpResponse.statusCode)")
                // parse data
                do {
                    let res = try JSONDecoder().decode(BackRemoveResult.self, from: data)
                    DispatchQueue.main.async {
                        if res.data.attributes.status == "done" {
//                            hideIndicator(sender: nil)
                            self.timer.invalidate()
                            // download file
                            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                            let saveFilePath = URL(fileURLWithPath: "\(documentsPath)/tmpVideo.mp4")
                            do {
                                try FileManager.default.removeItem(at: saveFilePath)
                                print("File deleted successfully")
                            } catch {
                                print("Error deleting file: \(error.localizedDescription)")
                            }
                            
                            audoAPI.getResultFile(downloadPath: res.data.attributes.result_url) { (tempLocalUrl, response, error) in
                                
                                if let tempLocalUrl = tempLocalUrl, error == nil {
                                    // Success
                                    if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                                        DispatchQueue.main.async {
//                                            hideIndicator(sender: nil)
//                                            Toast.show(message: "Audio Enhancement completed", controller: self)
                                            self.videoURL = saveFilePath
                                            self.mergeAudioWithVideo(videoUrl: self.videoURL, audioUrl: self.audioURL!)
                                        }
                                        print("Successfully downloaded. Status code: \(statusCode)")
                                    }
                                    
                                    do {
                                        try FileManager.default.copyItem(at: tempLocalUrl, to: saveFilePath)
                                    } catch (let writeError) {
                                        DispatchQueue.main.async {
                                            hideIndicator(sender: nil)
                                            Toast.show(message: "Audio Enhancement failed while copying file to save.", controller: self)
                                        }
                                        print("Error creating a file \(saveFilePath) : \(writeError)")
                                    }
                                    
                                } else {
                                    DispatchQueue.main.async {
                                        hideIndicator(sender: nil)
                                        Toast.show(message: "Audio Enhancement failed while downloading.", controller: self)
                                    }
                                    print("Error took place while downloading a file. Error description:", error?.localizedDescription as Any);
                                }
                            }
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        hideIndicator(sender: nil)
                        Toast.show(message: "Background Removal file status API response parse error!", controller: self)
                    }
                }
            }
        }
    }
    
    @IBAction func cropDidTap(_ sender: Any) {
        playerView.pause()
    }
    
    @IBAction func shareDidTap(_ sender: UIButton) {
        playerView.pause()
    }
    
    func mergeAudioWithVideo(videoUrl: URL, audioUrl: URL) {
        let videoAsset = AVAsset(url: videoUrl)
        let audioAsset = AVAsset(url: audioUrl)
        let mainComposition = AVMutableComposition()

        let videoTrack = mainComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        let videoAssetTrack = videoAsset.tracks(withMediaType: .video).first!
        try? videoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoAssetTrack, at: CMTime.zero)
        videoTrack?.preferredTransform = videoAssetTrack.preferredTransform // THIS LINE IS IMPORTANT

        let audioMTrack = mainComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first!
        try? audioMTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: audioAsset.duration), of: audioAssetTrack, at: CMTime.zero)

        let exportSession = AVAssetExportSession(asset: mainComposition, presetName: AVAssetExportPresetHighestQuality)
        guard
            let documentDirectory = FileManager.default.urls(
                for: .cachesDirectory,
                in: .userDomainMask).first
        else {
            DispatchQueue.main.async {
                hideIndicator(sender: nil)
                Toast.show(message: "Audio Enhancement failed while merging enhanced audio with video", controller: self)
            }
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        var date = dateFormatter.string(from: Date())
        date += UUID().uuidString
        let mergedVideoURL = documentDirectory.appendingPathComponent("mergeVideo-\(date).mov")
        
        exportSession?.outputURL = mergedVideoURL
        exportSession?.outputFileType = .mov
        exportSession?.shouldOptimizeForNetworkUse = true
        
        exportSession?.exportAsynchronously {
            switch exportSession?.status {
            case .completed:
                print("Merged video saved to: \(mergedVideoURL)")
                self.videoURL = mergedVideoURL
                self.setupPlayer()
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Audio Enhancement completed", controller: self)
                }
            case .failed, .cancelled:
                print("Error merging video: \(String(describing: exportSession?.error.debugDescription))")
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Audio Enhancement failed while merging enhanced audio with video", controller: self)
                }
            default:
                break
            }
        }
    }
}

extension EditReadViewController: PlayerViewDelegate {
    func playerVideo(player: PlayerView, currentTime: Double) {
        slider.value = Float(currentTime)
    }
    
    func playerVideo(player: PlayerView, duration: Double) {
        slider.minimumValue = Float(0)
        slider.maximumValue =  Float(duration)//as seconds
//        self.startTimerLabel.text = getCurrentTime(second:  0)
//        self.endTimerLabel.text = getCurrentTime(second: duration)
        
        slider.value = 0.0
        playerView.currentTime = Double( 0 )
    }
    
    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayer.Status, error: Error?) {
        
    }
    
    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayerItem.Status, error: Error?) {
        
    }
    
    func playerVideoDidEnd(player: PlayerView) {
        
    }
}

extension EditReadViewController: TimeSpanSelectDelegate{
    func addTimePause(timeSpan: Int) {
        print("addTimePause span=\(timeSpan) slider=\(slider.value)")
        
        let atTime: CMTime = CMTimeMakeWithSeconds( Float64(slider.value), preferredTimescale: 12000 )
        let timeDur: CMTime = CMTimeMakeWithSeconds( Float64(timeSpan), preferredTimescale: 1 )
        trackSegmentRepo!.addEmptySegment(range: CMTimeRange(start: atTime, duration: timeDur))
        trackSegmentRepo!.buildTrack(compositionTrack: audioMTrack!, assetTrack: editAudioTrack!)
        
        playerView.mainavComposition = movie
        playerView.delegate = self
        slider.minimumValue = 0
    }
    
    func substractimePause(timeSpan: Int) {
        print("substractTimePause span=\(timeSpan) slider=\(slider.value)")
        
        let atTime: CMTime = CMTimeMakeWithSeconds( Float64(slider.value), preferredTimescale: 12000 )
        let timeDur: CMTime = CMTimeMakeWithSeconds( Float64(-timeSpan), preferredTimescale: 1 )
        trackSegmentRepo!.deleteEmptySegment(range: CMTimeRange(start: atTime, duration: timeDur))
        trackSegmentRepo!.buildTrack(compositionTrack: audioMTrack!, assetTrack: editAudioTrack!)
        
        playerView.mainavComposition = movie
        playerView.delegate = self
        slider.minimumValue = 0
    }
}
