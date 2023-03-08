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
    
    private var signalingConnected: Bool = false {
        didSet {
//            DispatchQueue.main.async {
//                if self.signalingConnected {
//                    self.signalingStatusLabel?.text = "Connected"
//                    self.signalingStatusLabel?.textColor = UIColor.green
//                }
//                else {
//                    self.signalingStatusLabel?.text = "Not connected"
//                    self.signalingStatusLabel?.textColor = UIColor.red
//                }
//            }
        }
    }
    
    init() {
        super.init(nibName: String(describing: EditReadViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    }
    
}
//
//extension MainViewController: SignalClientDelegate {
//    func signalClientDidConnect(_ signalClient: SignalingClient) {
//        self.signalingConnected = true
//    }
//
//    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
//        self.signalingConnected = false
//    }
//
//    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
//        print("Received remote sdp")
//        self.webRTCClient.set(remoteSdp: sdp) { (error) in
//            self.hasRemoteSdp = true
//        }
//    }
//
//    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
//        self.webRTCClient.set(remoteCandidate: candidate) { error in
//            print("Received remote candidate")
//            self.remoteCandidateCount += 1
//        }
//    }
//}
//
//extension MainViewController: WebRTCClientDelegate {
//
//    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
//        print("discovered local candidate")
//        self.localCandidateCount += 1
//        self.signalClient.send(candidate: candidate)
//    }
//
//    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
//        let textColor: UIColor
//        switch state {
//        case .connected, .completed:
//            textColor = .green
//        case .disconnected:
//            textColor = .orange
//        case .failed, .closed:
//            textColor = .red
//        case .new, .checking, .count:
//            textColor = .black
//        @unknown default:
//            textColor = .black
//        }
//        DispatchQueue.main.async {
//            self.webRTCStatusLabel?.text = state.description.capitalized
//            self.webRTCStatusLabel?.textColor = textColor
//        }
//    }
//
//    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
//        DispatchQueue.main.async {
//            let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
//            let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//}
