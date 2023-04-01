//
//  ActorChatViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import WebRTC
import os.log

struct CustomMessage: Codable {
    let text: String
    let type: String
}
class ChatViewController: KUIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var modal_confirm_call: UIStackView!
    @IBOutlet weak var noMessage: UIStackView!
    let backgroundView = UIView()

    
    @IBOutlet weak var messageCollectionView: UICollectionView!
    @IBOutlet weak var messageTextField: UITextField!

    var messages: [CustomMessage] = []
    let cellsPerRow = 1
    var kkk = 0
    private let signalClient: SignalingClient
    private let webRTCClient: WebRTCClient
    private var roomUid: String
    
    //MARK: WebRTC Conference Status
    private var signalingConnected: Bool = false {
        didSet {
//REFME
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
    
    private var hasLocalSdp: Bool = false {
        didSet {
//REFME
//            DispatchQueue.main.async {
//                self.localSdpStatusLabel?.text = self.hasLocalSdp ? "✅" : "❌"
//            }
        }
    }
    
    private var localCandidateCount: Int = 0 {
        didSet {
//REFME
//            DispatchQueue.main.async {
//                self.localCandidatesLabel?.text = "\(self.localCandidateCount)"
//            }
        }
    }
    
    private var hasRemoteSdp: Bool = false {
        didSet {
//REFME
//            DispatchQueue.main.async {
//                self.remoteSdpStatusLabel?.text = self.hasRemoteSdp ? "✅" : "❌"
//            }
        }
    }
    
    private var remoteCandidateCount: Int = 0 {
        didSet {
//REFME
//            DispatchQueue.main.async {
//                self.remoteCandidatesLabel?.text = "\(self.remoteCandidateCount)"
//            }
        }
    }
    
    private var speakerOn: Bool = false {
        didSet {
//REFME
//            let title = "Speaker: \(self.speakerOn ? "On" : "Off" )"
//            self.speakerButton?.setTitle(title, for: .normal)
        }
    }
    
    private var mute: Bool = false {
        didSet {
//REFME
//            let title = "Mute: \(self.mute ? "on" : "off")"
//            self.muteButton?.setTitle(title, for: .normal)
        }
    }
    
    init(signalClient: inout SignalingClient, webRTCClient: inout WebRTCClient, roomUid: String) {
        self.signalClient = signalClient
        self.webRTCClient = webRTCClient
        self.roomUid = roomUid
        super.init(nibName: String(describing: ChatViewController.self), bundle: Bundle.main)
        
        self.signalingConnected = false
        self.hasLocalSdp = false
        self.hasRemoteSdp = false
        self.localCandidateCount = 0
        self.remoteCandidateCount = 0
        self.speakerOn = false
        
        self.webRTCClient.delegate = self
        self.signalClient.delegate = self
        self.signalClient.connect()
        uiViewContoller = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        modal_confirm_call.isHidden = true;
        noMessage.isHidden = false;
        
        let nib = UINib(nibName: "MessageCell", bundle: nil)
        messageCollectionView.register(nib, forCellWithReuseIdentifier: "Message Cell")
        messageCollectionView.dataSource = self
        messageCollectionView.delegate = self
        
        self.webRTCClient.speakerOff()
        if( !self.hasLocalSdp && !self.hasRemoteSdp )
        {
            self.webRTCClient.offer { (sdp) in
                self.hasLocalSdp = true
                self.signalClient.send(sdp: sdp, roomId: self.roomUid)
            }
        }
        else if( !self.hasLocalSdp && self.hasRemoteSdp )
        {
            self.webRTCClient.answer { (localSdp) in
                self.hasLocalSdp = true
                self.signalClient.send(sdp: localSdp, roomId: self.roomUid)
            }
        }
    }

    @IBAction func SendMessage(_ sender: UIButton) {
        
        //Omitted kkk = kkk + 1
        guard let text = messageTextField.text, !text.isEmpty else {
            return // Don't send empty messages
        }
        noMessage.isHidden = true;
        messageTextField.text = ""
        let message = CustomMessage(text: text, type: "sent")// Create a new message object
        messages.append(message) // Add the new message to the messages array

        messageCollectionView.reloadData() // Refresh the table view to display the new message
        // Scroll to the last item in collection view
        let lastItemIndex = messageCollectionView.numberOfItems(inSection: 0) - 1
        let lastIndexPath = IndexPath(item: lastItemIndex, section: 0)
        messageCollectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: true)
        // TODO: Send the message to the server or save it to local storage
        
        let recStart: Data = text.data(using: .utf8)!
        self.webRTCClient.sendData(recStart)
    }
    // MARK: - Message List Delegate.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         // myData is the array of items
        return self.messages.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1))
        let size = (collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow)
        
        let messageText = messages[indexPath.row].text
        let messageTextHeight = messageText.height(withConstrainedWidth: size-20, font: UIFont.systemFont(ofSize: 14))
        
        let totalHeight = messageTextHeight + 16 // add 56 for the height of the profile image and padding
        
        return CGSize(width: size, height: totalHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Message Cell", for: indexPath) as! MessageCell
//        cell.lbl_unviewednum.text = self.messages[indexPath.row];
        cell.messageLabel.text = self.messages[indexPath.row].text
        cell.messageType = self.messages[indexPath.row].type
        // return card
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOffset = CGSizeZero
//        cell.layer.shadowRadius = 8
//        cell.layer.shadowOpacity = 0.2
//        cell.contentView.layer.cornerRadius = 12
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true
//        cell.backgroundColor = .red
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        // add the code here to perform action on the cell
//        print("didDeselectItemAt" + String(indexPath.row))
//        let controller = ChatViewController();
//        self.navigationController?.pushViewController(controller, animated: true);
////        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
//    }
  
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let message = messages[indexPath.row]
//        let messageText = message
//
//        let messageTextWidth = tableView.bounds.width - 16 // subtract 16 for padding
//        let messageTextHeight = messageText.height(withConstrainedWidth: messageTextWidth, font: UIFont.systemFont(ofSize: 17))
//
//        let totalHeight = messageTextHeight + 56 // add 56 for the height of the profile image and padding
//
//        return totalHeight
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Table View Cell", for: indexPath) as! TableViewCell
//
//        let message = messages[indexPath.row]
//        cell.messageLabel.text = message
//        cell.timestampLabel.text = Date().description // or format the date string as desired
//        cell.messageType = message == "hi" ? .sent : .received
//        return cell
//    }
       
    @IBAction func CancelCall(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            //use if you wish to darken the background
            //self.viewDim.alpha = 0
            self.modal_confirm_call.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
        }) { (success) in
            self.backgroundView.removeFromSuperview()
            self.self.modal_confirm_call.isHidden = true;
        }
    }
    @IBAction func ConfirmCall(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            //use if you wish to darken the background
            //self.viewDim.alpha = 0
            self.modal_confirm_call.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            
        }) { (success) in
            self.backgroundView.removeFromSuperview()
            self.self.modal_confirm_call.isHidden = true;
        }
    }
    @IBAction func DoVoiceCall(_ sender: UIButton) {
        view.endEditing(true)
        modal_confirm_call.isHidden = false;
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundView, belowSubview: modal_confirm_call)
 
        modal_confirm_call.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.modal_confirm_call.transform = .identity
        })
    }
    
    @IBAction func DoVideoCall(_ sender: UIButton) {
        view.endEditing(true)
        modal_confirm_call.isHidden = false;
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundView, belowSubview: modal_confirm_call)
        
        modal_confirm_call.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.modal_confirm_call.transform = .identity
        })
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
//        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: false)
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


