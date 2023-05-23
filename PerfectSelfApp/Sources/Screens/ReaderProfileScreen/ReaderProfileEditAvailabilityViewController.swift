//
//  ReaderProfileEditAvailabilityViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import DropDown

class ReaderProfileEditAvailabilityViewController: UIViewController {
    
    var uid : String = ""
    @IBOutlet weak var picker_date: UIDatePicker!

    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
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
    
    @IBOutlet weak var btn_standby_yes: UIButton!
    @IBOutlet weak var btn_standby_no: UIButton!
    @IBOutlet weak var text_repeat: UITextField!
    @IBOutlet weak var repeatView: UIStackView!
    var repeatFlag = 0
    var startTime = -1
    let dropDownForRepeat = DropDown()
    var timeSlotList = [TimeSlot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "yyyy-MM-dd"
        timeFormatter.dateFormat = "hh:mm"
        dropDownForRepeat.anchorView = repeatView
        dropDownForRepeat.dataSource = ["No", "Every Day", "Every Week", "Every Month"]
        dropDownForRepeat.selectionAction = { [unowned self] (index: Int, item: String) in
            text_repeat.text = item
            repeatFlag = index
            let id = getTimeSlotObjectIndex(d: picker_date.date)
            timeSlotList[id].repeatFlag = index
        }
        // Top of drop down will be below the anchorView
        dropDownForRepeat.bottomOffset = CGPoint(x: 0, y:(dropDownForRepeat.anchorView?.plainView.bounds.height)!)
        
        dropDownForRepeat.dismissMode = .onTap
        
        DropDown.startListeningToKeyboard()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.link
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 40
        DropDown.appearance().setupCornerRadius(5) // available since v2.3.6
        
        displayTimeSlotsForDate(d: Date())
    }
    @IBAction func showDropDown(_ sender: UITapGestureRecognizer) {
        dropDownForRepeat.show()
    }
    @IBAction func SelectedDateChanged(_ sender: UIDatePicker) {
        displayTimeSlotsForDate(d: sender.date)
    }
    func displayTimeSlotsForDate(d: Date) {
        let item = timeSlotList[getTimeSlotObjectIndex(d: d)]
        initTimeSlotState()
        if item.isStandBy {
            btn_standby_no.isSelected = false
            btn_standby_yes.isSelected = true
        }
        dropDownForRepeat.selectRow(item.repeatFlag)
        
        for t in item.time {
            if t.slot == 1 {
                btn_9am.isSelected = true
                btn_9am.backgroundColor = UIColor.black
            } else if t.slot == 2 {
                btn_10am.isSelected = true
                btn_10am.backgroundColor = UIColor.black
            } else if t.slot == 3 {
                btn_11am.isSelected = true
                btn_11am.backgroundColor = UIColor.black
            } else if t.slot == 4 {
                btn_2pm.isSelected = true
                btn_2pm.backgroundColor = UIColor.black
            } else if t.slot == 5 {
                btn_3pm.isSelected = true
                btn_3pm.backgroundColor = UIColor.black
            } else if t.slot == 6 {
                btn_4pm.isSelected = true
                btn_4pm.backgroundColor = UIColor.black
            } else if t.slot == 7 {
                btn_5pm.isSelected = true
                btn_5pm.backgroundColor = UIColor.black
            } else if t.slot == 8 {
                btn_6pm.isSelected = true
                btn_6pm.backgroundColor = UIColor.black
            } else if t.slot == 9 {
                btn_7pm.isSelected = true
                btn_7pm.backgroundColor = UIColor.black
            } else if t.slot == 10 {
                btn_8pm.isSelected = true
                btn_8pm.backgroundColor = UIColor.black
            } else if t.slot == 11 {
                btn_9pm.isSelected = true
                btn_9pm.backgroundColor = UIColor.black
            } else if t.slot == 12 {
                btn_10pm.isSelected = true
                btn_10pm.backgroundColor = UIColor.black
            } else {
                print("oops!")
            }
        }
    }
    func getTimeSlotObjectIndex(d: Date) -> Int {
        
        let index = timeSlotList.firstIndex(where: { dateFormatter.string(from: Date.getDateFromString(date: $0.date)!) == dateFormatter.string(from: d) })
        if index == nil {
            timeSlotList.append(TimeSlot(date: Date.getStringFromDate(date: picker_date.date), time: [], repeatFlag: 0, isStandBy: false))
        }
        return index ?? timeSlotList.count - 1
    }
    func initTimeSlotState() {
        dropDownForRepeat.selectRow(0)
        repeatFlag = 0
        text_repeat.text = "No"
        
        btn_standby_no.isSelected = true
        btn_standby_yes.isSelected = false
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
        btn_10pm.isSelected = false
        
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
        btn_10pm.backgroundColor = UIColor.white
    }
    @IBAction func SaveChanges(_ sender: UIButton) {
       // call API for save changes
        webAPI.updateAvailability(uid: uid, timeSlotList: timeSlotList) { data, response, error in
            guard let _ = data, error == nil else {
                DispatchQueue.main.async {
                    Toast.show(message: "Something went wrong!, try agian later.", controller: self)
                }
                return
            }
            DispatchQueue.main.async {
                Toast.show(message: "Availability Updated!", controller: self)
                self.GoBack(self.btn_4pm)
            }
        }
    }
    
    @IBAction func SelectStandByYes(_ sender: UIButton) {
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        timeSlotList[index].isStandBy = true
        btn_standby_no.isSelected = false
        btn_standby_yes.isSelected = true
    }
    
    @IBAction func SelectStandByNo(_ sender: UIButton) {
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        timeSlotList[index].isStandBy = false
        btn_standby_no.isSelected = true
        btn_standby_yes.isSelected = false
    }
    @IBAction func Select9Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 1 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 1, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select10Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 2 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 2, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select11Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 3 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 3, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select2Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 4 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 4, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select3Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 5 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 5, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select4Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 6 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 6, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select5Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 7 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 7, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select6Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 8 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 8, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select7Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 9 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 9, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select8Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 10 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 10, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select9Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 11 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 11, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func Select10Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let index = getTimeSlotObjectIndex(d: picker_date.date)
        let idx = timeSlotList[index].time.firstIndex(where: { $0.slot == 12 })
        
        if sender.isSelected {
            if idx != nil {
                timeSlotList[index].time[idx!].isDeleted = false
            }
            else {
                timeSlotList[index].time.append(Slot(id: 0, slot: 12, duration: 0, isDeleted: false))
            }
            
            sender.backgroundColor = UIColor.black
        }
        else {
            timeSlotList[index].time[idx!].isDeleted = true
            sender.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) //  Add transition to window layer
        self.dismiss(animated: true)
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
