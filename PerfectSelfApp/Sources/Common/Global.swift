//
//  Global.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/1/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
import UIKit

let signalingServerConfig = Config.default
let webAPI = PerfectSelfWebAPI()
let ACTOR_UTYPE = 3
let READER_UTYPE = 4
var backgroundView: UIView? = nil
var activityIndicatorView: UIActivityIndicatorView? = nil
var uiViewContoller: UIViewController? = nil
var selectedTape: VideoCard?
//var webRTCClient: WebRTCClient?
//var signalClient: SignalingClient?
//var signalingClientStatus: SignalingClientStatus?

//struct Message: Codable {
//    let text: String
//    let timestamp: String
//}
enum MessageType {
    case sent
    case received
}

struct UserInfo: Codable {
    let userName: String
    let userType: Int
    let avatarBucketName: String?
    let avatarKey: String?
    let email: String
    let password: String?
    let firstName: String?
    let lastName: String?
    let dateOfBirth: String?
    let gender:Int?
    let currentAddress: String?
    let permanentAddress: String?
    let city: String?
    let nationality: String?
    let phoneNumber: String?
    let isLogin: Bool
    let token: String?
    let createdTime: String
    let updatedTime: String?
    let deletedTime: String?
}
struct ReaderProfileDetail: Codable {
    let uid: String
    let userName: String
    let avatarBucketName: String
    let avatarKey: String
    let title: String
    let hourlyPrice: Int
    let others: Int
    let voiceType: Int
    let about: String
    let skills: String
    let score: Float
    let introBucketName: String
    let introVideoKey: String
    let bookPassCount: Int
    let allAvailability: [Availability]
    let reviewLists: [Review]
}
struct Availability: Codable {
    let readerUid: String
    let isStandBy: Bool
    let repeatFlag: Int
    let date: String
    let fromTime: String
    let toTime: String
    let id: Int
}
struct Review: Codable {
    let actorUid: String
    let readerUid: String
    let roomUid: String
    let actorName: String
    let actorBucketName: String?
    let actorAvatarKey: String?
    let bookStartTime: String
    let bookEndTime: String
    let scriptFile: String
    let readerScore: Int
    let readerReview: String
}
struct ReaderProfileCard: Codable {
    let uid: String
    let userName: String
    let userType: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatarBucketName: String?
    let avatarKey: String?
    let title: String?
    let gender: Int
    let isLogin: Bool
    let isSponsored: Bool
    let reviewCount: Int
    let score: Float
    let hourlyPrice: Int?
    let isStandBy: Bool?
    let date: String?
    let fromTime: String?
    let toTime: String?
}
struct UnreadState: Codable {
    let uid: String
    let unreadCount: Int
}
struct BookingCard: Codable {
    let id: Int
    let roomUid: String
    let actorUid: String
    let readerUid: String
    let readerName: String
    let actorName: String
    let scriptFile: String
    let bookStartTime: String
    let bookEndTime: String
    let readerReview: String?
    let actorBucketName: String?
    let actorAvatarKey: String?
    let readerBucketName: String?
    let readerAvatarKey: String?
}

struct VideoCard: Codable {
    let id: Int
    let readerUid: String
    let tapeName: String
    let bucketName: String
    let tapeKey: String
    let createdTime: String
    let updatedTime: String
    let deletedTime: String
}

struct TimeSlot: Codable {
    var date: String
    var time: [Slot]
    var repeatFlag: Int
    var isStandBy: Bool
}
struct Slot: Codable {
    var id: Int
    var slot: Int
    var duration: Int
    var isDeleted: Bool
}
struct ChatChannel: Codable {
    let id: Int
    let senderUid: String
    let senderName: String
    let receiverUid: String
    let receiverName: String
    let roomUid: String
    let sendTime: String
    let hadRead: Bool
    let message: String
    let senderAvatarBucket: String?
    let senderAvatarKey: String?
    let receiverAvatarBucket: String?
    let receiverAvatarKey: String?
    let senderIsOnline: Bool
    let receiverIsOnline: Bool
    let unreadCount: Int
}

struct PerfMessage: Codable {
    let id: Int
    let senderUid: String
    let receiverUid: String
    let roomUid: String
    let sendTime: String
    let hadRead: Bool
    let message: String
}
struct RoomInfo: Codable {
    let roomUid: String
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

func showIndicator(sender: UIControl?, viewController: UIViewController, color: UIColor=UIColor.black)
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
    activityIndicatorView?.color = color
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

func buildSignalingClient() -> SignalingClient {
    // iOS 13 has native websocket support. For iOS 12 or lower we will use 3rd party library.
    let webSocketProvider: WebSocketProvider
    
    if #available(iOS 13.0, *) {
        webSocketProvider = NativeWebSocket(url: signalingServerConfig.signalingServerUrl)
    } else {
        webSocketProvider = StarscreamWebSocket(url: signalingServerConfig.signalingServerUrl)
    }
    
    return SignalingClient(webSocket: webSocketProvider)
}

func getDateString() -> String{
    let now = Date()
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current
    formatter.dateFormat = "yyyy-MM-dd-HHmmss"
    let dateString = formatter.string(from: now)
    return dateString
}

func getCurrentTime(milisecond: Float64) -> String{
    let seconds = (UInt) (milisecond / 1000) % 60
    let  minutes = (UInt) (((UInt)(milisecond / (1000*60))) % 60)
    let hours   = (UInt) ((UInt)(milisecond / (1000*60*60)))
    let curTimeText: String = String.localizedStringWithFormat("%i:%02i:%02i", hours, minutes, seconds)
    return curTimeText
}

func getCurrentTime(second: Float64) -> String{
    let seconds = (UInt)((Int(second)) % 60)
    let  minutes = (UInt) (((UInt)(second / (60))) % 60)
    let hours   = (UInt) ((UInt)(second / (60*60)))
    let curTimeText: String = String.localizedStringWithFormat("%i:%02i:%02i", hours, minutes, seconds)
    return curTimeText
}
