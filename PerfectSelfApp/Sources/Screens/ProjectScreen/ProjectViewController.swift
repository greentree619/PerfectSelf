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
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var actorPlayerView: PlayerView!
    //Omitted let awsUpload = AWSMultipartUpload()
    var startElapseTime: Date?
    var endElapseTime: Date?
    
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
                        DispatchQueue.main.async {
                            Toast.show(message: "Faild to download audio from library", controller: self)
                        }
                    }
                    else{
                        self.savedAudioUrl = filePath
                        DispatchQueue.main.async { [self] in
                            initAVMutableComposition(avMComp: actorAV, videoURL: self.savedVideoUrl!, audioURL: self.savedAudioUrl!)
                            self.actorPlayerView.mainavComposition = actorAV
                            //Omitted self.actorPlayerView.play()
                            
                            //{{Wait until download both
                            DispatchQueue.main.async {
                                _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(100) / 1000, repeats: true, block: { timer in
                                    guard self.savedReaderVideoUrl != nil, self.savedReaderAudioUrl != nil else{
                                        return
                                    }
                                    timer.invalidate()
                                    hideIndicator(sender: nil)
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
                                })
                            }
                            //}}Wait until download both
                        }
                    }
                }
            }
        }
        
        downloadReaderVideoAsync(silent: true) {
            DispatchQueue.main.async { [self] in
                initAVMutableComposition(avMComp: readerAV, videoURL: self.savedReaderVideoUrl!, audioURL: self.savedReaderAudioUrl!)
                self.playerView.mainavComposition = readerAV
                //Omitted self.playerView.play()
            }
        }
        
        DispatchQueue.main.async {
            showIndicator(sender: nil, viewController: self, color:UIColor.white)
        }
    }
    
    @IBAction func backDidTapped(_ sender: UIButton) {
        isOnPlay = false
        self.dismiss(animated: false)
    }
    
    @IBAction func recordNewTakeDidTapped(_ sender: UIButton) {
        guard self.savedVideoUrl != nil else{
            return
        }
        isOnPlay = false
        
        downloadReaderVideoAsync(silent: false, completionHandler: { () in
            let overlayViewController = OverlayViewController()
            overlayViewController.uploadVideourl = self.savedReaderVideoUrl
            overlayViewController.uploadAudiourl = self.savedReaderAudioUrl
            overlayViewController.modalPresentationStyle = .fullScreen
            self.present(overlayViewController, animated: false, completion: nil)
        })
    }
    
    /// Marker: Edit Final
    @IBAction func editDidTapped(_ sender: UIButton) {
        guard self.savedVideoUrl != nil else{
            return
        }
        isOnPlay = false
        
        downloadReaderVideoAsync(silent: false, completionHandler: { () in
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
            let editReadViewController = EditReadViewController(videoUrl: self.savedVideoUrl!, audioUrl: self.savedAudioUrl, readerVideoUrl: self.savedReaderVideoUrl!, readerAudioUrl: self.savedReaderAudioUrl!, isActorVideoEdit: false)
            editReadViewController.modalPresentationStyle = .fullScreen
            self.present(editReadViewController, animated: false, completion: nil)
        })
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        playerView.currentTime = Double( playerBar.value )
        actorPlayerView.currentTime = Double( playerBar.value )
    }
    
    @IBAction func playDidTapped(_ sender: UIButton) {
        self.isOnPlay = !self.isOnPlay
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
                    self.savedVideoUrl = nil
                    DispatchQueue.main.async {
                        if( !silent ){hideIndicator(sender: nil)}
                        Toast.show(message: "Faild to download reader video from library", controller: self)
                    }
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
                            self.savedAudioUrl = nil
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
                            completionHandler()
                        }
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
