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
    
    var savedVideoUrl: URL? = nil
    var savedAudioUrl: URL? = nil
    @IBOutlet weak var playerView: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var downloadVideoURL: NSString = "https://\(selectedTape!.bucketName).s3.us-east-2.amazonaws.com/\(selectedTape!.tapeKey).mp4" as NSString
        let downloadAudioURL: NSString = "https://\(selectedTape!.bucketName).s3.us-east-2.amazonaws.com/\(selectedTape!.tapeKey).m4a" as NSString
        
        downloadVideoURL = downloadVideoURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
        var requestURL = NSURL(string: downloadVideoURL as String)!
        var request = URLRequest(url: requestURL as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
//Omitted
//            DispatchQueue.main.async {
//                hideIndicator(sender: nil)
//            }
            
             if error != nil {
                  //print(error!.localizedDescription)
                 DispatchQueue.main.async {
                     Toast.show(message: "Faild to download tape from library", controller: self)
                 }
             }
             else {
                 let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                 let filePath = URL(fileURLWithPath: "\(documentsPath)/tempFile.mp4")
                 DispatchQueue.main.async {
                     do{
                         try data!.write(to: filePath)
                         self.savedVideoUrl = filePath
                         self.playerView.url = filePath
                         
                         //Download audio file
                         requestURL =  NSURL(string: downloadAudioURL as String)!
                         request = URLRequest(url: requestURL as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                         let taskAudio = session.dataTask(with: request, completionHandler: {(data, response, error) in
                             DispatchQueue.main.async {
                                 hideIndicator(sender: nil)
                             }
                             
                              if error != nil {
                                  //error
                              }
                             else {
                                 let filePath = URL(fileURLWithPath: "\(documentsPath)/tempFile.m4a")
                                 DispatchQueue.main.async {
                                     do{
                                         try data!.write(to: filePath)
                                         self.savedAudioUrl = filePath
                                     }
                                     catch{
                                         print("error: \(error)")
                                     }
                                 }
                             }
                         })
                         
                         DispatchQueue.main.async {
                             //Omitted showIndicator(sender: nil, viewController: self, color:UIColor.white)
                             taskAudio.resume()
                         }
                     }
                     catch{
                         print("error: \(error)")
                     }
                 }
             }
         })
        
        DispatchQueue.main.async {
            showIndicator(sender: nil, viewController: self, color:UIColor.white)
            task.resume()
        }
    }
    
    @IBAction func backDidTapped(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func recordNewTakeDidTapped(_ sender: UIButton) {
        guard self.savedVideoUrl != nil else{
            return
        }
        
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
        
        let editReadViewController = EditReadViewController(videoRrl: self.savedVideoUrl!)
        editReadViewController.modalPresentationStyle = .fullScreen
        self.present(editReadViewController, animated: false, completion: nil)
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        playerView.currentTime = Double( playerBar.value )
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
        
    }
}
