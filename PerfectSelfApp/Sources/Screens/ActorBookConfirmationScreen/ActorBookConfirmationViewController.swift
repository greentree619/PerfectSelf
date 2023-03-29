//
//  ActorBookConfirmationViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBookConfirmationViewController: UIViewController {

    var readerUid: String = ""
    var bookingDate: String = ""
    var bookingStartTime: String = ""
    var bookingEndTime: String = ""
    var script: String = ""
    
    @IBOutlet weak var add_to_calendar: UIStackView!
    @IBOutlet weak var add_to_google_calendar: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
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
        self.dismiss(animated: false)
        
    }
    @IBAction func CompleteBooking(_ sender: UIButton) {
        // call book api
        let actorUid = UserDefaults.standard.string(forKey: "USER_ID")!

        let bookingStart = bookingDate + "T" + bookingStartTime + "Z"
        let bookingEnd = bookingDate + "T" + bookingEndTime + "Z"
        showIndicator(sender: sender, viewController: self)
        webAPI.bookAppointment(actorUid: actorUid, readerUid: readerUid, bookStartTime:bookingStart, bookEndTime: bookingEnd, script: script) { data, response, error in
            guard let data = data, error == nil else {
                hideIndicator(sender: sender)
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            print(responseJSON ?? "here")
            if let _ = responseJSON as? [String: Any] {
                DispatchQueue.main.async {
                    hideIndicator(sender: sender)
                    Toast.show(message: "success!", controller: self)
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
