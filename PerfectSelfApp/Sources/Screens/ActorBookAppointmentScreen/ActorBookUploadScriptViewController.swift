//
//  ActorBookAppointmentViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBookUploadScriptViewController: UIViewController {

    var readerUid: String = ""
    var readerName: String = ""
    var bookingStartTime: String = ""
    var bookingEndTime: String = ""
    var bookingDate: String = ""
    
    @IBOutlet weak var lbl_readerName: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var text_script: UITextView!
    @IBOutlet weak var lbl_time: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbl_readerName.text = "Reading with \(readerName)"
        print(bookingDate, bookingStartTime)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        df.timeZone = TimeZone(abbreviation: "EST")
        let estDate = df.date(from: bookingDate + bookingStartTime) ?? Date()
        df.dateFormat = "hh:mm"
        let t = df.string(from: estDate)
        df.dateFormat = "MMMM dd, yyyy"
        let d = df.string(from: estDate)
        lbl_time.text = "Time: \(t) EST"
        lbl_date.text = "Date: \(d)"
    }

    @IBAction func GotoCheckout(_ sender: UIButton) {
        let controller = ActorSetPaymentViewController();

        controller.readerUid = readerUid
        controller.readerName = readerName
        controller.bookingStartTime = bookingStartTime
        controller.bookingEndTime = bookingEndTime
        controller.bookingDate = bookingDate
        controller.script = text_script.text
        controller.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(controller, animated: true)
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
    }
    @IBAction func GoBack(_ sender: UIButton) {
//        _ = navigationController?.popViewController(animated: true)
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
  
        self.dismiss(animated: false)
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
