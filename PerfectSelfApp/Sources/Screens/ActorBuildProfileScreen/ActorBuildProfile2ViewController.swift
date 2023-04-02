//
//  ActorBuildProfile2ViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/18/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import DropDown

class ActorBuildProfile2ViewController: UIViewController {

//    var userType: String = ""
    @IBOutlet weak var genderview: UIStackView!
    @IBOutlet weak var ageview: UIStackView!
    let dropDownForGender = DropDown()
    let dropDownForAgeRange = DropDown()
    @IBOutlet weak var text_gender: UITextField!
    @IBOutlet weak var text_age: UITextField!
    @IBOutlet weak var text_username: UITextField!
    @IBOutlet weak var text_weight: UITextField!
    @IBOutlet weak var text_height: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        // The view to which the drop down will appear on
        text_username.text = UserDefaults.standard.string(forKey: "USER_NAME")
        dropDownForGender.anchorView = genderview // UIView or UIBarButtonItem
        dropDownForAgeRange.anchorView = ageview
        // The list of items to display. Can be changed dynamically
        dropDownForGender.dataSource = ["Select...", "Male", "Female", "Decline to self-identity"]
        dropDownForAgeRange.dataSource = ["Select...", "10-20", "21-30", "31-40", "41-50", "over 50"]
        // Action triggered on selection
        dropDownForGender.selectionAction = { [unowned self] (index: Int, item: String) in
            text_gender.text = item
          
        }
        dropDownForAgeRange.selectionAction = { [unowned self] (index: Int, item: String) in
            text_age.text = item
          
        }
        // Top of drop down will be below the anchorView
        dropDownForGender.bottomOffset = CGPoint(x: 0, y:(dropDownForGender.anchorView?.plainView.bounds.height)!)
        dropDownForAgeRange.bottomOffset = CGPoint(x: 0, y:(dropDownForAgeRange.anchorView?.plainView.bounds.height)!)
        
        dropDownForGender.dismissMode = .onTap
        dropDownForAgeRange.dismissMode = .onTap
        
        DropDown.startListeningToKeyboard()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.link
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 40
        DropDown.appearance().setupCornerRadius(5) // available since v2.3.6
        
    }

    @IBAction func ShowDropDownForAge(_ sender: UIButton) {
        dropDownForAgeRange.show()
    }
    @IBAction func ShowDropDownForGender(_ sender: UIButton) {
        dropDownForGender.show()
        
    }
    @IBAction func Later(_ sender: UIButton) {
        let controller = ActorTabBarController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false)
    }
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Continue(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_gender.text!.isEmpty){
            inputCheck += "- Please select gender.\n"
            if(focusTextField == nil){
                focusTextField = text_gender
            }
        }
        if(text_age.text!.isEmpty){
             inputCheck += "- Please select your age.\n"
             if(focusTextField == nil){
                 focusTextField = text_age
             }
         }
        if(text_height.text!.isEmpty){
            inputCheck += "- Please input your height.\n"
            if(focusTextField == nil){
                focusTextField = text_height
            }
        }
 
        if(text_weight.text!.isEmpty){
            inputCheck += "- Please input your weight.\n"
            if(focusTextField == nil){
                focusTextField = text_weight
            }
        }
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        let controller = ActorBuildProfile3ViewController()
        controller.username = text_username.text != nil ? text_username.text!: ""
        controller.gender = text_gender.text != nil ? text_gender.text!: ""
        controller.agerange = text_age.text != nil ? text_age.text! : ""
        controller.height = text_height.text != nil ? text_height.text! : ""
        controller.weight = text_weight.text != nil ? text_weight.text! : ""
//        controller.userType = userType
        self.navigationController?.pushViewController(controller, animated: true)
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
