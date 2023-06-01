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
import os.log

enum PipelineMode
{
    case PipelineModeMovieFileOutput
    case PipelineModeAssetWriter
}// internal state machine

class ConferenceViewController: UIViewController, AVCaptureFileOutputRecordingDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var localVideoView: UIView!
    
    @IBOutlet weak var timeSelect: UIPickerView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var remoteCameraView: UIView!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet weak var timeSelectCtrl: UIPickerView!
    @IBOutlet weak var timeSelectPannel: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLeave: UIButton!
    @IBOutlet weak var waitingScreen: UIView!
    
    var count = 3
    var remoteCount = 3
    var timer: Timer!
    var selectedCount = 3
    //Omitted var isRecordEnabled = false
    
    private var signalClient: SignalingClient
    private var webRTCClient: WebRTCClient
    private let signalingClientStatus: SignalingClientStatus
    private var isRecording: Bool = false
    private var _filename = ""
    private var _time: Double = 0
    //Omitted private var _captureSession: AVCaptureSession?
    //Omitted private var _videoOutput: AVCaptureVideoDataOutput?
    private var _assetWriter: AVAssetWriter?
    private var _assetWriterInput: AVAssetWriterInput?
    private var _adpater: AVAssetWriterInputPixelBufferAdaptor?
    private var audioRecorder: AVAudioRecorder?
    //Omitted private var uploadCount = 0
    private var tapeId = ""
    private var tapeDate = ""
    public var audioUrl: URL?
    private var userName: String?
    private var roomUid: String
    private var pingPongRcv: Bool = false
    private var syncTimer: Timer?
    let semaphore = DispatchSemaphore(value: 0)
    
    let videoQueue = DispatchQueue(label: "VideoQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    private let captureSession = AVCaptureSession()
    var movieOutput: AVCaptureMovieFileOutput?
    
    private var waitSecKey: String = "REC_WAIT_SEC"
    var recordingStartCmd: String = "#CMD#REC#START#"
    var recordingEndCmd: String = "#CMD#REC#END#"
    var pingPongSCmd: String = "#CMD#PING#"
    var pingPongRCmd: String = "#CMD#PONG#"
    
    var outputUrl: URL {
        get {
            
            if let url = _outputUrl {
                return url
            }
            
            _outputUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(self.userName!).mp4")
            return _outputUrl!
        }
    }
    private var _outputUrl: URL?
    
    //MARK: WebRTC Conference Status
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
    
    private enum _CaptureState {
        case idle, start, capturing, end
    }
    
    private var _captureState: _CaptureState = _CaptureState.idle {
        didSet {
            DispatchQueue.main.async {
                if self._captureState == .idle
                {
                    self.recordButton.titleLabel?.text = "Start Recording"
                }
                else if self._captureState == .capturing
                {
                    self.recordButton.titleLabel?.text = "Stop Recording"
                }
            }
        }
    }
    
    init(roomUid: String) {
        self.signalClient = buildSignalingClient()
        self.webRTCClient = WebRTCClient(iceServers: signalingServerConfig.webRTCIceServers)
        self.signalingClientStatus = SignalingClientStatus(signalClient: &self.signalClient, webRTCClient: &self.webRTCClient)
        self.roomUid = roomUid
        super.init(nibName: String(describing: ConferenceViewController.self), bundle: Bundle.main)
        
        //        self.signalingConnected = false
        //        self.hasLocalSdp = false
        //        self.hasRemoteSdp = false
        //        self.localCandidateCount = 0
        //        self.remoteCandidateCount = 0
        self.speakerOn = false
        
        self.webRTCClient.delegate = self
        //        self.signalClient.delegate = self
        //        self.signalClient.connect()
        uiViewContoller = self
        
        let waitSec = UserDefaults.standard.integer(forKey: self.waitSecKey)
        count = waitSec == 0 ? 3 : waitSec
        selectedCount = count
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    func dateString() -> String {
    //      let formatter = DateFormatter()
    //      formatter.dateFormat = "ddMMMYY_hhmmssa"
    //      let fileName = formatter.string(from: Date())
    //      return "\(fileName).mp3"
    //    }
    
    //    func getDocumentsDirectory() -> URL {
    //        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    //        return paths[0]
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        waitingScreen.isHidden = false
        lblTimer.isHidden = true
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            userName = userInfo["userName"] as? String
        } else {
            // No data was saved
            print("No data was saved.")
        }
        
        self.timeSelect.delegate = self
        self.timeSelect.dataSource = self
        self.webRTCClient.speakerOn()
        self.signalClient.sendRoomId(roomId: self.roomUid)
        
        let localRenderer = RTCMTLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
        let remoteRenderer = RTCMTLVideoView(frame: self.remoteCameraView.frame)
        localRenderer.videoContentMode = .scaleAspectFill
        remoteRenderer.videoContentMode = .scaleAspectFill
        
        //{{Init to record audio
        let audioTmpUrl = getAudioTempURL()
        //print(self.audioUrl!.absoluteString)
        
        // 4
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            // 5
            //try FileManager.default.removeItem(atPath: audioURL.absoluteString)
            audioRecorder = try AVAudioRecorder(url: audioTmpUrl, settings: settings)
            audioRecorder?.delegate = self
        } catch {
            audioRecorder?.stop()
            //finishRecording(success: false)
        }
        
        //}}Init to record audio
        
        self.webRTCClient.startCaptureLocalVideo(renderer: localRenderer)
        self.webRTCClient.renderRemoteVideo(to: remoteRenderer)
        
        if let localVideoView = self.localVideoView {
            self.embedView(localRenderer, into: localVideoView)
        }
        self.embedView(remoteRenderer, into: self.remoteCameraView)
        self.remoteCameraView.sendSubviewToBack(remoteRenderer)
        setSpeakerVolume(1.0)
        
        videoQueue.async {
            do {
                DispatchQueue.main.async {
                    Toast.show(message: "Initialize for record from camera....", controller: self)
                }
#if !targetEnvironment(simulator)
                try self.configureCaptureSession()
                self.captureSession.startRunning()
#endif
                DispatchQueue.main.async {
                    Toast.show(message: "Initialize done.", controller: self)
                }
            } catch {
                DispatchQueue.main.async {
                    Toast.show(message: "Unable to configure capture session", controller: self)
                }
            }
        }
        
        pingPongRcv = false
        DispatchQueue.main.async {
            self.syncTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(300) / 1000, repeats: true, block: { timer in
                print("signalingConnected:\(self.signalingClientStatus.signalingConnected)")
                let disabledWait = false
#if DISABLE_SYNC
                disabledWait = true
#endif
                
                if((self.signalingClientStatus.signalingConnected && self.pingPongRcv)
                        || disabledWait ){
                    timer.invalidate()
                    //Omitted self.semaphore.signal()
                    DispatchQueue.main.async {
                        self.waitingScreen.isHidden = true
                    }
                    
#if RECORDING_TEST
                    self.recordingDidTap(UIButton())
                    
                    var count = 15
                    _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                        count -= 1
                        if count == 0 {
                            timer.invalidate()
                            self.recordingDidTap(UIButton())
                        }
                    })
#endif
                }
                else
                {
                    self.sendCmd(cmd: self.pingPongSCmd)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Omitted semaphore.wait()//Wait until signal connected
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.syncTimer?.invalidate()
        
        if(_captureState == .capturing){
            recordEnd()
        }
        self.captureSession.stopRunning()
    }
    
    class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        //let documentsDirectory = URL(string: NSTemporaryDirectory())
        return documentsDirectory
    }
    
    func getAudioFileURL(fileName: String) -> URL {
        return ConferenceViewController.getDocumentsDirectory().appendingPathComponent("\(fileName).m4a")
    }
    
    func getAudioTempURL() -> URL {
        return ConferenceViewController.getDocumentsDirectory().appendingPathComponent("audioTemp.m4a")
    }
    
    private func embedView(_ view: UIView, into containerView: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                    options: [],
                                                                    metrics: nil,
                                                                    views: ["view":view]))
        containerView.layoutIfNeeded()
    }
    
    private func checkPermissions()
    {
        let pm = IDPermissionsManager()
        pm.checkCameraAuthorizationStatus(){(granted) -> Void in
            if(!granted){
                os_log("we don't have permission to use the camera")
            }
        }
        
        pm.checkMicrophonePermissions(){(granted) -> Void in
            if(!granted){
                os_log("we don't have permission to use the microphone")
            }
        }
    }
    
    @IBAction func backDidTap(_ sender: UIButton) {
        self.syncTimer?.invalidate()
        
        if(_captureState == .capturing){
            recordEnd()
        }
        
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        
        self.dismiss(animated: false)
        self.signalClient.sendRoomIdClose(roomId: self.roomUid)
    }
    
    @IBAction func leaveDidTap(_ sender: UIButton) {
        backDidTap(sender)
    }
    
    @IBAction func recordingDidTap(_ sender: UIButton) {
        if(_captureState == .idle){
            recordStart()
        }
        else if(_captureState == .capturing){
            recordEnd()
        }
    }
    
    @IBAction func setTimerDidTap(_ sender: Any) {
        timeSelectCtrl .selectRow( self.selectedCount-1, inComponent: 0, animated: true)
        timeSelectPannel.isHidden = false
    }
    
    
    @IBAction func okDidTap(_ sender: Any) {
        UserDefaults.standard.set(self.selectedCount, forKey: self.waitSecKey)
        self.count = selectedCount
        timeSelectPannel.isHidden = true
    }
    
    @IBAction func cancelDidTap(_ sender: Any) {
        timeSelectPannel.isHidden = true
    }
    
    func recordStart(){
        ConferenceViewController.clearTempFolder()
        tapeId = getTapeIdString()
        tapeDate = getDateString()
        
        //Send record cmd to other.
        print("signalingConnected:", signalingClientStatus.signalingConnected)
        let recStart: Data = "\(recordingStartCmd)\(self.tapeDate)#\(self.tapeId)#\(self.count)".data(using: .utf8)!
        self.webRTCClient.sendData(recStart)
        
        self.count = self.selectedCount
        self.lblTimer.text = "\(self.count)"
        lblTimer.isHidden = false
        if timer != nil {
            timer.invalidate()
        }
        
        btnBack.isUserInteractionEnabled = false
        btnLeave.isUserInteractionEnabled = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
            self.count -= 1
            self.lblTimer.text = "\(self.count)"
            if self.count == 0 {
                self.lblTimer.isHidden = true
                timer.invalidate()
#if !targetEnvironment(simulator)
                self.videoQueue.async {
                    self.captureSession.startRunning()
                    self.movieOutput?.startRecording(to: self.outputUrl, recordingDelegate: self)
                }
                self.audioRecorder?.record()
#endif
                self._captureState = .capturing
            }
        })
    }
    
    func recordEnd(){
        let recStart: Data = "\(recordingEndCmd)".data(using: .utf8)!
        self.webRTCClient.sendData(recStart)
        
#if !targetEnvironment(simulator)
        videoQueue.async {
            self.movieOutput?.stopRecording()
        }
        audioRecorder?.stop()
#endif
        _captureState = .idle
        
        self.btnBack.isUserInteractionEnabled = true
        self.btnLeave.isUserInteractionEnabled = true
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            audioRecorder?.stop()
            Toast.show(message: "Audio recording be failed", controller: self)
        }
        else
        {
            let tmpUrl = getAudioTempURL()
            self.audioUrl = getAudioFileURL(fileName: self.userName!)
            do {
                try FileManager.default.moveItem(at: tmpUrl, to: self.audioUrl!)
            } catch {
                print(error)
            }
        }
    }
    
    class func clearTempFolder() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments//.appendingPathComponent("diskCache")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    
    //MARK: Camera Recording
    private func configureCaptureSession() throws {
        captureSession.beginConfiguration()
        
        // Setup video input
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Front camera not found.")
            return
        }
        do {
            let videoInput = try AVCaptureDeviceInput(device: frontCamera)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
        } catch {
            print("Error setting up video input: \(error)")
        }
        
