//
//  Global.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/1/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
import UIKit

let webAPI = PerfectSelfWebAPI()
let ACTOR_UTYPE = 3
let READER_UTYPE = 4
var backgroundView: UIView? = nil
var activityIndicatorView: UIActivityIndicatorView? = nil

//struct Message: Codable {
//    let text: String
//    let timestamp: String
//}
enum MessageType {
    case sent
    case received
}

struct ReaderProfileDetail: Codable {
    let id: Int
    let readerUid: String
    let about: String
    let others: Int
    let skills: String
    let title: String?
    let voiceType: Int
    let hourlyPrice: Int?
    let date: String?
    let from: String?
    let to: String?
}

struct ReaderProfileCard: Codable {
    let uid: String
    let userName: String
    let userType: Int
    let email: String
    let firstName: String
    let lastName: String
    let title: String?
    let gender: Int
    let isLogin: Bool
    let hourlyPrice: Int?
    let date: String?
    let from: String?
    let to: String?
}

struct BookingCard: Codable {
    let id: Int
    let readerName: String
    let title: String
    let about: String
    let scriptFile: String
    let readerIsLogin: Bool
    let bookStartTime: String
    let bookEndTime: String
    let hourlyPrice: Int
    let skills: String
    let voiceType: Int
    let others: Int
}
struct VideoCard: Codable {
    let id: Int
    let readerUid: String
    let tapName: String
    let bucketName: String
    let tapKey: String
    let createdTime: String
    let updatedTime: String
    let deletedTime: String
}
struct Availability: Codable {
    let id: Int
    let readerUid: String
    let date: String
    let fromTime: String
    let toTime: String
    let createdTime: String
    let updatedTime: String
    let deletedTime: String
}

//        showAlert(viewController: self, title: "Confirm", message: "Please input") { UIAlertAction in
//            print("Ok button tapped")
//        }
func showAlert(viewController: UIViewController, title: String, message: String, okHandler: @escaping ((UIAlertAction)->Void) )
{
    // Create new Alert
    let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    // Create OK button with action handler
    let ok = UIAlertAction(title: "OK", style: .default, handler: okHandler)
    dialogMessage.addAction(ok)
    viewController.present(dialogMessage, animated: true, completion: nil)
}

//        showConfirm(viewController: self, title: "Confirm", message: "PleaseIn") { UIAlertAction in
//            print("Ok button tapped")
//        } cancelHandler: { UIAlertAction in
//            print("Cancel button tapped")
//        }
func showConfirm(viewController: UIViewController
                 , title: String
                 , message: String
                 , okHandler: @escaping((UIAlertAction)->Void)
                 , cancelHandler: @escaping((UIAlertAction)->Void))
{
    // Create new Alert
    let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default, handler: okHandler)
    let cancel = UIAlertAction(title: "Cancel", style: .default, handler: cancelHandler)

    //Add OK button to a dialog message
    dialogMessage.addAction(ok)
    dialogMessage.addAction(cancel)
    viewController.present(dialogMessage, animated: true, completion: nil)
}

func showIndicator(sender: UIControl?, viewController: UIViewController)
{
    if(sender != nil){
        sender!.isEnabled = false
    }
    backgroundView = UIView()
    backgroundView!.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    backgroundView!.frame = viewController.view.bounds
    backgroundView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    viewController.view.addSubview(backgroundView!)
    
    activityIndicatorView = UIActivityIndicatorView(style: .large)
    activityIndicatorView!.center = viewController.view.center
    viewController.view.addSubview(activityIndicatorView!)
    activityIndicatorView!.startAnimating()
}

func hideIndicator(sender: UIControl?)
{
    activityIndicatorView?.stopAnimating()
    activityIndicatorView?.removeFromSuperview()
    backgroundView?.removeFromSuperview()
    
    if(sender != nil){
        sender!.isEnabled = true
    }
}

func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    let ret = emailPred.evaluate(with: email)
    return ret
}
