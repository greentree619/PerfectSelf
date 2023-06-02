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

    ///MARK: google sigin
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
//    
//    // MARK: UISceneSession Lifecycle
}

@available(iOS 14.0, *)
extension AppDelegate{
    private func buildMainViewController() -> UIViewController {
#if RECORDING_TEST
        let JSON = """
        {
            "uid": "a732ed6c-16ed-42f4-b4f2-4d0952a83d06",
            "userType": 4,
            "avatarBucketName": "",
            "avatarKey": "",
            "userName": "Marcelino",
            "email": "reader003@gmail.com",
            "password": "",
            "firstName": "Gray",
            "lastName": "Johns",
            "dateOfBirth": "",
            "gender": 0,
            "currentAddress": "",
            "permanentAddress": "",
            "city": "",
            "nationality": "",
            "phoneNumber": "123456",
            "isLogin": true,
            "token": "CHWaBF/okE6MDZh4XnEbOA==",
            "fcmDeviceToken": "",
            "deviceKind": 0,
            "id": 25,
            "isDeleted": false,
            "createdTime": "2023-03-24T01:59:15.8911716",
            "updatedTime": "2023-03-24T01:59:15.8911727",
            "deletedTime": "0001-01-01T00:00:00"
          }
        """
        
        let data = JSON.data(using: .utf8)!
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        let userJson = responseJSON as! [String:Any]
        print(userJson["userType"]!)
        UserDefaults.standard.setValue(userJson, forKey: "USER")
#endif
        
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
                let bucketName = userInfo["avatarBucketName"] as? String
                let avatarKey = userInfo["avatarKey"] as? String
                
                if(token.compare(fcmDeviceToken).rawValue != 0 )
                {
                    webAPI.updateUserInfo(uid: uid, userType: -1, bucketName: bucketName ?? "", avatarKey: avatarKey ?? "", username: "", email: "", password: "", firstName: "", lastName: "", dateOfBirth: "", gender: -1, currentAddress: "", permanentAddress: "", city: "", nationality: "", phoneNumber: "", isLogin: true, fcmDeviceToken: fcmDeviceToken, deviceKind: -1)  { data, response, error in
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
        completionHandler([[.banner, .badge, .sound]])
//        print("User Info = ",notification.request.content.userInfo)
//        if (UIApplication.shared.applicationState == .background) {
//            print("User Info = ",notification.request.content.userInfo)
//            //NSLog("Notification received in background: title:\"\(title)\" body:\"\(body)\"")
//        } else
//        {
//            let alertController = UIAlertController(title: "Notification - PefectSelf", message: "Resered Booking from actor", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
//
//            //Force
//            //UIApplication.shared.windows.first?.rootViewController!.present(..)
//
//            //Safe
//            guard let viewController = UIApplication.shared.windows.first?.rootViewController else {return}
//            viewController.present(alertController, animated: true)
//
//            //self.present(alertController, animated: true)
//        }
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