//        // Setup audio input
//        guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
//            print("Audio device not found.")
//            return
//        }
//        do {
//            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
//            if captureSession.canAddInput(audioInput) {
//                captureSession.addInput(audioInput)
//            }
//        } catch {
//            print("Error setting up audio input: \(error)")
//        }
        
        // Setup movie output
        movieOutput = AVCaptureMovieFileOutput()
        if captureSession.canAddOutput(movieOutput!) {
            captureSession.addOutput(movieOutput!)
        }
        captureSession.commitConfiguration()
        
//        // configure audio session
//        let audioSession = AVAudioSession.sharedInstance()
//        try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
//        try audioSession.setActive(true)
//
//        var micPort: AVAudioSessionPortDescription?
//
//        if let inputs = audioSession.availableInputs {
//            for port in inputs {
//                if port.portType == AVAudioSession.Port.builtInMic {
//                    micPort = port
//                    break;
//                }
//            }
//        }
//
//        if let port = micPort, let dataSources = port.dataSources {
//
//            for source in dataSources {
//                if source.orientation == AVAudioSession.Orientation.front {
//                    try audioSession.setPreferredInput(port)
//                    break
//                }
//            }
//        }
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let error = error {
            print("Error recording video: \(error.localizedDescription)")
        } else {
            // Video recorded successfully, you can access the video file at `outputFileURL`
            print("Video recorded: \(outputFileURL.absoluteString)")
            DispatchQueue.global(qos: .userInitiated).async {
                let prefixKey = "\(self.tapeDate)/\((uiViewContoller! as! ConferenceViewController).roomUid)/\(self.tapeId)/"
                print("prefixKey", prefixKey)
                
                DispatchQueue.main.async {
                    Toast.show(message: "Start to upload record files", controller: uiViewContoller!)
                }
                
//                //{{Splite audio and video
//                DispatchQueue.main.async {
//                    saveOnlyVideoFrom(url: outputFileURL) { url in
//                        print(url)
//                        saveOnlyAudioFrom(url: outputFileURL) { url in
//                            print(url)
//                        }
//                    }
//                }
//                //}}Splite audio and video
                
                //Upload video at first
                awsUpload.multipartUpload(filePath: outputFileURL, prefixKey: prefixKey){ error -> Void in
                    if(error == nil)
                    {
                        //Upload audio at secodary
                        awsUpload.multipartUpload(filePath: (uiViewContoller! as! ConferenceViewController).audioUrl!, prefixKey: prefixKey){ (error: Error?) -> Void in
                            if(error == nil)
                            {//Then Upload video
                                DispatchQueue.main.async {
                                    //Omitted hideIndicator(sender: nil)
                                    Toast.show(message: "Completed to upload all record files", controller: uiViewContoller!)
                                }
                                if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
                                    // Use the saved data
                                    let uid = userInfo["uid"] as! String
                                    //let tapeName = "\(getDateString())(\((uiViewContoller! as! ConferenceViewController).tapeId))"
                                    let tapeName = "\((uiViewContoller! as! ConferenceViewController).tapeId)"
                                    webAPI.addLibrary(uid: uid
                                                      , tapeName: tapeName
                                                      , bucketName: "video-client-upload-123456798"
                                                      , tapeKey: "\(prefixKey)\((uiViewContoller! as! ConferenceViewController).userName!)"
                                                      , roomUid: (uiViewContoller! as! ConferenceViewController).roomUid
                                                      , tapeId: (uiViewContoller! as! ConferenceViewController).tapeId)
                                    ConferenceViewController.clearTempFolder()
                                } else {
                                    // No data was saved
                                    print("No data was saved.")
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    //Omitted hideIndicator(sender: nil)
                                    Toast.show(message: "Failed to upload audio file", controller: uiViewContoller!)
                                }
                            }
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            //Omitted hideIndicator(sender: nil)
                            Toast.show(message: "Failed to upload video file", controller: uiViewContoller!)
                        }
                    }
                }
            }//DispatchQueue.global
        }
    }
    
    func sendCmd(cmd: String){
        let recStart: Data = "\(cmd)".data(using: .utf8)!
        self.webRTCClient.sendData(recStart)
    }
}

