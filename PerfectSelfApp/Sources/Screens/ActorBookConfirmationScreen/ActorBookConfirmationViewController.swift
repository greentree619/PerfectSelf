//
//  ActorBookConfirmationViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class ActorBookConfirmationViewController: UIViewController {
    var uid = ""
    var readerUid: String = ""
    var readerName: String = ""
    var bookingDate: String = ""
    var bookingStartTime: String = ""
    var bookingEndTime: String = ""
    var script: String = ""
    var scriptBucket: String = ""
    var scriptKey: String = ""
    
    @IBOutlet weak var img_book_animation: UIImageView!
    @IBOutlet weak var add_to_calendar: UIStackView!
    @IBOutlet weak var add_to_google_calendar: UIStackView!
    
    @IBOutlet weak var lbl_datetime: UILabel!
    @IBOutlet weak var lbl_readerName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        img_book_animation.loadGif(asset: "book-animation")
        lbl_readerName.text = "Reading with \(readerName)"
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        df.timeZone = TimeZone(abbreviation: "EST")
        let estDate = df.date(from: bookingDate + bookingStartTime) ?? Date()
        df.dateFormat = "MMM dd, yyyy  HH:mm a"
        lbl_datetime.text = "Time:  \(df.string(from: estDate))  EST"
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            uid = userInfo["uid"] as! String
        } else {
            // No data was saved
            print("No data was saved.")
        }
        
    }

    @IBAction func AddToGoogleCalendar(_ sender: UITapGestureRecognizer) {
        add_to_google_calendar.layer.borderColor = CGColor(red: 0.46, green: 0.53, blue: 0.85, alpha: 1.0)
        add_to_calendar.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    @IBAction func AddToCalendar(_ sender: UITapGestureRecognizer) {
        add_to_google_calendar.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
 
        add_to_calendar.layer.borderColor = CGColor(red: 0.46, green: 0.53, blue: 0.85, alpha: 1.0)
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
      
        self.dismiss(animated: false)
        
    }
    @IBAction func CompleteBooking(_ sender: UIButton) {
        // call book api
   
        let bookingStart = bookingDate + bookingStartTime
        let bookingEnd = bookingDate + bookingEndTime
        showIndicator(sender: sender, viewController: self)
        webAPI.bookAppointment(actorUid: uid, readerUid: readerUid, bookStartTime:bookingStart, bookEndTime: bookingEnd, script: script, scriptBucket: scriptBucket, scriptKey: scriptKey) { data, response, error in
            guard let data = data, error == nil else {
                hideIndicator(sender: sender)
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            if let _ = responseJSON as? [String: Any] {
                DispatchQueue.main.async {
                    hideIndicator(sender: sender)
//                    Toast.show(message: "success!", controller: self)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            // do stuff 1 seconds later
                        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: false, completion: nil)
                    }
                    
                }
                
            }
            else {
                DispatchQueue.main.async {
                    hideIndicator(sender: sender)
                    Toast.show(message: "Unable to create booking at this time. please try again later.", controller:  self)
                }
            }
        }
        
       
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
