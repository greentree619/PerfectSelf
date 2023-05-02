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
    var audioURL: URL
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var startTimerLabel: UILabel!
    @IBOutlet weak var endTimerLabel: UILabel!
   
    init(videoUrl: URL, audioUrl: URL) {
        self.videoURL = videoUrl
        self.audioURL = audioUrl
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
        print(audioURL, videoURL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupPlayer()
    }
    
    func setupPlayer() {
        playerView.url = videoURL
        playerView.delegate = self
        slider.minimumValue = 0
    }
    
    @IBAction func backDidTap(_ sender: UIButton) {
        playerView.pause()
        self.dismiss(animated: false)
    }
    
    @IBAction func playDidTap(_ sender: UIButton) {
        if playerView.rate > 0 {
            playerView.pause()
            //isPlaying = false
        } else {
            playerView.play()
            //isPlaying = true
        }
    }
    
    @IBAction func playerSeekValueChanged(_ sender: UISlider) {
        playerView.currentTime = Double( sender.value )
    }
    
    
    @IBAction func settingDidTap(_ sender: UIButton)
    {
        playerView.pause()
    }
    
    @IBAction func rotateDidTap(_ sender: UIButton)
    {
        playerView.pause()
    }
    
    @IBAction func audioEditDidTap(_ sender: UIButton)
    {
        playerView.pause()
        
        // do audio enhancement
        showIndicator(sender: nil, viewController: self, color: UIColor.white)
        audoAPI.getFileId(filePath: audioURL) { data, response, error in
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
//                                        hideIndicator(sender: nil)
//                                        Toast.show(message: "Audio Enhancement completed", controller: self)
                                        self.audioURL = saveFilePath
                                        self.mergeAudioWithVideo(videoUrl: self.videoURL, audioUrl: self.audioURL)
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
                                            self.mergeAudioWithVideo(videoUrl: self.videoURL, audioUrl: self.audioURL)
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

        let audioTrack = mainComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
        let audioAssetTrack = audioAsset.tracks(withMediaType: .audio).first!
        try? audioTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: audioAsset.duration), of: audioAssetTrack, at: CMTime.zero)

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
        slider.maximumValue =  Float(duration)
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
