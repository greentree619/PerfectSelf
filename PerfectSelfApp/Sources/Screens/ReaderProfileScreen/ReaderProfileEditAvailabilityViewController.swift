//
//  ReaderProfileEditAvailabilityViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import BDatePicker

class ReaderProfileEditAvailabilityViewController: UIViewController {

    let backgroundView = UIView()
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
        self.navigationItem.setHidesBackButton(true, animated: false)
        modal_time_start.isHidden = true
        modal_time_start.alpha = 0
        modal_time_end.isHidden = true
        modal_time_end.alpha = 0
        dateFormatter.dateFormat = "hh:mm a"
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
             self.text_starttime.text = self.dateFormatter.string(from: self.picker_start_time.date)
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
             self.text_end.text = self.dateFormatter.string(from: self.picker_end_time.date)
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
    @IBAction func SaveChanges(_ sender: UIButton) {
        // call API to add new availability
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_starttime.text!.isEmpty){
            inputCheck += "- Please set start time.\n"
            if(focusTextField == nil){
                focusTextField = text_starttime
            }
        }
        
        if(text_end.text!.isEmpty){
            inputCheck += "- Please set end time.\n"
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
        showIndicator(sender: nil, viewController: self)
        let uid = UserDefaults.standard.string(forKey: "USER_ID")!
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        print(df.string(from: picker_date.date))
        webAPI.addAvailability(uid: uid, date: df.string(from: picker_date.date), fromTime: df.string(from: picker_start_time.date), toTime: df.string(from: picker_end_time.date)) { data, response, error in
            DispatchQueue.main.async {
                hideIndicator(sender: nil);
            }
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            DispatchQueue.main.async {
                Toast.show(message: "Successfully added new time slot", controller: self)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
