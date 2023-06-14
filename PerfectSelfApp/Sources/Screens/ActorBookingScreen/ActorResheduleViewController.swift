
//  ActorBookAppointmentViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/21/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorResheduleViewController: UIViewController {
    var rUid: String = ""
    var rName: String = ""
    var bookId = 0
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
    @IBOutlet weak var btn_5pm: UIButton!
    @IBOutlet weak var btn_6pm: UIButton!
    @IBOutlet weak var btn_7pm: UIButton!
    @IBOutlet weak var btn_8pm: UIButton!
    @IBOutlet weak var btn_9pm: UIButton!
    @IBOutlet weak var btn_10pm: UIButton!
    
    var sessionDuration = -1
    var startTime = -1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view_main.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        timeFormatter.dateFormat = "hh:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // call api for reader details
        showIndicator(sender: nil, viewController: self)
        webAPI.getReaderById(id:rUid) { data, response, error in
            DispatchQueue.main.async {
                hideIndicator(sender: nil)
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let item = try JSONDecoder().decode(ReaderProfileDetail.self, from: data)
                DispatchQueue.main.async {
                    self.timeSlotList.removeAll()
                    
                    for availibility in item.allAvailability {
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd"
                        let tf = DateFormatter()
                        tf.dateFormat = "HH"
                        
                        let index = self.timeSlotList.firstIndex(where: { df.string(from: Date.getDateFromString(date: $0.date)!) == df.string(from: Date.getDateFromString(date: utcToLocal(dateStr: availibility.date)!)!) })
                        if index == nil {
                            self.timeSlotList.append(TimeSlot(date: utcToLocal(dateStr: availibility.date)!, time: [Slot](), repeatFlag: 0, isStandBy: false))
                        }
                        let idx = index ?? self.timeSlotList.count - 1
                        
                        let t = tf.string(from:Date.getDateFromString(date:  utcToLocal(dateStr: availibility.fromTime)!)!)
                        var slot = 0
                        switch t {
                        case "09":
                            slot = 1
                        case "10":
                            slot = 2
                        case "11":
                            slot = 3
                        case "14":
                            slot = 4
                        case "15":
                            slot = 5
                        case "16":
                            slot = 6
                        case "17":
                            slot = 7
                        case "18":
                            slot = 8
                        case "19":
                            slot = 9
                        case "20":
                            slot = 10
                        case "21":
                            slot = 11
                        case "22":
                            slot = 12
                        default:
                            slot = 0
                        }
                        self.timeSlotList[idx].time.append(Slot(id: 0, slot: slot, duration: 0, isDeleted: false))
                    }
                    self.timeSlotList = self.timeSlotList.sorted(by: { Date.getDateFromString(date: $0.date)! < Date.getDateFromString(date: $1.date)! })
                    
                    if !self.selectedDate.isEmpty {
                        self.picker_date.setDate(Date.getDateFromString(date: self.selectedDate) ?? Date(), animated: true)
                        self.displayTimeSlotsForDate(d: Date.getDateFromString(date: self.selectedDate) ?? Date())
                    }
                    else {
                        self.displayTimeSlotsForDate(d: self.picker_date.date)
                    }
                }
            }
            catch {
                print(error)
                DispatchQueue.main.async {
                    Toast.show(message: "Something went wrong. try again later", controller: self)
                }
            }
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
        btn_5pm.isHighlighted = !isEnabled
        btn_5pm.isEnabled = isEnabled
        btn_6pm.isHighlighted = !isEnabled
        btn_6pm.isEnabled = isEnabled
        btn_7pm.isHighlighted = !isEnabled
        btn_7pm.isEnabled = isEnabled
        btn_8pm.isHighlighted = !isEnabled
        btn_8pm.isEnabled = isEnabled
        btn_9pm.isHighlighted = !isEnabled
        btn_9pm.isEnabled = isEnabled
        btn_10pm.isHighlighted = !isEnabled
        btn_10pm.isEnabled = isEnabled
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
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 1
            btn_9am.backgroundColor = UIColor.black
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
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
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 2
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.black
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
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
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 3
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.black
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
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
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 4
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.black
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
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
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 5
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.black
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
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
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 6
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.black
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select5Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
//        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 7
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.black
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select6Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        btn_5pm.isSelected = false
//        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 8
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.black
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select7Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
//        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 9
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.black
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select8Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
//        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 10
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.black
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select9Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
//        btn_9pm.isSelected = false
        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 11
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.black
            btn_10pm.backgroundColor = UIColor.white
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select10Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btn_9am.isSelected = false
        btn_10am.isSelected = false
        btn_11am.isSelected = false
        btn_2pm.isSelected = false
        btn_3pm.isSelected = false
        btn_4pm.isSelected = false
        btn_5pm.isSelected = false
        btn_6pm.isSelected = false
        btn_7pm.isSelected = false
        btn_8pm.isSelected = false
        btn_9pm.isSelected = false
//        btn_10pm.isSelected = false
        
        if sender.isSelected {
            startTime = 12
            btn_9am.backgroundColor = UIColor.white
            btn_10am.backgroundColor = UIColor.white
            btn_11am.backgroundColor = UIColor.white
            btn_2pm.backgroundColor = UIColor.white
            btn_3pm.backgroundColor = UIColor.white
            btn_4pm.backgroundColor = UIColor.white
            btn_5pm.backgroundColor = UIColor.white
            btn_6pm.backgroundColor = UIColor.white
            btn_7pm.backgroundColor = UIColor.white
            btn_8pm.backgroundColor = UIColor.white
            btn_9pm.backgroundColor = UIColor.white
            btn_10pm.backgroundColor = UIColor.black
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func ConfirmReschedule(_ sender: UIButton) {
        // check if session selected
        if sessionDuration < 0 || startTime < 0 {
            showAlert(viewController: self, title: "Confirm", message: "Please select session to continue") { UIAlertAction in
                           return
            }
        }

        let bookingDate = dateFormatter.string(from: picker_date.date)
        var fromTime = bookingDate
        var toTime = bookingDate
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
        } else if startTime == 7 {
            fromTime += "T17:00:00"
            if sessionDuration == 1 {
                toTime += "T17:15:00"
            } else if sessionDuration == 2 {
                toTime += "T17:30:00"
            } else if sessionDuration == 3 {
                toTime += "T18:00:00"
            }
        } else if startTime == 8 {
            fromTime += "T18:00:00"
            if sessionDuration == 1 {
                toTime += "T18:15:00"
            } else if sessionDuration == 2 {
                toTime += "T18:30:00"
            } else if sessionDuration == 3 {
                toTime += "T19:00:00"
            }
        } else if startTime == 9 {
            fromTime += "T19:00:00"
            if sessionDuration == 1 {
                toTime += "T19:15:00"
            } else if sessionDuration == 2 {
                toTime += "T19:30:00"
            } else if sessionDuration == 3 {
                toTime += "T20:00:00"
            }
        } else if startTime == 10 {
            fromTime += "T20:00:00"
            if sessionDuration == 1 {
                toTime += "T20:15:00"
            } else if sessionDuration == 2 {
                toTime += "T20:30:00"
            } else if sessionDuration == 3 {
                toTime += "T21:00:00"
            }
        } else if startTime == 11 {
            fromTime += "T21:00:00"
            if sessionDuration == 1 {
                toTime += "T21:15:00"
            } else if sessionDuration == 2 {
                toTime += "T21:30:00"
            } else if sessionDuration == 3 {
                toTime += "T22:00:00"
            }
        } else if startTime == 12 {
            fromTime += "T22:00:00"
            if sessionDuration == 1 {
                toTime += "T22:15:00"
            } else if sessionDuration == 2 {
                toTime += "T22:30:00"
            } else if sessionDuration == 3 {
                toTime += "T23:00:00"
            }
        } else {
            print("oops!")
            fromTime += "T00:00:00"
            toTime += "T00:00:00"
        }

        // call reschedule API and go back
        showIndicator(sender: nil, viewController: self)
        webAPI.rescheduleBooking(id: bookId, bookStartTime: fromTime, bookEndTime: toTime) { data, response, error in
            DispatchQueue.main.async {
                hideIndicator(sender: nil);
            }
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    Toast.show(message: "Error while rescheduling..., try again later", controller: self)
                }
               
                return
            }
            DispatchQueue.main.async {
                Toast.show(message: "Booking rescheduled!", controller: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        // do stuff 1 seconds later
                    let transition = CATransition()
                    transition.duration = 0.5 // Set animation duration
                    transition.type = CATransitionType.push // Set transition type to push
                    transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
                    self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
                    self.dismiss(animated: false)
                }
            }
        }
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
