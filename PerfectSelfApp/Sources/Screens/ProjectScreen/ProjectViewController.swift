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
        
    var savedVideoUrl: URL? = nil
    var savedAudioUrl: URL? = nil
    @IBOutlet weak var playerView: PlayerView!
    //Omitted let awsUpload = AWSMultipartUpload()
    
    private var isOnPlay: Bool = true {
        didSet {
            DispatchQueue.main.async {
                if self.isOnPlay
                {
                    self.playButton.setBackgroundImage( UIImage(named: "pause.circle")!.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
                    self.playButton.tintColor = UIColor.white
                    self.playButton.imageView?.tintColor = UIColor.white
                    self.playerView.play()
                }
                else
                {
                    self.playButton.setBackgroundImage( UIImage(named: "play.circle")!.withRenderingMode(.alwaysTemplate), for: UIControl.State.normal)
                    self.playButton.tintColor = UIColor.white
                    self.playButton.imageView?.tintColor = UIColor.white
                    self.playerView.pause()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
        let filePath = URL(fileURLWithPath: "\(documentsPath)/tempFile.mp4")
        do {
            try FileManager.default.removeItem(at: filePath)
            //print("File deleted successfully")
        } catch {
            //print("Error deleting file: \(error.localizedDescription)")
        }
        
        //Omitted showIndicator(sender: nil, viewController: self, color:UIColor.white)
        awsUpload.download(filePath: filePath, bucketName: selectedTape!.bucketName, key: "\(selectedTape!.tapeKey).mp4") { (error) -> Void in
            if error != nil {
                 //print(error!.localizedDescription)
                self.savedVideoUrl = nil
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                    Toast.show(message: "Faild to download video from library", controller: self)
                }
            }
            else{
                self.savedVideoUrl = filePath
                self.playerView.url = filePath
                
                //Download audio file
                let filePath = URL(fileURLWithPath: "\(documentsPath)/tempFile.m4a")
                do {
                    try FileManager.default.removeItem(at: filePath)
                    //print("File deleted successfully")
                } catch {
                    //print("Error deleting file: \(error.localizedDescription)")
                }
                
                awsUpload.download(filePath: filePath, bucketName: selectedTape!.bucketName, key: "\(selectedTape!.tapeKey).m4a") { (error) -> Void in
                    DispatchQueue.main.async {
                        hideIndicator(sender: nil)
                        self.playerView.play()
                    }
                    
                    if error != nil {
                         //print(error!.localizedDescription)
                        self.savedAudioUrl = nil
                        DispatchQueue.main.async {
                            Toast.show(message: "Faild to download audio from library", controller: self)
                        }
                    }
                    else{
                        self.savedAudioUrl = filePath
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            showIndicator(sender: nil, viewController: self, color:UIColor.white)
        }
    }
    
    @IBAction func backDidTapped(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func recordNewTakeDidTapped(_ sender: UIButton) {
        guard self.savedVideoUrl != nil else{
            return
        }
        isOnPlay = false
        
        let overlayViewController = OverlayViewController()
        overlayViewController.uploadVideourl = self.savedVideoUrl
        overlayViewController.uploadAudiourl = self.savedAudioUrl
        overlayViewController.modalPresentationStyle = .fullScreen
        self.present(overlayViewController, animated: false, completion: nil)
    }
    
    @IBAction func editDidTapped(_ sender: UIButton) {
        guard self.savedVideoUrl != nil else{
            return
        }
        
        let editReadViewController = EditReadViewController(videoUrl: self.savedVideoUrl!, audioUrl: self.savedAudioUrl!)
        editReadViewController.modalPresentationStyle = .fullScreen
        self.present(editReadViewController, animated: false, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        playerView.currentTime = Double( playerBar.value )
    }
    
    @IBAction func playDidTapped(_ sender: UIButton) {
        self.isOnPlay = !self.isOnPlay
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
