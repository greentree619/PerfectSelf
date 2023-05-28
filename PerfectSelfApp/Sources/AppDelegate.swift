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
//        requestPushAuthorization()
//        registerForNotifications()
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//          if let error = error {
//          print("D'oh: \(error.localizedDescription)")
//          } else {
//          application.registerForRemoteNotifications()
//          }
//        }
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
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        //Toast.show(message: "userNotificationCenter", controller: uiViewContoller!)
//        completionHandler([.banner, .badge, .sound])
//    }

    ///MARK: google sigin
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
//    @available(iOS 9.0, *)
//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
//        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
//        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
//        return GIDSignIn.sharedInstance().handle(url)
//    }
//    
//    // MARK: UISceneSession Lifecycle
//    
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//    
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
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
