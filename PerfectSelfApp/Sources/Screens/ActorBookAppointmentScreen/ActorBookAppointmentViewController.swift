
//  ActorBookAppointmentViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/21/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBookAppointmentViewController: UIViewController {
//
//    var isSelected9AM = false
//    var isSelected10AM = false
//    var isSelected11AM = false
//    var isSelected2PM = false
//    var isSelected3PM = false
//    var isSelected4PM = false
//
//    @IBOutlet weak var btn_9am: UIButton!
//    @IBOutlet weak var btn_10am: UIButton!
//    @IBOutlet weak var btn_11am: UIButton!
//    @IBOutlet weak var btn_2pm: UIButton!
//    @IBOutlet weak var btn_3pm: UIButton!
//    @IBOutlet weak var btn_4pm: UIButton!

    var rUid: String = ""
    let backgroundView = UIView()
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    @IBOutlet weak var text_end: UITextField!
    @IBOutlet weak var text_starttime: UITextField!
  
    @IBOutlet weak var modal_time_start: UIView!
    @IBOutlet weak var modal_time_end: UIView!
    
    @IBOutlet weak var picker_start_time: UIDatePicker!
    @IBOutlet weak var picker_end_time: UIDatePicker!
    @IBOutlet weak var picker_date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        text_starttime.inputView = picker_start_time
//        text_end.inputView = picker_end_time
        
        modal_time_start.isHidden = true
        modal_time_start.alpha = 0
        modal_time_end.isHidden = true
        modal_time_end.alpha = 0
        timeFormatter.dateFormat = "hh:mm a"
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    @IBAction func SelectStartTime(_ sender: UIButton) {
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundView, belowSubview: modal_time_start)
       
        modal_time_start.isHidden = false
        modal_time_start.alpha = 1
        modal_time_start.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)

//        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
        //use if you want to darken the background
          //self.viewDim.alpha = 0.8
          //go back to original form
          self.modal_time_start.transform = .identity
        })
        
    }
    
    @IBAction func ApplyStartTime(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
         //use if you wish to darken the background
           //self.viewDim.alpha = 0
           self.modal_time_start.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

         }) { (success) in
             self.text_starttime.text = self.timeFormatter.string(from: self.picker_start_time.date)
             self.modal_time_start.isHidden = true
             self.modal_time_start.alpha = 0
             self.backgroundView.removeFromSuperview()
         }
    }
    @IBAction func CloseStartTime(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
         //use if you wish to darken the background
           //self.viewDim.alpha = 0
           self.modal_time_start.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

         }) { (success) in
             self.modal_time_start.isHidden = true
             self.modal_time_start.alpha = 0
             self.backgroundView.removeFromSuperview()
         }
    }
    @IBAction func SelectEndTime(_ sender: UIButton) {
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundView, belowSubview: modal_time_end)
       
        modal_time_end.isHidden = false
        modal_time_end.alpha = 1
        modal_time_end.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)

//        self.view.addSubview(popupView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
        //use if you want to darken the background
          //self.viewDim.alpha = 0.8
          //go back to original form
          self.modal_time_end.transform = .identity
        })
    }
    @IBAction func ApplyEndTime(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
         //use if you wish to darken the background
           //self.viewDim.alpha = 0
           self.modal_time_end.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

         }) { (success) in
             self.text_end.text = self.timeFormatter.string(from: self.picker_end_time.date)
             self.modal_time_end.isHidden = true
             self.modal_time_end.alpha = 0
             self.backgroundView.removeFromSuperview()
         }
    }
    @IBAction func CloseEndTime(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
         //use if you wish to darken the background
           //self.viewDim.alpha = 0
           self.modal_time_end.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)

         }) { (success) in
             self.modal_time_end.isHidden = true
             self.modal_time_end.alpha = 0
             self.backgroundView.removeFromSuperview()
         }
    }
    @IBAction func ContinueToUploadScript(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_starttime.text!.isEmpty){
            inputCheck += "- Please input user email.\n"
            if(focusTextField == nil){
                focusTextField = text_starttime
            }
        }
        
        if(text_end.text!.isEmpty){
            inputCheck += "- Please input user password.\n"
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
        
        let controller = ActorBookUploadScriptViewController()
        controller.readerUid = rUid
        controller.bookingDate = self.dateFormatter.string(from: self.picker_date.date)
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss"
        controller.bookingTime = df.string(from: picker_start_time.date)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
//        self.navigationController?.pushViewController(controller, animated: true)
    }
