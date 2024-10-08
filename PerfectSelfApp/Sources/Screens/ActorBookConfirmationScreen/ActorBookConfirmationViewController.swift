//
//  ActorBookConfirmationViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher
import EventKit
import EventKitUI

class ActorBookConfirmationViewController: UIViewController, EKEventEditViewDelegate{
    var uid = ""
    var readerUid: String = ""
    var readerName: String = ""
    var bookingDate: String = ""//yyyy-MM-dd
    var bookingStartTime: String = ""//HH:mm:ss
    var bookingEndTime: String = ""
    var script: String = ""
    var scriptBucket: String = ""
    var scriptKey: String = ""
    static var fcmDeviceToken: String = ""
    
    private let scopes = [kGTLRAuthScopeCalendar]
    private let service = GTLRCalendarService()
    
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
        
        GIDSignIn.sharedInstance().clientID = "669216550945-mgc5slqbok7j5ubp8255loi7hkoe7mj3.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    @IBAction func AddToGoogleCalendar(_ sender: UITapGestureRecognizer) {
        add_to_google_calendar.layer.borderColor = CGColor(red: 0.46, green: 0.53, blue: 0.85, alpha: 1.0)
        add_to_calendar.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func AddToCalendar(_ sender: UITapGestureRecognizer) {
        add_to_google_calendar.layer.borderColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        add_to_calendar.layer.borderColor = CGColor(red: 0.46, green: 0.53, blue: 0.85, alpha: 1.0)
        
        let strDate: String = "\(bookingDate)\(bookingStartTime)"
        let strDate2: String = "\(bookingDate)\(bookingEndTime)"
        let eventStore = EKEventStore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let startDate = dateFormatter.date(from: strDate)
        let endDate = dateFormatter.date(from: strDate2)
        
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = "PerfectSelf: Booking Reserved"
                    event.startDate = startDate
                    event.url = URL(string: "")
                    event.endDate = endDate
                    let eventController = EKEventEditViewController()
                    eventController.event = event
                    eventController.eventStore = eventStore
                    eventController.editViewDelegate = self
                    self.present(eventController, animated: true, completion: nil)
                }
            }
        })
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
                    
                    //Send push notification to reader.
                    if( ActorBookConfirmationViewController.fcmDeviceToken.count > 0 )
                    {
                        webAPI.sendPushNotifiction(toFCMToken: ActorBookConfirmationViewController.fcmDeviceToken, title: "Invite Booking", body: "You received booking from actor."){ data, response, error in
                            if error == nil {
                                // successfully send notification.
                            }
                        }
                    }
                    
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
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // Create an event to the Google Calendar's user
    func addEventoToGoogleCalendar(summary : String, description :String, startTime : String, endTime : String) {
        let calendarEvent = GTLRCalendar_Event()
        
        calendarEvent.summary = "\(summary)"
        calendarEvent.descriptionProperty = "\(description)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let startDate = dateFormatter.date(from: startTime)
        let endDate = dateFormatter.date(from: endTime)
        
        guard let toBuildDateStart = startDate else {
            print("Error getting start date")
            return
        }
        guard let toBuildDateEnd = endDate else {
            print("Error getting end date")
            return
        }
        calendarEvent.start = buildDate(date: toBuildDateStart)
        calendarEvent.end = buildDate(date: toBuildDateEnd)
        
        let insertQuery = GTLRCalendarQuery_EventsInsert.query(withObject: calendarEvent, calendarId: "primary")
        
        service.executeQuery(insertQuery) { (ticket, object, error) in
            if error == nil {
                print("Event inserted")
            } else {
                print(error!)
            }
        }
    }
    
    // Helper to build date
    func buildDate(date: Date) -> GTLRCalendar_EventDateTime {
        let datetime = GTLRDateTime(date: date)
        let dateObject = GTLRCalendar_EventDateTime()
        dateObject.dateTime = datetime
        return dateObject
    }
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
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

extension ActorBookConfirmationViewController:GIDSignInDelegate{
    //MARK:Google SignIn Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        // myActivityIndicator.stopAnimating()
    }
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    ////Google_signIn
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
            self.service.authorizer = user.authentication.fetcherAuthorizer()
//            addEventoToGoogleCalendar(summary: "summary9", description: "description", startTime: "25/02/2020 09:00", endTime: "25/02/2020 10:00")
            
            let strDate: String = "\(bookingDate)\(bookingStartTime)"
            let strDate2: String = "\(bookingDate)\(bookingEndTime)"
            addEventoToGoogleCalendar(summary: "PerfectSelf", description: "Booking Reserved", startTime: strDate, endTime:  strDate2)
        }
    }
}