//MARK: SignalClientDelegate
extension ChatViewController: SignalClientDelegate {
    func signalClientDidConnect(_ signalClient: SignalingClient) {
        //REFME self.signalingConnected = true
    }
    
    func signalClientDidDisconnect(_ signalClient: SignalingClient) {
        //REFME self.signalingConnected = false
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveRemoteSdp sdp: RTCSessionDescription) {
        print("Received remote sdp")
        self.webRTCClient.set(remoteSdp: sdp) { (error) in
            //REFME self.hasRemoteSdp = true
        }
    }
    
    func signalClient(_ signalClient: SignalingClient, didReceiveCandidate candidate: RTCIceCandidate) {
        self.webRTCClient.set(remoteCandidate: candidate) { error in
            print("Received remote candidate")
            //REFME self.remoteCandidateCount += 1
        }
    }
}

//MARK: WebRTCClientDelegate
extension ChatViewController: WebRTCClientDelegate {
    
    func webRTCClient(_ client: WebRTCClient, didDiscoverLocalCandidate candidate: RTCIceCandidate) {
        print("discovered local candidate")
        //REFME self.localCandidateCount += 1
        self.signalClient.send(candidate: candidate, roomId: self.roomUid)
    }
    
    func webRTCClient(_ client: WebRTCClient, didChangeConnectionState state: RTCIceConnectionState) {
//REFME
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
        DispatchQueue.main.async {
            //REFME self.webRTCStatusLabel?.text = state.description.capitalized
            //REFME self.webRTCStatusLabel?.textColor = textColor
        }
    }
    
    func webRTCClient(_ client: WebRTCClient, didReceiveData data: Data) {
        DispatchQueue.main.async {
            let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
            let messageWrap = CustomMessage(text: message, type: "received")// Create a new message object
            self.messages.append(messageWrap) // Add the new message to the messages array
            self.messageCollectionView.reloadData() // Refresh the table view to display the new message
        }
    }
}