//MARK: UIPickerViewDelegate
extension ConferenceViewController: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row+1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        self.selectedCount = row+1
    }
}

//MARK: WebRTCClientDelegate
extension ConferenceViewController: WebRTCClientDelegate {
    
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
        let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
        let startCmd = "\(recordingStartCmd)"//String(describing: "#CMD#REC#START#".cString(using: String.Encoding.utf8))
        let endCmd = "\(recordingEndCmd)"//String(describing: "#CMD#REC#END#".cString(using: String.Encoding.utf8))
        let pingCmd = "\(pingPongSCmd)"
        let pongCmd = "\(pingPongRCmd)"
        let  preStartCmdToken = message.prefix(strlen(startCmd))
        if(preStartCmdToken.compare(startCmd).rawValue == 0)
        {//recording Start
            if(_captureState == .idle){
                print("Start recording remotely")
                ConferenceViewController.clearTempFolder()
                let range = message.index(message.startIndex, offsetBy: (strlen(startCmd)))..<message.endIndex
                let keyInfo = String(message[range])
                let keyInfoArr = keyInfo.components(separatedBy: "#")
                self.tapeDate   = keyInfoArr[0]
                self.tapeId = keyInfoArr[1]
                self.remoteCount = Int(keyInfoArr[2])!
                
                DispatchQueue.main.async {
                    self.lblTimer.text = "\(self.remoteCount)"
                    self.lblTimer.isHidden = false
                    if self.timer != nil {
                        self.timer.invalidate()
                    }
                    
                    self.btnBack.isUserInteractionEnabled = false
                    self.btnLeave.isUserInteractionEnabled = false
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                        self.remoteCount -= 1
                        self.lblTimer.text = "\(self.remoteCount)"
                        if self.remoteCount == 0 {
                            self.lblTimer.isHidden = true
                            timer.invalidate()
#if !targetEnvironment(simulator)
                            print("Start recording remotely: begin->")
                            self.videoQueue.async {
                                self.captureSession.startRunning()
                                self.movieOutput?.startRecording(to: self.outputUrl, recordingDelegate: self)
                            }
                            self.audioRecorder?.record()
#endif
                            self._captureState = .capturing
                        }
                    })
                }
            }
        }
        else if(message.compare(endCmd).rawValue == 0)
        {//recording end
            if(_captureState == .capturing){
#if !targetEnvironment(simulator)
                print("End recording remotely")
                videoQueue.async {
                    self.movieOutput?.stopRecording()
                }
                audioRecorder?.stop()
#endif
                _captureState = .idle
            }
            
            self.btnBack.isUserInteractionEnabled = true
            self.btnLeave.isUserInteractionEnabled = true
        }
        else if(message.compare(pingCmd).rawValue == 0)
        {//received ping cmd
            self.sendCmd(cmd: pingPongRCmd)
        }
        else if(message.compare(pongCmd).rawValue == 0)
        {//received pong cmd
            self.pingPongRcv = true
        }
        
        DispatchQueue.main.async {
            //REFME
            //            let message = String(data: data, encoding: .utf8) ?? "(Binary: \(data.count) bytes)"
            //            let alert = UIAlertController(title: "Message from WebRTC", message: message, preferredStyle: .alert)
            //            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            //            self.present(alert, animated: true, completion: nil)
        }
    }
}
