//
//  SignupViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    let show = UIImage(named: "icons8-eye-20")! as UIImage
    let hide = UIImage(named : "icons8-hide-20")! as UIImage
    let showconfirm = UIImage(named: "icons8-eye-20")! as UIImage
    let hideconfirm = UIImage(named : "icons8-hide-20")! as UIImage
    
    @IBOutlet weak var text_confirmpassword: UITextField!
    @IBOutlet weak var text_password: UITextField!
    @IBOutlet weak var text_email: UITextField!
    @IBOutlet weak var text_phonenumber: UITextField!
    
    @IBOutlet weak var btn_showpassword: UIButton!
    
    @IBOutlet weak var btn_showconfirmpassword: UIButton!
    
    var isShowPass = false;
    var isShowPassConfirm = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func ChangeShowPassword(_ sender: UIButton) {
        isShowPass = !isShowPass;
        
        if isShowPass {
            text_password.isSecureTextEntry = false;
            sender.setImage(show, for: UIControl.State.normal);
        }
        else {
            text_password.isSecureTextEntry = true;
            sender.setImage(hide, for: UIControl.State.normal);
        }
    }
    
    @IBAction func ChangeShowCornfirmPass(_ sender: UIButton) {
        isShowPassConfirm = !isShowPassConfirm;
        
        if isShowPassConfirm {
            text_confirmpassword.isSecureTextEntry = false;
            sender.setImage(show, for: UIControl.State.normal);
        }
        else {
            text_confirmpassword.isSecureTextEntry = true;
            sender.setImage(hide, for: UIControl.State.normal);
        }
        
    }
    @IBAction func SignUp(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_email.text!.isEmpty){
            inputCheck += "- Please input user email.\n"
            if(focusTextField == nil){
                focusTextField = text_email
            }
        }
        
        if(!isValidEmail(email: text_email.text!)){
            inputCheck += "- Email format is wrong.\n"
            if(focusTextField == nil){
                focusTextField = text_email
            }
        }
        
        if(text_phonenumber.text!.isEmpty){
            inputCheck += "- Please input user phone number.\n"
            if(focusTextField == nil){
                focusTextField = text_phonenumber
            }
        }
        
        if(text_password.text!.isEmpty){
            inputCheck += "- Please input user password.\n"
            if(focusTextField == nil){
                focusTextField = text_password
            }
        }
        
        if(text_confirmpassword.text!.isEmpty){
            inputCheck += "- Please input user confirm password.\n"
            if(focusTextField == nil){
                focusTextField = text_confirmpassword
            }
        }
        
        if(!text_password.text!.isEmpty
           && !text_confirmpassword.text!.isEmpty
           && text_password.text!.compare(text_confirmpassword.text!).rawValue != 0){
            inputCheck += "- Password isn't match with confirm password.\n"
            if(focusTextField == nil){
                focusTextField = text_password
            }
        }
        
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        
        let controller = SignupDetailViewController();
        controller.modalPresentationStyle = .fullScreen
        controller.email = text_email.text!
        controller.phoneNumber = text_phonenumber.text!
        controller.password = text_password.text!
        
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
    }
    
    @IBAction func SignIn(_ sender: UIButton) {
        let controller = LoginDetailViewController();
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
