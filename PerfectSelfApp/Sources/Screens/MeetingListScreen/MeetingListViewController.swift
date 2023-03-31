//
//  MeetingListViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/23/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import SwiftUI
import AVFoundation
import WebRTC

class MeetingListViewController: UIViewController {
    
    private let signalClient: SignalingClient
    private let webRTCClient: WebRTCClient
//    private lazy var conferenceViewController = ConferenceViewController(signalClient: signalClient, webRTCClient: self.webRTCClient, roomUid: )
    
    private var signalingConnected: Bool = false {
        didSet {
            DispatchQueue.main.async {
                if self.signalingConnected {
                    //                    self.signalingStatusLabel?.text = "Connected"
                    //                    self.signalingStatusLabel?.textColor = UIColor.green
//                    self.joinButton?.backgroundColor = UIColor.green
                }
                else {
                    //                    self.signalingStatusLabel?.text = "Not connected"
                    //                    self.signalingStatusLabel?.textColor = UIColor.red
//                    self.joinButton?.backgroundColor = UIColor.red
                }
            }
        }
    }
    
    private var hasLocalSdp: Bool = false {
        didSet {
            DispatchQueue.main.async {
                //                self.localSdpStatusLabel?.text = self.hasLocalSdp ? "✅" : "❌"
            }
        }
    }
    
    private var localCandidateCount: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                //                self.localCandidatesLabel?.text = "\(self.localCandidateCount)"
            }
        }
    }
    
    private var hasRemoteSdp: Bool = false {
        didSet {
            DispatchQueue.main.async {
                //                self.remoteSdpStatusLabel?.text = self.hasRemoteSdp ? "✅" : "❌"
            }
        }
    }
    
    private var remoteCandidateCount: Int = 0 {
        didSet {
            DispatchQueue.main.async {
                //                self.remoteCandidatesLabel?.text = "\(self.remoteCandidateCount)"
            }
        }
    }
    
    private var speakerOn: Bool = false {
        didSet {
            //            let title = "Speaker: \(self.speakerOn ? "On" : "Off" )"
            //            self.speakerButton?.setTitle(title, for: .normal)
        }
    }
    
    private var mute: Bool = false {
        didSet {
            //            let title = "Mute: \(self.mute ? "on" : "off")"
            //            self.muteButton?.setTitle(title, for: .normal)
        }
    }
    
    init(signalClient: SignalingClient, webRTCClient: WebRTCClient) {
        self.signalClient = signalClient
        self.webRTCClient = webRTCClient
        super.init(nibName: String(describing: MeetingListViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
        self.signalClient.connect()
    }
    
    @IBAction func joinDidTap(_ sender: UIButton) {
        self.webRTCClient.speakerOn()
        if( !self.hasLocalSdp && !self.hasRemoteSdp )
        {
            self.webRTCClient.offer { (sdp) in
                self.hasLocalSdp = true
                //Omitted self.signalClient.send(sdp: sdp)
            }
        }
        else if( !self.hasLocalSdp && self.hasRemoteSdp )
        {
            self.webRTCClient.answer { (localSdp) in
                self.hasLocalSdp = true
                //Omitted self.signalClient.send(sdp: localSdp)
            }
        }
        
//        conferenceViewController.modalPresentationStyle = .fullScreen
//        self.present(conferenceViewController, animated: false, completion: nil)
    }
    
    @IBAction func backDidTap(_ sender: UIButton)
    {
        self.dismiss(animated: false)
    }
    
}
    
extension MeetingListViewController: SignalClientDelegate {
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        self.signalingConnected = true
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
        self.signalingConnected = false
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
            self.hasRemoteSdp = true
        }
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
        self.webRTCClient.set(remoteCandidate: candidate) { error in
            print("Received remote candidate")
            self.remoteCandidateCount += 1
        }
    }
}

extension MeetingListViewController: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        self.localCandidateCount += 1
        //Omitted self.signalClient.send(candidate: candidate)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
//            let textColor: UIColor
//            switch state {
//            case .connected, .completed:
//                textColor = .green
//            case .disconnected:
//                textColor = .orange
//            case .failed, .closed:
//                textColor = .red
//            case .new, .checking, .count:
//                textColor = .black
//            @unknown default:
//                textColor = .black
//            }
        DispatchQueue.main.async {
            //                self.webRTCStatusLabel?.text = state.description.capitalized
            //                self.webRTCStatusLabel?.textColor = textColor
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
        DispatchQueue.main.async {
            let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
            let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
