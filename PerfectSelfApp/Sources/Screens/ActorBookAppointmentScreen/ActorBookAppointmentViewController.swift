
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
    var availableTime: [String] = [
        "T09", "T10", "T11",
        "T12", "T13", "T14",
        "T15", "T16", "T17",
        "T18", "T19", "T20",
        "T21", "T22"
    ]
    
    var availableDuration: [String] = [
        "15", "30", "45", "00"
    ]

    @IBOutlet weak var picker_date: UIDatePicker!
    @IBOutlet weak var view_main: UIStackView!
    
    @IBOutlet weak var btn_15min: UIButton!
    @IBOutlet weak var btn_30min: UIButton!
    @IBOutlet weak var btn_60min: UIButton!
    @IBOutlet weak var btn_Standby: UIButton!
    
    @IBOutlet weak var btn_9am: UIButton!
    @IBOutlet weak var btn_10am: UIButton!
    @IBOutlet weak var btn_11am: UIButton!
    @IBOutlet weak var btn_12pm: UIButton!
    @IBOutlet weak var btn_1pm: UIButton!
    @IBOutlet weak var btn_2pm: UIButton!
    @IBOutlet weak var btn_3pm: UIButton!
    @IBOutlet weak var btn_4pm: UIButton!
    @IBOutlet weak var btn_5pm: UIButton!
    @IBOutlet weak var btn_6pm: UIButton!
    @IBOutlet weak var btn_7pm: UIButton!
    @IBOutlet weak var btn_8pm: UIButton!
    @IBOutlet weak var btn_9pm: UIButton!
    @IBOutlet weak var btn_10pm: UIButton!
    
    var btn2TimeMap:Dictionary<UIButton, Int> = [:]
    
    var sessionDuration = -1
    var startTime = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn2TimeMap[btn_9am] = 9
        btn2TimeMap[btn_10am] = 10
        btn2TimeMap[btn_11am] = 11
        btn2TimeMap[btn_12pm] = 12
        btn2TimeMap[btn_1pm] = 13
        btn2TimeMap[btn_2pm] = 14
        btn2TimeMap[btn_3pm] = 15
        btn2TimeMap[btn_4pm] = 16
        btn2TimeMap[btn_5pm] = 17
        btn2TimeMap[btn_6pm] = 18
        btn2TimeMap[btn_7pm] = 19
        btn2TimeMap[btn_8pm] = 20
        btn2TimeMap[btn_9pm] = 21
        btn2TimeMap[btn_10pm] = 22

        // Do any additional setup after loading the view.
        view_main.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        timeFormatter.dateFormat = "hh:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if !selectedDate.isEmpty {
            picker_date.setDate(Date.getDateFromString(date: selectedDate)!, animated: true)
            displayTimeSlotsForDate(d: Date.getDateFromString(date: selectedDate)!)
        }
        else {
            displayTimeSlotsForDate(d: picker_date.date)
        }
    }
    
    @IBAction func ChangeSelectedDate(_ sender: UIDatePicker) {
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
            } else if t.slot == 7 {
                btn_5pm.isHighlighted = false
                btn_5pm.isEnabled = true
            } else if t.slot == 8 {
                btn_6pm.isHighlighted = false
                btn_6pm.isEnabled = true
            } else if t.slot == 9 {
                btn_7pm.isHighlighted = false
                btn_7pm.isEnabled = true
            } else if t.slot == 10 {
                btn_8pm.isHighlighted = false
                btn_8pm.isEnabled = true
            } else if t.slot == 11 {
                btn_9pm.isHighlighted = false
                btn_9pm.isEnabled = true
            } else if t.slot == 12 {
                btn_10pm.isHighlighted = false
                btn_10pm.isEnabled = true
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
        for (key, _) in btn2TimeMap
        {
            //print("(\(btn2TimeMap[key]!) : \(val))")
            key.isHighlighted = !isEnabled
            key.isEnabled = isEnabled
        }
    }
    
    @IBAction func Select15Min(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_30min.isSelected = false
        btn_60min.isSelected = false
        btn_Standby.isSelected = false
        if sender.isSelected {
            sessionDuration = 1
            btn_15min.backgroundColor = UIColor.black
            btn_30min.backgroundColor = UIColor.white
            btn_60min.backgroundColor = UIColor.white
            btn_Standby.backgroundColor = UIColor.white
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
        btn_Standby.isSelected = false
        if sender.isSelected {
            sessionDuration = 2
            btn_15min.backgroundColor = UIColor.white
            btn_30min.backgroundColor = UIColor.black
            btn_60min.backgroundColor = UIColor.white
            btn_Standby.backgroundColor = UIColor.white
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
        btn_Standby.isSelected = false
        if sender.isSelected {
            sessionDuration = 3
            btn_15min.backgroundColor = UIColor.white
            btn_30min.backgroundColor = UIColor.white
            btn_60min.backgroundColor = UIColor.black
            btn_Standby.backgroundColor = UIColor.white
        }
        else {
            sessionDuration = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func selectStandbyDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_15min.isSelected = false
        btn_30min.isSelected = false
        btn_60min.isSelected = false
        if sender.isSelected {
            sessionDuration = 4
            btn_15min.backgroundColor = UIColor.white
            btn_30min.backgroundColor = UIColor.white
            btn_60min.backgroundColor = UIColor.white
            btn_Standby.backgroundColor = UIColor.black
        }
        else {
            sessionDuration = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    
    @IBAction func Select9Am(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 1)
    }
    
    @IBAction func Select10Am(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 2)
    }
    
    @IBAction func Select11Am(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 3)
    }
    
    @IBAction func Select12PmDidTap(_ sender: UIButton)
    {
        timeButtonTap(sender: sender, timeVal: 4)
    }
    
    @IBAction func Select1PmDidTap(_ sender: UIButton)
    {
        timeButtonTap(sender: sender, timeVal: 5)
    }
        
    @IBAction func Select2Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 6)
    }
    @IBAction func Select3Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 7)
    }
    
    @IBAction func Select4Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 8)
    }
    
    @IBAction func Select5Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 9)
    }
    
    @IBAction func Select6Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 10)
    }
    
    @IBAction func Select7Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 11)
    }
    
    @IBAction func Select8Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 12)
    }
    
    @IBAction func Select9Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 13)
    }
    
    @IBAction func Select10Pm(_ sender: UIButton) {
        timeButtonTap(sender: sender, timeVal: 14)
    }
    
    @IBAction func ContinueToUploadScript(_ sender: UIButton) {
        // check if session selected
        if sessionDuration <= 0 || startTime <= 0 {
            showAlert(viewController: self, title: "Confirm", message: "Please select session to continue") { UIAlertAction in
                           return
            }
        }
        let controller = ActorBookUploadScriptViewController()
        controller.readerUid = rUid
        controller.readerName = rName
        controller.bookingDate = dateFormatter.string(from: picker_date.date)
        let fromTime = "\(availableTime[ startTime-1 ]):00:00"
        let toTime = "\(availableTime[ startTime-1 ]):\(availableDuration[sessionDuration-1]):00"
        
        
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
    
    func timeButtonTap( sender: UIButton, timeVal: Int ){
        sender.isSelected = !sender.isSelected
        
        for (btn, _) in btn2TimeMap
        {
            if btn == sender { continue }
            btn.isSelected = false
        }
        
        if sender.isSelected {
            startTime = timeVal
            
            for (btn, _) in btn2TimeMap
            {
                if btn == sender {//Select color if this button
                    btn.backgroundColor = UIColor.black
                }
                else{//Otherwise, clear color with white
                    btn.backgroundColor = UIColor.white
                }
            }
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
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
