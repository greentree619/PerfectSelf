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

class ConferenceViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVAudioRecorderDelegate {
    
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
    var isRecordEnabled = false
    
    private var signalClient: SignalingClient
    private var webRTCClient: WebRTCClient
    private let signalingClientStatus: SignalingClientStatus
    private var isRecording: Bool = false
    private var _filename = ""
    private var _time: Double = 0
    private var _captureSession: AVCaptureSession?
    private var _videoOutput: AVCaptureVideoDataOutput?
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
    
    //Omitted let videoQueue = DispatchQueue(label: "VideoQueue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
    //Omitted private let captureSession = AVCaptureSession()
    //Omitted var movieOutput: AVCaptureMovieFileOutput?
    
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
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
           let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            log(meetingUid: roomUid, log:"\(self.userName!) app version \(version).\(build)")
        }
        
        self.timeSelect.delegate = self
        self.timeSelect.dataSource = self
        self.webRTCClient.speakerOn()
        self.signalClient.sendRoomId(roomId: self.roomUid)
        
        let localRenderer = RTCMTLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
        let remoteRenderer = RTCMTLVideoView(frame: self.remoteCameraView.frame)
        localRenderer.videoContentMode = .scaleAspectFill
        remoteRenderer.videoContentMode = .scaleAspectFill
