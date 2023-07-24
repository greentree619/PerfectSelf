//
//  VideoCompositionViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/28/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//


import UIKit
import AVFoundation
import Photos

class VideoCompositionViewController: UIViewController {

    var videoUrl: URL!
    var mergedResult: AVMutableComposition?
    var recordURL: URL?
    var readerAURL: URL?
    var readerVURL: URL?
    @IBOutlet var btnPlayPause: UIButton!
    @IBOutlet var slider: UISlider!

    var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                btnPlayPause.setImage(UIImage(named: "pause"), for: .normal)
            } else {
                btnPlayPause.setImage(UIImage(named: "play"), for: .normal)
            }
        }
    }

    @IBOutlet var playerView: PlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupPlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isPlaying = false
    }

    func setupPlayer() {
        playerView.mainavComposition = mergedResult!
        playerView.delegate = self
        slider.minimumValue = 0
    }

    @IBAction func btnBackClicked(_ sender: Any?) {
        isPlaying = false
        self.dismiss(animated: false)
    }

    @IBAction func btnSaveclicked(_ sender: Any?) {
        isPlaying = false
        
        log(meetingUid: "overlay-save", log:"tester video upload start:")
        let tapeId = getTapeIdString()
        let tapeFolderId = getTapeIdString()
        let tapeDate = getDateString()
        gRoomUid = selectedTape!.roomUid
        let prefixKey = "\(tapeDate)/\(gRoomUid!)/\(tapeId)/"
        print("Video upload prefixKey: \(prefixKey)")
        userName = "self-tape"
        //Omitted let uuid = UUID().uuidString
        showIndicator(sender: nil, viewController: self)
        
        DispatchQueue.main.async {
            saveOnlyVideoFrom(url: self.recordURL!) { url in
                print(url)
                DispatchQueue.main.async {
                    Toast.show(message: "Start to upload video file", controller:  self)
                }
                log(meetingUid: "overlay-save", log:"tester video upload start: \(encodeURLParameter(prefixKey)!)")
                //Upload video at first
                awsUpload.multipartUpload(filePath: url, bucketName: "video-client-upload-123456798", prefixKey: prefixKey){ error -> Void in
                    DispatchQueue.main.async {
                        hideIndicator(sender: nil)
                    }

                    if(error == nil)
                    {
                        log(meetingUid: "overlay-save", log:"\(userName!) video upload end successfully")
                        DispatchQueue.main.async {
                            //Omitted hideIndicator(sender: nil)
                            Toast.show(message: "Completed to upload Video file.", controller: self)
                        }

                        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
                            // Use the saved data
                            let uid = userInfo["uid"] as! String
                            //let tapeName = "\(getDateString())(\((uiViewContoller! as! ConferenceViewController).tapeId))"
                            let tmpParentFolderId = (parentFolderId.count == 0 ? selectedTape!.tapeId : parentFolderId)
                            //{{Add Folder
                            webAPI.addLibrary(uid: uid
                                              , tapeName: selectedTape!.tapeName
                                              , bucketName: "0"
                                              , tapeKey: ""
                                              , roomUid: tmpParentFolderId
                                              , tapeId: tapeFolderId)
                            //}}Add Folder
                            let tapeName = "\(tapeId)"
                            webAPI.addLibrary(uid: uid
                                              , tapeName: tapeName
                                              , bucketName: "video-client-upload-123456798"
                                              , tapeKey: "\(prefixKey)\(userName!)"
                                              , roomUid: gRoomUid!
                                              , tapeId: tapeId
                                              , parentId: tmpParentFolderId)
                            webAPI.addLibrary(uid: selectedTape!.readerUid!
                                              , tapeName: tapeName
                                              , bucketName: "video-client-upload-123456798"
                                              , tapeKey: selectedTape!.readerTapeKey!
                                              , roomUid: gRoomUid!
                                              , tapeId: tapeId
                                              , parentId: tmpParentFolderId)
                            //Omitted ConferenceViewController.clearTempFolder()
                        } else {
                            // No data was saved
                            print("No data was saved.")
                        }
                    }
                    else
                    {
                        log(meetingUid: "overlay-save", log:"\(userName!) video upload failed:\(error!.localizedDescription)")
                        DispatchQueue.main.async {
                            //hideIndicator(sender: nil)
                            Toast.show(message: "Failed to upload video file", controller: uiViewContoller!)
                        }
                    }
                }
            }

            saveOnlyAudioFrom(url: self.recordURL!) { url in
                print(url)
                let prefixKey = "\(tapeDate)/\(gRoomUid!)/\(tapeId)/"
                print("Audio upload prefixKey: \(prefixKey)")
                log(meetingUid: "overlay-save", log:"\(userName!) audio upload start")
                //Upload audio at secodary
                awsUpload.multipartUpload(filePath: url, bucketName: "video-client-upload-123456798", prefixKey: prefixKey){ (error: Error?) -> Void in
                    if(error == nil)
                    {//Then Upload video
                        log(meetingUid: "overlay-save", log:"\(userName!) audio upload end successfully.")
                        DispatchQueue.main.async {
                            //Omitted hideIndicator(sender: nil)
                            Toast.show(message: "Completed to upload audio file.", controller: self)
                        }
                    }
                    else
                    {
                        log(meetingUid: "overlay-save", log:"\(userName!) audio upload failed: \(error!.localizedDescription)")
                        DispatchQueue.main.async {
                            //Omitted hideIndicator(sender: nil)
                            Toast.show(message: "Failed to upload audio file", controller: self)
                        }
                    }
                }
            }
        }
    }

    @IBAction func btnPlayPauseClicked(_ sender: Any?) {
        if playerView.rate > 0 {
            playerView.pause()
            isPlaying = false
        } else {
           playerView.play()
           isPlaying = true
        }
    }
}

extension VideoCompositionViewController: PlayerViewDelegate {
    func playerVideo(player: PlayerView, currentTime: Double) {
        slider.value = Float(currentTime)
    }

    func playerVideo(player: PlayerView, duration: Double) {
        slider.maximumValue =  Float(duration)
    }

    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayer.Status, error: Error?) {
        //
    }

    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayerItem.Status, error: Error?) {
        //
    }

    func playerVideoDidEnd(player: PlayerView) {
        isPlaying = false
    }
}