//
//    @IBAction func Select9Time(_ sender: UIButton) {
////        sender.isSelected = !sender.isSelected
//
//        isSelected9AM = !isSelected9AM
//
//        if isSelected9AM {
//            sender.backgroundColor = .black
//            sender.setTitleColor(.white, for: .normal)
//
////            isSelected9AM = false
//            isSelected10AM = false
//            isSelected11AM = false
//            isSelected2PM = false
//            isSelected3PM = false
//            isSelected4PM = false
////            btn_9am.backgroundColor = .white
////            btn_9am.setTitleColor(.black, for: .normal)
//            btn_10am.backgroundColor = .white
//            btn_10am.setTitleColor(.black, for: .normal)
//            btn_11am.backgroundColor = .white
//            btn_11am.setTitleColor(.black, for: .normal)
//            btn_2pm.backgroundColor = .white
//            btn_2pm.setTitleColor(.black, for: .normal)
//            btn_3pm.backgroundColor = .white
//            btn_3pm.setTitleColor(.black, for: .normal)
//            btn_4pm.backgroundColor = .white
//            btn_4pm.setTitleColor(.black, for: .normal)
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(.black, for: .normal)
//        }
//    }
//    @IBAction func Select10Time(_ sender: UIButton) {
////        sender.isSelected = !sender.isSelected
//        isSelected10AM = !isSelected10AM
//
//        if isSelected10AM {
//            sender.backgroundColor = .black
//            sender.setTitleColor(.white, for: .normal)
//
//            isSelected9AM = false
////            isSelected10AM = false
//            isSelected11AM = false
//            isSelected2PM = false
//            isSelected3PM = false
//            isSelected4PM = false
//            btn_9am.backgroundColor = .white
//            btn_9am.setTitleColor(.black, for: .normal)
////            btn_10am.backgroundColor = .white
////            btn_10am.setTitleColor(.black, for: .normal)
//            btn_11am.backgroundColor = .white
//            btn_11am.setTitleColor(.black, for: .normal)
//            btn_2pm.backgroundColor = .white
//            btn_2pm.setTitleColor(.black, for: .normal)
//            btn_3pm.backgroundColor = .white
//            btn_3pm.setTitleColor(.black, for: .normal)
//            btn_4pm.backgroundColor = .white
//            btn_4pm.setTitleColor(.black, for: .normal)
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(.black, for: .normal)
//        }
//    }
//    @IBAction func Select11Time(_ sender: UIButton) {
////        sender.isSelected = !sender.isSelected
//        isSelected11AM = !isSelected11AM
//
//        if isSelected11AM {
//            sender.backgroundColor = .black
//            sender.setTitleColor(.white, for: .normal)
//
//            isSelected9AM = false
//            isSelected10AM = false
////            isSelected11AM = false
//            isSelected2PM = false
//            isSelected3PM = false
//            isSelected4PM = false
//            btn_9am.backgroundColor = .white
//            btn_9am.setTitleColor(.black, for: .normal)
//            btn_10am.backgroundColor = .white
//            btn_10am.setTitleColor(.black, for: .normal)
////            btn_11am.backgroundColor = .white
////            btn_11am.setTitleColor(.black, for: .normal)
//            btn_2pm.backgroundColor = .white
//            btn_2pm.setTitleColor(.black, for: .normal)
//            btn_3pm.backgroundColor = .white
//            btn_3pm.setTitleColor(.black, for: .normal)
//            btn_4pm.backgroundColor = .white
//            btn_4pm.setTitleColor(.black, for: .normal)
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(.black, for: .normal)
//        }
//    }
//    @IBAction func Select2Time(_ sender: UIButton) {
////        sender.isSelected = !sender.isSelected
//        isSelected2PM = !isSelected2PM
//
//        if isSelected2PM {
//            sender.backgroundColor = .black
//            sender.setTitleColor(.white, for: .normal)
//
//            isSelected9AM = false
//            isSelected10AM = false
//            isSelected11AM = false
////            isSelected2PM = false
//            isSelected3PM = false
//            isSelected4PM = false
//            btn_9am.backgroundColor = .white
//            btn_9am.setTitleColor(.black, for: .normal)
//            btn_10am.backgroundColor = .white
//            btn_10am.setTitleColor(.black, for: .normal)
//            btn_11am.backgroundColor = .white
//            btn_11am.setTitleColor(.black, for: .normal)
////            btn_2pm.backgroundColor = .white
////            btn_2pm.setTitleColor(.black, for: .normal)
//            btn_3pm.backgroundColor = .white
//            btn_3pm.setTitleColor(.black, for: .normal)
//            btn_4pm.backgroundColor = .white
//            btn_4pm.setTitleColor(.black, for: .normal)
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(.black, for: .normal)
//        }
//    }
//    @IBAction func Select3Time(_ sender: UIButton) {
////        sender.isSelected = !sender.isSelected
//        isSelected3PM = !isSelected3PM
//
//        if isSelected3PM {
//            sender.backgroundColor = .black
//            sender.setTitleColor(.white, for: .normal)
//
//            isSelected9AM = false
//            isSelected10AM = false
//            isSelected11AM = false
//            isSelected2PM = false
////            isSelected3PM = false
//            isSelected4PM = false
//            btn_9am.backgroundColor = .white
//            btn_9am.setTitleColor(.black, for: .normal)
//            btn_10am.backgroundColor = .white
//            btn_10am.setTitleColor(.black, for: .normal)
//            btn_11am.backgroundColor = .white
//            btn_11am.setTitleColor(.black, for: .normal)
//            btn_2pm.backgroundColor = .white
//            btn_2pm.setTitleColor(.black, for: .normal)
////            btn_3pm.backgroundColor = .white
////            btn_3pm.setTitleColor(.black, for: .normal)
//            btn_4pm.backgroundColor = .white
//            btn_4pm.setTitleColor(.black, for: .normal)
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(.black, for: .normal)
//        }
//    }
//    @IBAction func Select4Time(_ sender: UIButton) {
////        sender.isSelected = !sender.isSelected
//        isSelected4PM = !isSelected4PM
//
//        if isSelected4PM {
//            sender.backgroundColor = .black
//            sender.setTitleColor(.white, for: .normal)
//
//            isSelected9AM = false
//            isSelected10AM = false
//            isSelected11AM = false
//            isSelected2PM = false
//            isSelected3PM = false
////            isSelected4PM = false
//            btn_9am.backgroundColor = .white
//            btn_9am.setTitleColor(.black, for: .normal)
//            btn_10am.backgroundColor = .white
//            btn_10am.setTitleColor(.black, for: .normal)
//            btn_11am.backgroundColor = .white
//            btn_11am.setTitleColor(.black, for: .normal)
//            btn_2pm.backgroundColor = .white
//            btn_2pm.setTitleColor(.black, for: .normal)
//            btn_3pm.backgroundColor = .white
//            btn_3pm.setTitleColor(.black, for: .normal)
////            btn_4pm.backgroundColor = .white
////            btn_4pm.setTitleColor(.black, for: .normal)
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(.black, for: .normal)
//        }
//    }
    @IBAction func GoBack(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
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
