//
//  ReaderBuildProfileViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/31/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import DropDown

class ReaderBuildProfileViewController: UIViewController {

    var username = ""
    var firstname = ""
    var lastname = ""
    var email = ""
    var password = ""
    var phonenumber = ""
    
    @IBOutlet weak var text_hourly: UITextField!
    @IBOutlet weak var text_gender: UITextField!
    @IBOutlet weak var text_title: UITextField!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var genderView: UIStackView!
    let dropDownForGender = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        lbl_name.text = username
        dropDownForGender.anchorView = genderView
        dropDownForGender.dataSource = ["Select...", "Male", "Female", "Decline to self-identity"]
        dropDownForGender.selectionAction = { [unowned self] (index: Int, item: String) in
            text_gender.text = item
        }
        // Top of drop down will be below the anchorView
        dropDownForGender.bottomOffset = CGPoint(x: 0, y:(dropDownForGender.anchorView?.plainView.bounds.height)!)
        dropDownForGender.dismissMode = .onTap
        
        DropDown.startListeningToKeyboard()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.link
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 40
        DropDown.appearance().setupCornerRadius(5)
    }
    @IBAction func ShowDropDownForGender(_ sender: UIButton) {
        dropDownForGender.show()
        
    }
    @IBAction func Done(_ sender: UIButton) {
        // calll API for reader signup
        
        showIndicator(sender: sender, viewController: self)
        webAPI.signup(userType: READER_UTYPE, userName: username, firstName: firstname, lastName: lastname, email: email, password: password, phoneNumber: phonenumber) { data, response, error in
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
                    UserDefaults.standard.set(self.username, forKey: "USER_NAME")
                    UserDefaults.standard.set(self.email, forKey: "USER_EMAIL")
                    UserDefaults.standard.set(self.password, forKey: "USER_PWD")
                    UserDefaults.standard.set("reader", forKey: "USER_TYPE")
                    //}}REFME
                    
                    let controller = ReaderTabBarController();
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false)
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
