//
//  SignupDetailViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class SignupDetailViewController: UIViewController {
    var email: String = ""
    var phoneNumber: String = ""
    var password: String = ""
    var isActor: Bool = true
    
    @IBOutlet weak var btn_actor: UIButton!
    @IBOutlet weak var btn_reader: UIButton!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SelectActorThpe(_ sender: UIButton) {
        sender.borderWidth = 3;
        btn_reader.borderWidth = 0;
        isActor = true
    }
    
    @IBAction func SelectReaderType(_ sender: UIButton) {
        sender.borderWidth = 3;
        btn_actor.borderWidth = 0;
        isActor = false
    }
    
    @IBAction func FinishSignUp(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(txtUserName.text!.isEmpty){
            inputCheck += "- Please input user name.\n"
            if(focusTextField == nil){
                focusTextField = txtUserName
            }
        }
        
        if(txtFirstName.text!.isEmpty){
            inputCheck += "- Please input user first name.\n"
            if(focusTextField == nil){
                focusTextField = txtFirstName
            }
        }
        
        if(txtLastName.text!.isEmpty){
            inputCheck += "- Please input user last name.\n"
            if(focusTextField == nil){
                focusTextField = txtLastName
            }
        }
        
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        
        if isActor {
            showIndicator(sender: sender, viewController: self)
            webAPI.signup(userType: 3, userName: txtUserName.text!, firstName: txtFirstName.text!, lastName: txtLastName.text!, email: email, password: password, phoneNumber: phoneNumber) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                    }
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    //print(responseJSON["result"])
                    guard responseJSON["email"] != nil else {
                        DispatchQueue.main.async {
                            hideIndicator(sender: sender)
                            Toast.show(message: "Signup failed! please try again.", controller: self)
                            //self.text_email.becomeFirstResponder()
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                        //{{REFME
                        Toast.show(message: "Successfully signed up!", controller: self)
                        UserDefaults.standard.set(responseJSON["uid"], forKey: "USER_ID")
                        UserDefaults.standard.set(responseJSON["token"], forKey: "USER_TOKEN")
                        UserDefaults.standard.set(String(self.txtUserName.text!), forKey: "USER_NAME")
                        UserDefaults.standard.set(String(self.email), forKey: "USER_EMAIL")
                        UserDefaults.standard.set(String(self.password), forKey: "USER_PWD")
                        UserDefaults.standard.set("actor", forKey: "USER_TYPE")
                        //}}REFME
                        
                        let controller = ActorBuildProfile1ViewController()
                        self.navigationController?.pushViewController(controller, animated: true);
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                        Toast.show(message: "Signup failed! please try again.", controller: self)
                    }
                }
            }
        }
        else {
            showIndicator(sender: sender, viewController: self)
            webAPI.signup(userType: 4, userName: txtUserName.text!, firstName: txtFirstName.text!, lastName: txtLastName.text!, email: email, password: password, phoneNumber: phoneNumber) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                    }
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("statusCode: \(httpResponse.statusCode)")
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    //print(responseJSON["result"])
                    guard responseJSON["email"] != nil else {
                        DispatchQueue.main.async {
                            hideIndicator(sender: sender)
                            Toast.show(message: "Signup failed! please try again.", controller: self)
                            //self.text_email.becomeFirstResponder()
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                        //{{REFME
                        Toast.show(message: "Successfully signed up!", controller: self)
                        UserDefaults.standard.set(responseJSON["uid"], forKey: "USER_ID")
                        UserDefaults.standard.set(responseJSON["token"], forKey: "USER_TOKEN")
                        UserDefaults.standard.set(String(self.txtUserName.text!), forKey: "USER_NAME")
                        UserDefaults.standard.set(String(self.email), forKey: "USER_EMAIL")
                        UserDefaults.standard.set(String(self.password), forKey: "USER_PWD")
                        UserDefaults.standard.set("reader", forKey: "USER_TYPE")
                        //}}REFME
                        
                        let controller = ReaderBuildProfileViewController()
                        controller.id = responseJSON["uid"] as! String
                        controller.username = self.txtUserName.text!
                        self.navigationController?.pushViewController(controller, animated: true);
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                        hideIndicator(sender: sender)
                        Toast.show(message: "Signup failed! please try again.", controller: self)
                    }
                }
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
