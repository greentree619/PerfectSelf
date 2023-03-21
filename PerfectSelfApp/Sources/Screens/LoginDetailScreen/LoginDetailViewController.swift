//
//  LoginDetailViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit

class LoginDetailViewController: UIViewController {
    let checkedImage = UIImage(named: "icons8-checked-checkbox-14")! as UIImage
    let uncheckedImage = UIImage(named: "icons8-unchecked-checkbox-14")! as UIImage
    let show = UIImage(named: "icons8-eye-20")! as UIImage
    let hide = UIImage(named : "icons8-hide-20")! as UIImage
    
    @IBOutlet weak var btn_actor: UIButton!
    @IBOutlet weak var btn_reader: UIButton!
    @IBOutlet weak var btn_forgotpassword: UIButton!
    @IBOutlet weak var text_email: UITextField!
    @IBOutlet weak var text_password: UITextField!
    @IBOutlet weak var btn_showpassword: UIButton!
    
    var isShowPassword = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        btn_actor.isSelected = true;
        btn_reader.isSelected = false;
        btn_forgotpassword.isSelected = false;
        text_password.isSecureTextEntry = true;
        
        isShowPassword = false;
    }
    
    @IBAction func DoLogin(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_email.text!.isEmpty){
            inputCheck += "- Please input user email.\n"
            if(focusTextField == nil){
                focusTextField = text_email
            }
        }
        if(text_password.text!.isEmpty){
            inputCheck += "- Please input user password.\n"
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
        
        showIndicator(sender: sender, viewController: self)
        webAPI.login(email: text_email.text!, password: text_password.text!){ data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                //print(responseJSON["result"])
                guard let result = responseJSON["result"] else {
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                        Toast.show(message: "Login failed! please try again.", controller: self)
                        self.text_email.becomeFirstResponder()
                    }
                    return
                }
                
                if result as! Bool {
                    //let user = responseJSON["user"] as? [String: Any]
                    //let token = user!["token"] as? String
                    //print(token!+"test")
                    
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                        if self.btn_actor.isSelected {
                            let controller = ActorTabBarController();
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                        else {
                            let controller = ReaderTabBarController();
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                        Toast.show(message: "Login failed! please try again.", controller: self)
                        self.text_email.becomeFirstResponder()
                    }
                }
            }
        }
    }
    
    @IBAction func ActorSelected(_ sender: UIButton) {
        sender.isSelected=true;
        sender.borderWidth = 3;
        btn_reader.borderWidth = 0;
        btn_reader.isSelected = false;
    }
    @IBAction func ReaderSelected(_ sender: UIButton) {
        sender.isSelected=true;
        sender.borderWidth = 3;
        btn_actor.borderWidth = 0;
        btn_actor.isSelected = false;
    }
    
    @IBAction func ChangeForgotPassword(_ sender: UIButton) {
        sender.isSelected.toggle();
        
        if sender.isSelected {
            sender.setImage(checkedImage, for: UIControl.State.normal);
            sender.tintColor = UIColor(red:255,green: 255, blue: 255,  alpha: 1);
        }
        else {
            sender.setImage(uncheckedImage, for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func ShowPassword(_ sender: UIButton) {
        isShowPassword = !isShowPassword;
        
        if isShowPassword {
            text_password.isSecureTextEntry = false;
            sender.setImage(show, for: UIControl.State.normal);
        }
        else {
            text_password.isSecureTextEntry = true;
            sender.setImage(hide, for: UIControl.State.normal);
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
