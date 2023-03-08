//
//  HomeViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/27/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import WebRTC

class HomeViewController: UIViewController {
    private let config = Config.default
    var videoPicker: VideoPicker?
    private lazy var libraryViewController = LibraryViewController()
    private var meetingListViewController: MeetingListViewController?
    
    init() {
        super.init(nibName: String(describing: HomeViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        videoPicker = VideoPicker(presentationController: self, delegate: self)
    }
    
    private func buildSignalingClient() -> SignalingClient {
        
        // iOS 13 has native websocket support. For iOS 12 or lower we will use 3rd party library.
        let webSocketProvider: WebSocketProvider
        
        if #available(iOS 13.0, *) {
            webSocketProvider = NativeWebSocket(url: self.config.signalingServerUrl)
        } else {
            webSocketProvider = StarscreamWebSocket(url: self.config.signalingServerUrl)
        }
        
        return SignalingClient(webSocket: webSocketProvider)
    }
    
    @IBAction func homeDidTap(_ sender: UIButton)
    {
    }
    
    @IBAction func libraryDidTap(_ sender: UIButton)
    {
        libraryViewController.modalPresentationStyle = .fullScreen
        self.present(libraryViewController, animated: false, completion: nil)
    }
    
    @IBAction func scheduleDidTap(_ sender: Any){
        let webRTCClient = WebRTCClient(iceServers: self.config.webRTCIceServers)
        let signalClient = self.buildSignalingClient()
        //{{
//        let mainViewController = MainViewController(signalClient: signalClient, webRTCClient: webRTCClient)
        //==
        self.meetingListViewController = MeetingListViewController(signalClient: signalClient, webRTCClient: webRTCClient)
        //}}
                
        self.meetingListViewController?.modalPresentationStyle = .fullScreen
        self.present(meetingListViewController!, animated: false, completion: nil)
    }
    
    @IBAction func userDidTap(_ sender: UIButton) {
//        let overlayViewController = VideoRecordViewController()
//        overlayViewController.modalPresentationStyle = .fullScreen
//        self.present(overlayViewController, animated: false, completion: nil)
        videoPicker?.present()
    }
}

extension HomeViewController: VideoPickerDelegate {
    func didSelect(url: URL?) {
        let vc = VideoRecordViewController()
        vc.uploadVideourl = url
        self.show(vc, sender: nil)
    }
}
