//
//  TimeSelectPopUpViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 4/7/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import DropDown
protocol MyDelegate {
    func didUpdateTimeSlot(fromTime: Date, toTime: Date, repeatFlag: Int, isStandBy: Bool)
}

class TimeSelectPopUpViewController: UIViewController{
    let dateFormatter = DateFormatter()
    var delegate: MyDelegate?

    @IBOutlet weak var text_end: UITextField!
    @IBOutlet weak var text_starttime: UITextField!
    
    @IBOutlet weak var repeatView: UIStackView!
    @IBOutlet weak var startView: UIStackView!
    @IBOutlet weak var endView: UIStackView!
    
    @IBOutlet weak var text_repeat: UITextField!
    @IBOutlet weak var btn_standby_no: UIButton!
    @IBOutlet weak var btn_standby_yes: UIButton!
    let dropDownForRepeat = DropDown()
    var repeatFlag = 0 //No
    var isStandBy = false
    @IBOutlet weak var dropDownForStartTime: UIStackView!
    @IBOutlet weak var timePickerForStartTime: UIDatePicker!
    
    @IBOutlet weak var timePickerForEndTime: UIDatePicker!
    @IBOutlet weak var dropDownForEndTime: UIStackView!
    @IBOutlet weak var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dateFormatter.dateFormat = "hh:mm a"
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
        
        dropDownForStartTime.isHidden = true
        timePickerForStartTime.addTarget(self, action: #selector(startTimeValueChanged), for: .valueChanged)
        dropDownForEndTime.isHidden = true
        timePickerForEndTime.addTarget(self, action: #selector(endTimeValueChanged), for: .valueChanged)
        backView.isHidden = true
    }
    @objc func startTimeValueChanged() {
        text_starttime.text = dateFormatter.string(from: timePickerForStartTime.date)
        
        // Perform your desired function here
        print("Date selected: \(timePickerForStartTime.date)")
    }
    @objc func endTimeValueChanged() {
        text_end.text = dateFormatter.string(from: timePickerForEndTime.date)
        
        // Perform your desired function here
        print("Date selected: \(timePickerForStartTime.date)")
    }
    @IBAction func tapHideTimePicker(_ sender: UITapGestureRecognizer) {
        dropDownForStartTime.isHidden = true
        dropDownForEndTime.isHidden = true
        backView.isHidden = true
    }
    @IBAction func SaveTimeSlot(_ sender: UIButton) {
        // check if time is set properly
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_starttime.text!.isEmpty){
            inputCheck += "- Please input start time .\n"
            if(focusTextField == nil){
                focusTextField = text_starttime
            }
        }
        if(text_end.text!.isEmpty){
            inputCheck += "- Please input end time .\n"
            if(focusTextField == nil){
                focusTextField = text_end
            }
        }
 
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        // call delegate to add time slot
        // fromTime, toTime, repeatFlag, isAvailableToStandby
        delegate?.didUpdateTimeSlot(fromTime: timePickerForStartTime.date, toTime: timePickerForEndTime.date, repeatFlag: repeatFlag, isStandBy: isStandBy)
        self.dismiss(animated: true)
    }
    @IBAction func GoBack(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func SelectStartTime(_ sender: UIButton) {
        dropDownForStartTime.isHidden = false
        backView.isHidden = false
    }
    
    @IBAction func SelectEndTime(_ sender: UIButton) {
        dropDownForEndTime.isHidden = false
        backView.isHidden = false
    }
    @IBAction func ShowDropDownForRepeat(_ sender: UIButton) {
        dropDownForRepeat.show()
    }
    @IBAction func SelectStandByYes(_ sender: UIButton) {
        isStandBy = true
        sender.isSelected = true
        btn_standby_no.isSelected = false
    }
    @IBAction func SelectStandByNo(_ sender: UIButton) {
        isStandBy = false
        sender.isSelected = true
        btn_standby_yes.isSelected = false
    }
    @IBAction func tapDismiss(_ sender: UITapGestureRecognizer) {
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
