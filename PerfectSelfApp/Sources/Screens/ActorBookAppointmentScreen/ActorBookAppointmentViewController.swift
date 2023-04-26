
//  ActorBookAppointmentViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/21/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBookAppointmentViewController: UIViewController {
    var rUid: String = ""
    var rName: String = ""
    var selectedDate: String = ""
    var timeSlotList = [TimeSlot]()
    let backgroundView = UIView()
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()

    @IBOutlet weak var picker_date: UIDatePicker!
    @IBOutlet weak var view_main: UIStackView!
    
    @IBOutlet weak var btn_15min: UIButton!
    @IBOutlet weak var btn_30min: UIButton!
    @IBOutlet weak var btn_60min: UIButton!
    @IBOutlet weak var btn_9am: UIButton!
    @IBOutlet weak var btn_10am: UIButton!
    @IBOutlet weak var btn_11am: UIButton!
    @IBOutlet weak var btn_2pm: UIButton!
    @IBOutlet weak var btn_3pm: UIButton!
    @IBOutlet weak var btn_4pm: UIButton!
    var sessionDuration = -1
    var startTime = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view_main.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        timeFormatter.dateFormat = "hh:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(timeSlotList)
        if !selectedDate.isEmpty {
            picker_date.setDate(Date.getDateFromString(date: selectedDate)!, animated: true)
            displayTimeSlotsForDate(d: Date.getDateFromString(date: selectedDate)!)
        }
        else {
            displayTimeSlotsForDate(d: picker_date.date)
        }
    }
    
    @IBAction func ChangeSelectedDate(_ sender: UIDatePicker) {
        print(sender.date)
        displayTimeSlotsForDate(d: sender.date)
    }
    func displayTimeSlotsForDate(d: Date) {
        initTimeSlotState(isEnabled: false)
        let idx = getTimeSlotObjectIndex(d: d)
        if idx < 0 {
            return
        }
        let item = timeSlotList[idx]
        if item.isStandBy {
            initTimeSlotState(isEnabled: true)
        }
        for t in item.time {
            if t.slot == 1 {
                btn_9am.isHighlighted = false
                btn_9am.isEnabled = true
            } else if t.slot == 2 {
                btn_10am.isHighlighted = false
                btn_10am.isEnabled = true
            } else if t.slot == 3 {
                btn_11am.isHighlighted = false
                btn_11am.isEnabled = true
            } else if t.slot == 4 {
                btn_2pm.isHighlighted = false
                btn_2pm.isEnabled = true
            } else if t.slot == 5 {
                btn_3pm.isHighlighted = false
                btn_3pm.isEnabled = true
            } else if t.slot == 6 {
                btn_4pm.isHighlighted = false
                btn_4pm.isEnabled = true
            } else {
                print("oops!")
            }
        }
    }
    func getTimeSlotObjectIndex(d: Date) -> Int {
        
        let index = timeSlotList.firstIndex(where: { dateFormatter.string(from: Date.getDateFromString(date: $0.date)!) == dateFormatter.string(from: d) })

        return index ?? -1
    }
    func initTimeSlotState(isEnabled: Bool) {
        btn_9am.isHighlighted = !isEnabled
        btn_9am.isEnabled = isEnabled
        btn_10am.isHighlighted = !isEnabled
        btn_10am.isEnabled = isEnabled
        btn_11am.isHighlighted = !isEnabled
        btn_11am.isEnabled = isEnabled
        btn_2pm.isHighlighted = !isEnabled
        btn_2pm.isEnabled = isEnabled
        btn_3pm.isHighlighted = !isEnabled
        btn_3pm.isEnabled = isEnabled
        btn_4pm.isHighlighted = !isEnabled
        btn_4pm.isEnabled = isEnabled
    }
    @IBAction func Select15Min(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_30min.isSelected = false
        btn_60min.isSelected = false
        if sender.isSelected {
            sessionDuration = 1
            btn_15min.backgroundColor = UIColor.black
            btn_30min.backgroundColor = UIColor.white
            btn_60min.backgroundColor = UIColor.white
        }
        else {
            sessionDuration = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select30Min(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_15min.isSelected = false
        btn_60min.isSelected = false
        if sender.isSelected {
            sessionDuration = 2
            btn_15min.backgroundColor = UIColor.white
            btn_30min.backgroundColor = UIColor.black
            btn_60min.backgroundColor = UIColor.white
        }
        else {
            sessionDuration = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select60Min(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_15min.isSelected = false
        btn_30min.isSelected = false
        if sender.isSelected {
            sessionDuration = 3
            btn_15min.backgroundColor = UIColor.white
            btn_30min.backgroundColor = UIColor.white
            btn_60min.backgroundColor = UIColor.black
        }
        else {
            sessionDuration = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select9Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
//        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        
        if sender.isSelected {
            startTime = 1
            btn_9am.backgroundColor = UIColor.black
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select10Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
//        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        
        if sender.isSelected {
            startTime = 2
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.black
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select11Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
//        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        
        if sender.isSelected {
            startTime = 3
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.black
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select2Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
//        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        
        if sender.isSelected {
            startTime = 4
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.black
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select3Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
//        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        
        if sender.isSelected {
            startTime = 5
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.black
            btn_4pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select4Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
//        btn_4pm.isSelected = false
        
        if sender.isSelected {
            startTime = 6
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.black
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func ContinueToUploadScript(_ sender: UIButton) {
        // check if session selected
        if sessionDuration < 0 || startTime < 0 {
            showAlert(viewController: self, title: "Confirm", message: "Please select session to continue") { UIAlertAction in
                           return
            }
        }
        let controller = ActorBookUploadScriptViewController()
        controller.readerUid = rUid
        controller.readerName = rName
        controller.bookingDate = dateFormatter.string(from: picker_date.date)
        var fromTime = ""
        var toTime = ""
        if startTime == 1 {
            fromTime += "T09:00:00"
            if sessionDuration == 1 {
                toTime += "T09:15:00"
            } else if sessionDuration == 2 {
                toTime += "T09:30:00"
            } else if sessionDuration == 3 {
                toTime += "T10:00:00"
            }
        } else if startTime == 2 {
            fromTime += "T10:00:00"
            if sessionDuration == 1 {
                toTime += "T10:15:00"
            } else if sessionDuration == 2 {
                toTime += "T10:30:00"
            } else if sessionDuration == 3 {
                toTime += "T11:00:00"
            }
        } else if startTime == 3 {
            fromTime += "T11:00:00"
            if sessionDuration == 1 {
                toTime += "T11:15:00"
            } else if sessionDuration == 2 {
                toTime += "T11:30:00"
            } else if sessionDuration == 3 {
                toTime += "T12:00:00"
            }
        } else if startTime == 4 {
            fromTime += "T14:00:00"
            if sessionDuration == 1 {
                toTime += "T14:15:00"
            } else if sessionDuration == 2 {
                toTime += "T14:30:00"
            } else if sessionDuration == 3 {
                toTime += "T15:00:00"
            }
        } else if startTime == 5 {
            fromTime += "T15:00:00"
            if sessionDuration == 1 {
                toTime += "T15:15:00"
            } else if sessionDuration == 2 {
                toTime += "T15:30:00"
            } else if sessionDuration == 3 {
                toTime += "T16:00:00"
            }
        } else if startTime == 6 {
            fromTime += "T16:00:00"
            if sessionDuration == 1 {
                toTime += "T16:15:00"
            } else if sessionDuration == 2 {
                toTime += "T16:30:00"
            } else if sessionDuration == 3 {
                toTime += "T17:00:00"
            }
        } else {
            print("oops!")
            fromTime += "T00:00:00"
            toTime += "T00:00:00"
        }
        controller.bookingStartTime = fromTime
        controller.bookingEndTime = toTime
//        print(fromTime, toTime)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false)
    }

    @IBAction func GoBack(_ sender: UIButton) {
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
