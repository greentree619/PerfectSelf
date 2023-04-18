//
//  EditReadViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/23/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import WebRTC

class EditReadViewController: UIViewController {
    let videoURL: URL
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var startTimerLabel: UILabel!
    @IBOutlet weak var endTimerLabel: UILabel!
    
    init(videoRrl: URL) {
        self.videoURL = videoRrl
        super.init(nibName: String(describing: EditReadViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
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
    }
    
    @IBAction func rotateDidTap(_ sender: UIButton)
    {
    }
    @IBAction func audioEditDidTap(_ sender: UIButton)
    {
    }
    
    @IBAction func backgroundRemovalDidTap(_ sender: UIButton) {
    }
    
    @IBAction func cropDidTap(_ sender: Any) {
    }
    
    @IBAction func shareDidTap(_ sender: UIButton) {
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
