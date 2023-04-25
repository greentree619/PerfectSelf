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
    
    @IBOutlet weak var btn_standby_yes: UIButton!
    @IBOutlet weak var btn_standby_no: UIButton!
    @IBOutlet weak var text_repeat: UITextField!
    @IBOutlet weak var repeatView: UIStackView!
    var repeatFlag = 0
    var startTime = -1
    let dropDownForRepeat = DropDown()
    
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
    }
    @IBAction func showDropDown(_ sender: UITapGestureRecognizer) {
        dropDownForRepeat.show()
    }
    @IBAction func SelectedDateChanged(_ sender: UIDatePicker) {
        
    }

    @IBAction func SaveChanges(_ sender: UIButton) {
       // call API for save changes
//        webAPI.updateAvailability(uid: uid, timeSlotList: timeSlotItems) { data, response, error in
//            guard let _ = data, error == nil else {
//                DispatchQueue.main.async {
//                    Toast.show(message: "Something went wrong!, try agian later.", controller: self)
//                }
//                return
//            }
//            DispatchQueue.main.async {
//                Toast.show(message: "Availability Updated!", controller: self)
//            }
//        }
    }
    
    @IBAction func SelectStandByYes(_ sender: UIButton) {
        btn_standby_no.isSelected = false
        btn_standby_yes.isSelected = true
    }
    
    @IBAction func SelectStandByNo(_ sender: UIButton) {
        btn_standby_no.isSelected = true
        btn_standby_yes.isSelected = false
    }
    @IBAction func Select9Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            startTime = 1
            sender.backgroundColor = UIColor.black
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select10Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            startTime = 1
            sender.backgroundColor = UIColor.black
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select11Am(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            startTime = 1
            sender.backgroundColor = UIColor.black
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select2Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            startTime = 1
            sender.backgroundColor = UIColor.black
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select3Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            startTime = 1
            sender.backgroundColor = UIColor.black
        }
        else {
            startTime = -1
            sender.backgroundColor = UIColor.white
        }
    }
    @IBAction func Select4Pm(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            startTime = 1
            sender.backgroundColor = UIColor.black
        }
        else {
            startTime = -1
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
