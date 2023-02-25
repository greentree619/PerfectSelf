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

class ConferenceViewController: UIViewController, IDCaptureSessionCoordinatorDelegate {
    @IBOutlet weak var localVideoView: UIView!
    private let webRTCClient: WebRTCClient
    private var isRecording: Bool = false
    private var captureSessionCoordinator: IDCaptureSessionCoordinator?
    
    init(webRTCClient: WebRTCClient) {
        self.webRTCClient = webRTCClient
        super.init(nibName: String(describing: ConferenceViewController.self), bundle: Bundle.main)
        self.setupWithPipelineMode(mode: .PipelineModeAssetWriter)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localRenderer = RTCMTLVideoView(frame: self.localVideoView?.frame ?? CGRect.zero)
        let remoteRenderer = RTCMTLVideoView(frame: self.view.frame)
        localRenderer.videoContentMode = .scaleAspectFill
        remoteRenderer.videoContentMode = .scaleAspectFill
        
        
        self.webRTCClient.startCaptureLocalVideo(renderer: localRenderer)
        self.webRTCClient.renderRemoteVideo(to: remoteRenderer)
        
        if let localVideoView = self.localVideoView {
            self.embedView(localRenderer, into: localVideoView)
        }
        self.embedView(remoteRenderer, into: self.view)
        self.view.sendSubviewToBack(remoteRenderer)
        
        self.startRecording()
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
    
    private func setupWithPipelineMode( mode: PipelineMode )
    {
        self.checkPermissions()
        
        switch mode{
        case .PipelineModeMovieFileOutput:
            self.captureSessionCoordinator = IDCaptureSessionMovieFileOutputCoordinator()
        case .PipelineModeAssetWriter:
            self.captureSessionCoordinator = IDCaptureSessionAssetWriterCoordinator()
            //[self showCameraPreview];
            //                [((IDCaptureSessionAssetWriterCoordinator *)_captureSessionCoordinator) setCameraFilterPreview:transformResultView];
            //                [((IDCaptureSessionAssetWriterCoordinator *)_captureSessionCoordinator) setFilterHandler:^CIImage *(CIImage * inputImage) {
            //                    return [self cameraFilterProcess:inputImage];
            //                }];
        }
//        [_captureSessionCoordinator setDelegate:self callbackQueue:dispatch_get_main_queue()];
//        [self configureInterface];
        self.captureSessionCoordinator?.setDelegate(self, callbackQueue: DispatchQueue.main)
        self.captureSessionCoordinator?.startRunning()
    }
    
    private func startRecording()
    {
        if( isRecording == true ) {return}
        
        //[UIApplication sharedApplication].idleTimerDisabled = YES;
        //self.exportButton.enabled = NO; // re-enabled once recording has finished starting

        self.captureSessionCoordinator?.startRecording();
        isRecording = true;
    }

    func stopRecording()
    {
        //SVProgressHUD.show()
        //TODO: tear down pipeline
        if(self.isRecording){
            //[self->recordTimer invalidate];
            //self.dismissing = YES;
            self.captureSessionCoordinator?.stopRecording();
        } else {
//            [self stopPipelineAndDismiss];
            //SVProgressHUD.dismiss()
        }
    }
    
    @IBAction func backDidTap2(_ sender: Any) {
        self.stopRecording()
        self.dismiss(animated: false)
    }
    
    //Delegate
    func coordinatorDidBeginRecording(_ coordinator: IDCaptureSessionCoordinator!) {
        
    }
    
    func coordinator(_ coordinator: IDCaptureSessionCoordinator!, didFinishRecordingToOutputFileURL outputFileURL: URL!, error: Error!) {
        self.isRecording = false
        
//        [UIApplication sharedApplication].idleTimerDisabled = NO;
//
//        //Omited self.exportButton.title = @"Record";
//        self.recording = NO;
//
//        //Do something useful with the video file available at the outputFileURL
//        IDFileManager *fm = [IDFileManager new];
//        fm.delegate = self;
//        [fm copyFileToCameraRoll:outputFileURL];
//
//        //Dismiss camera (when user taps cancel while camera is recording)
//        if(self.dismissing){
//            [self stopPipelineAndDismiss];
//        }
    }
}
