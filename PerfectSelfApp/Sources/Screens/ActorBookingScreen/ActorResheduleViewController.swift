//
//  ActorResheduleViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 4/18/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorResheduleViewController: UIViewController {
    var bookId : Int!
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
    @IBAction func ConfirmReschedule(_ sender: UIButton) {
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

        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss"
        let s = dateFormatter.string(from: picker_date.date) + "T" + df.string(from: picker_start_time.date) + "Z"
        let e = dateFormatter.string(from: picker_date.date) + "T" + df.string(from: picker_end_time.date) + "Z"
        
        // call reschedule API and go back
        showIndicator(sender: nil, viewController: self)
        webAPI.rescheduleBooking(id: bookId, bookStartTime: s, bookEndTime: e) { data, response, error in
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
