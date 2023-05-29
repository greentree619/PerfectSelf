//
//  AppDelegate.swift
//  WebRTC
//
//  Created by Stasel on 20/05/2018.
//  Copyright © 2018 Stasel. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn

@available(iOS 14.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    internal var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: [.allowBluetooth])
           try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self.buildMainViewController()
        window.makeKeyAndVisible()
        self.window = window
        IQKeyboardManager.shared.enable = true
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions) { _, _ in }
        // 3
        application.registerForRemoteNotifications()
        
//        //{{Test localtime<->UTC
//        var dt:String = "2023-05-16T20:30:00"
//        dt = localToUTC(dateStr: dt)!
//        dt = utcToLocal(dateStr: dt)!
//
//        dt = "2023-05-16T20:30:00"
//        dt = localToUTCEx(dateStr: dt)!
//        dt = utcToLocalEx(dateStr: dt)!
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//
//        // Set the local time zone
//        dateFormatter.timeZone = TimeZone.current
//
//        // Create a sample local date
//        let localDate = dateFormatter.date(from: "2023-05-16T20:30:00")!
//
//        // Convert the local date to UTC
//        dateFormatter.timeZone = TimeZone(identifier: "UTC")
//        let utcDate = dateFormatter.string(from: localDate)
//
//        print("UTC Date: \(utcDate)")
//        //}}
        return true
    }
    
    private func buildMainViewController() -> UIViewController {
        
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            
            let userType = userInfo["userType"] as? Int
            let controller = userType == 3 ? ActorTabBarController(): ReaderTabBarController()
            controller.modalPresentationStyle = .fullScreen
            
            return controller
            
        } else {
            // No data was saved
            print("No data was saved.")
            let mainViewController = LoginViewController()
//            let navViewController = UINavigationController(rootViewController: mainViewController)
//            navViewController.navigationBar.prefersLargeTitles = true
//            navViewController.isNavigationBarHidden = true
//            return navViewController
            return mainViewController
        }
    }

    ///MARK: google sigin
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
//    
//    // MARK: UISceneSession Lifecycle
}

@available(iOS 14.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        fcmDeviceToken = token
        print("Device Token: \(token)")
        //Toast.show(message: "register: \(token)", controller: uiViewContoller!)
        
        DispatchQueue.main.async {
            if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
                let uid = userInfo["uid"] as! String
                let token = userInfo["fcmDeviceToken"] as! String
                if(token != fcmDeviceToken)
                {
                    webAPI.updateUserInfo(uid: uid, userType: -1, bucketName: "", avatarKey: "", username: "", email: "", password: "", firstName: "", lastName: "", dateOfBirth: "", gender: -1, currentAddress: "", permanentAddress: "", city: "", nationality: "", phoneNumber: "", isLogin: true, fcmDeviceToken: fcmDeviceToken, deviceKind: -1)  { data, response, error in
                        if error == nil {
                            // successfully update db
                            print("update db completed")
                        }
                    }
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
        //Toast.show(message: "register: \(error.localizedDescription)", controller: uiViewContoller!)
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([[.banner, .sound]])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
