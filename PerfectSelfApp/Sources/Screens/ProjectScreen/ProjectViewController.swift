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

class ProjectViewController: UIViewController, PlayerViewDelegate {
    func playerVideo(player: PlayerView, currentTime: Double) {
        //player.pause()
        //self.playerView.updateFocusIfNeeded()
    }
    
    func playerVideo(player: PlayerView, duration: Double) {
        //player.currentTime = duration/100
        //player.player!.seek(to: CMTime(value: 1, timescale: 600))
        player.play()
    }
    
    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayer.Status, error: Error?) {
        
    }
    
    func playerVideo(player: PlayerView, statusItemPlayer: AVPlayerItem.Status, error: Error?) {
        
    }
    
    func playerVideoDidEnd(player: PlayerView) {
        
    }
    
    var savedFileUrl: URL? = nil
    @IBOutlet weak var playerView: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playerView.delegate = self
        
        var downloadImageURL: NSString = "https://\(selectedTape!.bucketName).s3.us-east-2.amazonaws.com/8CF21CA9-DD2D-4A30-B81B-9B554D3B4D5A.mp4" as NSString
        
        downloadImageURL = downloadImageURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
        
        let requestURL: NSURL = NSURL(string: downloadImageURL as String)!
        
        let request = URLRequest(url: requestURL as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
            DispatchQueue.main.async {
                hideIndicator(sender: nil)
            }
            
             if error != nil {
                  //print(error!.localizedDescription)
                 DispatchQueue.main.async {
                     Toast.show(message: "Faild to download tape from library", controller: self)
                 }
             }
             else {
                 //print(response)//print(response ?? default "")
                 let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                 let filePath = URL(fileURLWithPath: "\(documentsPath)/tempFile.mp4")
                 DispatchQueue.main.async {
                     do{
                         try data!.write(to: filePath)
                         self.savedFileUrl = filePath
                         self.playerView.url = filePath
                         
//                         PHPhotoLibrary.shared().performChanges({
//                             PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: filePath)
//                         }) { completed, error in
//                             if completed {
//                                 //print("Video is saved!")
//                                 DispatchQueue.main.async {
//                                     Toast.show(message: "Video is saved!", controller: self)
//                                 }
//                             }
//                         }
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
        guard self.savedFileUrl != nil else{
            return
        }
        
        let overlayViewController = OverlayViewController()
        overlayViewController.uploadVideourl = self.savedFileUrl
        overlayViewController.modalPresentationStyle = .fullScreen
        self.present(overlayViewController, animated: false, completion: nil)
    }
    
    @IBAction func editDidTapped(_ sender: UIButton) {
        guard self.savedFileUrl != nil else{
            return
        }
        
        let editReadViewController = EditReadViewController(videoRrl: self.savedFileUrl!)
        editReadViewController.modalPresentationStyle = .fullScreen
        self.present(editReadViewController, animated: false, completion: nil)
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
