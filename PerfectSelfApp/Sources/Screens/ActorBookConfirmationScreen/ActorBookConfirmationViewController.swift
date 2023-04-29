//
//  ActorBookConfirmationViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import SwiftGifOrigin
//import GoogleSignIn
//import GTMSessionFetcher
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
        
//        //Declares the new event
//        var newEvent: GTLRCalendar_Event = GTLRCalendar_Event()
//
//        //this is setting the parameters of the new event
//        newEvent.summary = ("Google I/O 2015")
//        newEvent.location = ("800 Howard St., San Francisco, CA 94103")
//
//        //I ran into some problems with the date formatting and this is what I ended with.
//
//        //Start Date. The offset adds time to the current time so if you run the         program at 12:00 then it will record a time of 12:05 because of the 5 minute offset
//
//        let startDateTime: GTLRDateTime = GTLRDateTime(date: Date(), offsetMinutes: 5)
//        let startEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
//        startEventDateTime.dateTime = startDateTime
//        newEvent.start = startEventDateTime
//        print(newEvent.start!)
//
//        //Same as start date, but for the end date
//        let endDateTime: GTLRDateTime = GTLRDateTime(date: Date(), offsetMinutes: 50)
//        let endEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
//        endEventDateTime.dateTime = endDateTime
//        newEvent.end = endEventDateTime
//        print(newEvent.end!)
//
//
//        let service: GTLRCalendarService = GTLRCalendarService()
//
//        //The query
//        let query =
//        GTLRCalendarQuery_EventsInsert.query(withObject: newEvent, calendarId:"Past your calendar ID here this is specific to the calendar you want to edit and can be found under the google calendar settings")
//
//        //This is the part that I forgot. Specify your fields! I think this will change when you add other perimeters, but I need to review how this works more.
//        query.fields = "id";
//
//        //This is actually running the query you just built
//        self.service.executeQuery(
//               query,
//               completionHandler: {(_ callbackTicket:GTLRServiceTicket,
//                                    _  event:GTLRCalendar_Event,
//                                    _ callbackError: Error?) -> Void in}
//                                   as? GTLRServiceCompletionHandler
//                   )
//              }
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
                    event.title = "Booking Date"
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
