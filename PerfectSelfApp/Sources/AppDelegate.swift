//
//  AppDelegate.swift
//  WebRTC
//
//  Created by Stasel on 20/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    internal var window: UIWindow?
    //Omitted private let config = Config.default
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self.buildMainViewController()
        window.makeKeyAndVisible()
        self.window = window
        IQKeyboardManager.shared.enable = false
        return true
    }
    
    private func buildMainViewController() -> UIViewController {
        
//        let webRTCClient = WebRTCClient(iceServers: self.config.webRTCIceServers)
//        let signalClient = self.buildSignalingClient()
//        //{{
////        let mainViewController = MainViewController(signalClient: signalClient, webRTCClient: webRTCClient)
//        //==
//        let mainViewController = MeetingListViewController(signalClient: signalClient, webRTCClient: webRTCClient)
//        //}}
        
        let mainViewController = LoginViewController()
        let navViewController = UINavigationController(rootViewController: mainViewController)
        navViewController.navigationBar.prefersLargeTitles = true
        navViewController.isNavigationBarHidden = true
        return navViewController
    }
}

