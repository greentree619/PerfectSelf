//
//  ReaderProfileEditHourlyRateViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/31/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ReaderProfileEditHourlyRateViewController: UIViewController {
    var hourlyrate: Int = 0
    var uid = ""
    @IBOutlet weak var text_rate: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        text_rate.text = String(hourlyrate)
    }


    @IBAction func SaveChange(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_rate.text!.isEmpty){
            inputCheck += "- Please input hourly rate.\n"
            if(focusTextField == nil){
                focusTextField = text_rate
            }
        }
        guard let newRate = Int(text_rate.text!) else {
            showAlert(viewController: self, title: "Warning", message: "Input number invalid") {_ in
                
            }
            return
        }
        
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        // call API for about update
        showIndicator(sender: nil, viewController: self)

        webAPI.editReaderHourlyRate(uid: uid, hourlyRate: newRate ) { data, response, error in
            
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    hideIndicator(sender: nil);
                    Toast.show(message: "Something went wrong. please try again later", controller: self)
                }
                return
            }
            DispatchQueue.main.async {
                let transition = CATransition()
                transition.duration = 0.5 // Set animation duration
                transition.type = CATransitionType.push // Set transition type to push
                transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
                self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
                self.dismiss(animated: false)
            }
        }
    }
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
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
