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
    var id = ""
    @IBOutlet weak var genderview: UIStackView!
    @IBOutlet weak var ageview: UIStackView!
    let dropDownForGender = DropDown()
    let dropDownForAgeRange = DropDown()
    @IBOutlet weak var text_gender: UITextField!
    @IBOutlet weak var text_age: UITextField!
    @IBOutlet weak var text_username: UITextField!
    @IBOutlet weak var text_weight: UITextField!
    @IBOutlet weak var text_height: UITextField!
    @IBOutlet weak var img_avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        // The view to which the drop down will appear on
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            let name = userInfo["userName"] as! String
            id = userInfo["uid"] as! String
            text_username.text = name
        } else {
            // No data was saved
            print("No data was saved.")
        }
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

    @IBAction func SelectAvatar(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
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

/// Mark:https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/{room-id-000-00}/{647730C6-5E86-483A-859E-5FBF05767018.jpeg}
extension ActorBuildProfile2ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let awsUpload = AWSMultipartUpload()
            DispatchQueue.main.async {
                showIndicator(sender: nil, viewController: self, color:UIColor.white)
                Toast.show(message: "Start to upload record files", controller: self)
            }
            
            //Upload audio at first
            guard info[.originalImage] is UIImage else {
                //dismiss(animated: true, completion: nil)
                return
            }
                    
            // Get the URL of the selected image
            var avatarUrl: URL? = nil
            if let imageUrl = info[.imageURL] as? URL {
                avatarUrl = imageUrl
                //Then Upload image
                awsUpload.uploadImage(filePath: avatarUrl!, bucketName: "perfectself-avatar-bucket", prefix: self.id) { (error: Error?) -> Void in
                    if(error == nil)
                    {
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                            Toast.show(message: "Avatar Image upload completed.", controller: self)
                            // update avatar
                            let url = "https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/\(self.id)/\(String(describing: avatarUrl!.lastPathComponent))"
                            self.img_avatar.imageFrom(url: URL(string: url)!)
                            //update user profile
                            webAPI.updateUserAvatar(uid: self.id, bucketName: "perfectself-avatar-bucket", avatarKey: "\(self.id)/\(avatarUrl!.lastPathComponent)") { data, response, error in
                                if error == nil {
                                    // successfully update db
                                    print("update db completed")
                                }
                            }
                            
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                            Toast.show(message: "Failed to upload avatar image, Try again later!", controller: self)
                        }
                    }
                }
            }
        }//DispatchQueue.global
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

