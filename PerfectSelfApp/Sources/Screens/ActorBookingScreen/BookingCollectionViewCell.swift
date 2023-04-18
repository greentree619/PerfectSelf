//
//  BookingCollectionViewCell.swift
//  PerfectSelf
//
//  Created by user232392 on 3/23/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class BookingCollectionViewCell: UICollectionViewCell {

    public var navigationController: UINavigationController?
    public var parentViewController: UIViewController?

    public var roomUid: String?
    public var review: String?
    public var bookType:Int = 1
    public var id: Int = 0
    public var readerType:String = "" // 0

    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var btn_accept: UIButton!
    @IBOutlet weak var btn_rate: UIButton!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_sendmsg: UIButton!
    @IBOutlet weak var btn_reschedule: UIButton!
    @IBOutlet weak var btn_joinmeeting: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()

        if readerType == "actor" {
            if bookType == 0 {
                btn_joinmeeting.isHidden = true
                btn_reschedule.isHidden = true
                btn_sendmsg.isHidden = false
                btn_cancel.isHidden = true
                btn_rate.isHidden = false
                btn_rate.isEnabled = review?.isEmpty ?? true ? true:false
                btn_accept.isHidden = true
            }
            else if bookType == 1 {
                btn_joinmeeting.isHidden = false
                btn_reschedule.isHidden = true
                btn_sendmsg.isHidden = false
                btn_cancel.isHidden = false
                btn_rate.isHidden = true
                btn_accept.isHidden = true
            }
            else if bookType == 2 {
                btn_joinmeeting.isHidden = true
                btn_reschedule.isHidden = false
                btn_sendmsg.isHidden = false
                btn_cancel.isHidden = false
                btn_rate.isHidden = true
                btn_accept.isHidden = true
            }
            else {
                btn_joinmeeting.isHidden = true
                btn_reschedule.isHidden = true
                btn_sendmsg.isHidden = true
                btn_cancel.isHidden = true
                btn_rate.isHidden = true
                btn_accept.isHidden = true
                print("oops!")
            }
        }
        else if readerType == "reader" {
            if bookType == 0 {//past
                btn_joinmeeting.isHidden = true
                btn_reschedule.isHidden = true
                btn_sendmsg.isHidden = true
                btn_cancel.isHidden = true
                btn_rate.isHidden = true
                btn_accept.isHidden = true
            }
            else if bookType == 1 {//upcoming
                btn_joinmeeting.isHidden = false
                btn_reschedule.isHidden = true
                btn_sendmsg.isHidden = false
                btn_cancel.isHidden = false
                btn_rate.isHidden = true
                btn_accept.isHidden = true
            }
            else if bookType == 2 {//pending
                btn_joinmeeting.isHidden = true
                btn_reschedule.isHidden = true
                btn_sendmsg.isHidden = false
                btn_cancel.isHidden = false
                btn_rate.isHidden = true
                btn_accept.isHidden = false
            }
            else {
                btn_joinmeeting.isHidden = true
                btn_reschedule.isHidden = true
                btn_sendmsg.isHidden = true
                btn_cancel.isHidden = true
                btn_rate.isHidden = true
                btn_accept.isHidden = true
                print("oops!")
            }
        }
        else {
            btn_joinmeeting.isHidden = true
            btn_reschedule.isHidden = true
            btn_sendmsg.isHidden = true
            btn_cancel.isHidden = true
            btn_rate.isHidden = true
            btn_accept.isHidden = true
            print("Oops!")
        }
    }
    override func prepareForReuse() {
         super.prepareForReuse()
         
         // Reset any properties that could affect the cell's appearance
        btn_joinmeeting.isHidden = false
        btn_reschedule.isHidden = false
        btn_sendmsg.isHidden = false
        btn_cancel.isHidden = false
        btn_rate.isHidden = false
        btn_rate.isEnabled = true
        btn_accept.isHidden = false
     }
    @IBAction func JoinMeeting(_ sender: UIButton) {
        let conferenceViewController = ConferenceViewController(roomUid: self.roomUid!)
        conferenceViewController.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.parentViewController!.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.parentViewController!.present(conferenceViewController, animated: false)
    }
    
    @IBAction func SendMessage(_ sender: UIButton) {
        let controller = ChatViewController(roomUid: self.roomUid!)
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.parentViewController!.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.parentViewController!.present(controller, animated: false)
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
                        Toast.show(message: "error while cancel booking. try again later", controller: self.parentViewController!)
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
    
    @IBAction func RescheduleBooking(_ sender: UIButton) {
        //call reschedule API
    }
    
    @IBAction func AcceptBooking(_ sender: UIButton) {
        // call API for accept
        showIndicator(sender: nil, viewController: self.parentViewController!)
        webAPI.acceptBookingById(id: self.id) { data, response, error in
            DispatchQueue.main.async {
                hideIndicator(sender: nil)
            }
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    Toast.show(message: "error while accept booking. try again later", controller: self.parentViewController!)
                }
                return
            }
            DispatchQueue.main.async {
                Toast.show(message: "Book accepted", controller: self.parentViewController!)
                self.parentViewController?.viewWillAppear(false)
            }
        }
    }
    @IBAction func RateReader(_ sender: UIButton) {
        delegate?.setBookId(controller: self, id: self.id, name: self.lbl_name.text ?? "user")
    }
    var delegate: BookDelegate?
}
protocol BookDelegate {
    func setBookId(controller: UICollectionViewCell, id: Int, name: String)
}
