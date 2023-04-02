//
//  BookingCollectionViewCell.swift
//  PerfectSelf
//
//  Created by user232392 on 3/23/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
let conferenceViewController = ConferenceViewController()

class BookingCollectionViewCell: UICollectionViewCell {
//    public var signalClient: SignalingClient?
//    public var webRTCClient: WebRTCClient?
    public var navigationController: UINavigationController?
    public var parentViewController: UIViewController?
    public var roomUid: String?

    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    @IBAction func JoinMeeting(_ sender: UIButton) {
        //print("join")
        conferenceViewController.roomUid = self.roomUid
        conferenceViewController.modalPresentationStyle = .fullScreen
        self.parentViewController!.present(conferenceViewController, animated: false, completion: nil)
    }
    
    @IBAction func SendMessage(_ sender: UIButton) {
        //Omitted let controller = ChatViewController(roomUid: self.roomUid!)
        chatController.roomUid = self.roomUid
        chatController.modalPresentationStyle = .fullScreen
        self.parentViewController!.present(chatController, animated: false, completion: nil)
    }
    
    @IBAction func CancelBooking(_ sender: UIButton) {
        showConfirm(viewController: self.parentViewController!, title: "Confirm", message: "Are you sure?") { UIAlertAction in
            // call API for real cancellation
            showIndicator(sender: nil, viewController: self.parentViewController!)
            webAPI.cancelBookingByRoomUid(uid: self.roomUid!) { data, response, error in
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                }
                guard let _ = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        Toast.show(message: "error while cancelling book. try again later", controller: self.parentViewController!)
                    }
                    return
                }
                DispatchQueue.main.async {
                    Toast.show(message: "Cancelled book", controller: self.parentViewController!)
                    self.parentViewController?.viewWillAppear(false)
                }
            }
            
            
        } cancelHandler: { UIAlertAction in
            print("Cancel button tapped")
        }
    }
}