#if !targetEnvironment(simulator)
        //{{ Init to record video.
        let output = AVCaptureVideoDataOutput()
        guard let capturer = self.webRTCClient.videoCapturer as? RTCCameraVideoCapturer else {
            return
        }
        capturer.captureSession.canAddOutput(output)
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "com.yusuke024.video"))
        capturer.captureSession.beginConfiguration()
        if(capturer.captureSession.canAddOutput(output))
        {
            isRecordEnabled = true
            capturer.captureSession.addOutput(output)
        }
        else
        {
            isRecordEnabled = false
        }
        
        if( capturer.captureSession.canSetSessionPreset(AVCaptureSession.Preset.hd1280x720) )
        {
            capturer.captureSession.sessionPreset = AVCaptureSession.Preset.high
        }
        capturer.captureSession.commitConfiguration()
        _videoOutput = output
        _captureSession = capturer.captureSession
        //}} Init to record video.
        
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
#endif
        self.webRTCClient.startCaptureLocalVideo(renderer: localRenderer)
        self.webRTCClient.renderRemoteVideo(to: remoteRenderer)
        
        if let localVideoView = self.localVideoView {
            self.embedView(localRenderer, into: localVideoView)
        }
        self.embedView(remoteRenderer, into: self.remoteCameraView)
        self.remoteCameraView.sendSubviewToBack(remoteRenderer)
        setSpeakerVolume(1.0)
        
        pingPongRcv = false
        DispatchQueue.main.async {
            self.syncTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(300) / 1000, repeats: true, block: { timer in
                print("signalingConnected:\(self.signalingClientStatus.signalingConnected)")
                var disabledWait: Bool = false
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
                    log(meetingUid: self.roomUid, log:"\(self.userName!) start meeting.")
                    
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
        log(meetingUid: roomUid, log:"\(self.userName!) entered in room")
        
        if(!isRecordEnabled)
        {
            log(meetingUid: roomUid, log:"\(self.userName!): his device don't support to record from local camera while take meeting.")
            let alert = UIAlertController(title: "Warning", message: "This device don't support to record from local camera while take meeting.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        log(meetingUid: self.roomUid, log:"\(self.userName!) exit meeting.")
        
        self.syncTimer?.invalidate()
        
        if(_captureState == .capturing){
            recordEnd()
        }
        //Omitted self.captureSession.stopRunning()
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
            log(meetingUid: self.roomUid, log:"\(self.userName!) start recording(waiting: \(self.selectedCount).")
            recordStart()
        }
        else if(_captureState == .capturing){
            log(meetingUid: self.roomUid, log:"\(self.userName!) end recording.")
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
        self.count = self.selectedCount
        print("signalingConnected:", signalingClientStatus.signalingConnected)
        let recStart: Data = "\(recordingStartCmd)\(self.tapeDate)#\(self.tapeId)#\(self.count)".data(using: .utf8)!
        self.webRTCClient.sendData(recStart)
        
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
                self._captureState = .start
                self.audioRecorder?.record()
            }
        })
    }
    
    func recordEnd(){
        let recStart: Data = "\(recordingEndCmd)".data(using: .utf8)!
        self.webRTCClient.sendData(recStart)
        _captureState = .end
        audioRecorder?.stop()
        
        self.btnBack.isUserInteractionEnabled = true
        self.btnLeave.isUserInteractionEnabled = true
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let timestamp = CMSampleBufferGetPresentationTimeStamp(sampleBuffer).seconds
        switch _captureState {
        case .start:
            // Set up recorder
            DispatchQueue.main.async {
                Toast.show(message: "Recording start...", controller: uiViewContoller!)
            }
            log(meetingUid: self.roomUid, log:"\(self.userName!) video recording module start")
            
            _filename = self.userName!//UUID().uuidString
            let videoPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(_filename).mp4")
            //let videoPath = URL(string: "\(NSTemporaryDirectory())\(_filename).mp4")
            
            let writer = try! AVAssetWriter(outputURL: videoPath, fileType: .mp4)
            let settings = _videoOutput!.recommendedVideoSettingsForAssetWriter(writingTo: .mp4)
            let input = AVAssetWriterInput(mediaType: .video, outputSettings: settings) // [AVVideoCodecKey: AVVideoCodecType.h264, AVVideoWidthKey: 1920, AVVideoHeightKey: 1080])
            input.mediaTimeScale = CMTimeScale(bitPattern: 600)
            input.expectsMediaDataInRealTime = true
            input.transform = getVideoTransform()//CGAffineTransform(rotationAngle: .pi/2)
            let adapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: input, sourcePixelBufferAttributes: nil)
            if writer.canAdd(input) {
                writer.add(input)
            }
            writer.startWriting()
            writer.startSession(atSourceTime: .zero)
            _assetWriter = writer
            _assetWriterInput = input
            _adpater = adapter
            _captureState = .capturing
            _time = timestamp
            break
        case .capturing:
            if _assetWriterInput?.isReadyForMoreMediaData == true {
                let time = CMTime(seconds: timestamp - _time, preferredTimescale: CMTimeScale(600))
                _adpater?.append(CMSampleBufferGetImageBuffer(sampleBuffer)!, withPresentationTime: time)
            }
            break
        case .end:
            log(meetingUid: self.roomUid, log:"\(self.userName!) video recording module end")
            DispatchQueue.main.async {
                Toast.show(message: "Recording end...", controller: uiViewContoller!)
            }
            
            guard _assetWriterInput?.isReadyForMoreMediaData == true, _assetWriter!.status != .failed else { break }
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("\(self.userName!).mp4")
            //let url = URL(string: "\(NSTemporaryDirectory())\(self.userName!).mp4")
            _assetWriterInput?.markAsFinished()
            _assetWriter?.finishWriting { [weak self] in
                self?._captureState = .idle
                self?._assetWriter = nil
                self?._assetWriterInput = nil
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    //                let activity = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    //                    self?.present(activity, animated: true, completion: nil)
                    let roomUid = (uiViewContoller! as! ConferenceViewController).roomUid
                    let prefixKey = "\(self!.tapeDate)/\(roomUid)/\(self!.tapeId)/"
                    //Omitted let awsUpload = AWSMultipartUpload()
                    DispatchQueue.main.async {
                        //Omitted showIndicator(sender: nil, viewController: uiViewContoller!, color:UIColor.white)
                        Toast.show(message: "Start to upload record files", controller: uiViewContoller!)
                    }
                    
                    log(meetingUid: roomUid, log:"\(self!.userName!) video upload start: \(prefixKey)")
                    //Upload video at first
                    awsUpload.multipartUpload(filePath: url, prefixKey: prefixKey){ error -> Void in
                        if(error == nil)
                        {
                            log(meetingUid: roomUid, log:"\(self!.userName!) video upload end successfully")
                            DispatchQueue.main.async {
                                //Omitted hideIndicator(sender: nil)
                                Toast.show(message: "Completed to upload Video file. Audio file is on uploading.", controller: uiViewContoller!)
                            }
                            
                            log(meetingUid: roomUid, log:"\(self!.userName!) audio upload start")
                            //Upload audio at secodary
                            awsUpload.multipartUpload(filePath: (uiViewContoller! as! ConferenceViewController).audioUrl!, prefixKey: prefixKey){ (error: Error?) -> Void in
                                if(error == nil)
                                {//Then Upload video
                                    log(meetingUid: roomUid, log:"\(self!.userName!) audio upload end successfully.")
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
                                        //Omitted (uiViewContoller! as! ConferenceViewController).uploadCount += 1
                                    } else {
                                        // No data was saved
                                        print("No data was saved.")
                                    }
                                }
                                else
                                {
                                    log(meetingUid: roomUid, log:"\(self!.userName!) audio upload failed")
                                    DispatchQueue.main.async {
                                        //Omitted hideIndicator(sender: nil)
                                        Toast.show(message: "Failed to upload audio file", controller: uiViewContoller!)
                                    }
                                }
                            }
                        }
                        else
                        {
                            log(meetingUid: roomUid, log:"\(self!.userName!) video upload failed:\(error!.localizedDescription)")
                            DispatchQueue.main.async {
                                //Omitted hideIndicator(sender: nil)
                                Toast.show(message: "Failed to upload video file", controller: uiViewContoller!)
                            }
                        }
                    }
                }//DispatchQueue.global
            }
            break
        default:
            break
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            audioRecorder?.stop()
            Toast.show(message: "Audio recording be failed", controller: self)
        }
        else
        {
            log(meetingUid: self.roomUid, log:"\(self.userName!) audio recording successfully.")
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
                ConferenceViewController.clearTempFolder()
                let range = message.index(message.startIndex, offsetBy: (strlen(startCmd)))..<message.endIndex
                let keyInfo = String(message[range])
                let keyInfoArr = keyInfo.components(separatedBy: "#")
                self.tapeDate   = keyInfoArr[0]
                self.tapeId = keyInfoArr[1]
                self.remoteCount = Int(keyInfoArr[2])!
                print("Start recording remotely: \(self.remoteCount)")
                log(meetingUid: self.roomUid, log:"\(self.userName!) start recording remotely(waiting: \(self.remoteCount).")
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
                            self._captureState = .start
                            self.audioRecorder?.record()
                        }
                    })
                }
            }
        }
        else if(message.compare(endCmd).rawValue == 0)
        {//recording end
            if(_captureState == .capturing){
                _captureState = .end
                audioRecorder?.stop()
            }
            log(meetingUid: self.roomUid, log:"\(self.userName!) end recording remotely")
            self.btnBack.isUserInteractionEnabled = true
            self.btnLeave.isUserInteractionEnabled = true
        }
        else if(message.compare(pingCmd).rawValue == 0)
        {//received ping cmd
            self.sendCmd(cmd: pingPongRCmd)
            print("Send Pong")
            log(meetingUid: self.roomUid, log:"\(self.userName!) received other side ping. hence pong...")
        }
        else if(message.compare(pongCmd).rawValue == 0)
        {//received pong cmd
            self.pingPongRcv = true
            print("Received Pong")
            log(meetingUid: self.roomUid, log:"\(self.userName!) received pong. signal OK.")
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
