//
//  ReaderBuildProfileViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/31/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import DropDown

class ReaderBuildProfileViewController: UIViewController, PhotoDelegate {

    var id = ""
    var username = ""
    var photoType = 0//0: from lib, 1: from camera
    
    @IBOutlet weak var text_hourly: UITextField!
    @IBOutlet weak var text_gender: UITextField!
    @IBOutlet weak var text_title: UITextField!
    @IBOutlet weak var lbl_name: UILabel!
    
    @IBOutlet weak var img_avatar: UIImageView!
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
        // calll API for reader profile update
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_title.text!.isEmpty){
            inputCheck += "- Please input title .\n"
            if(focusTextField == nil){
                focusTextField = text_title
            }
        }
        if(text_gender.text!.isEmpty){
            inputCheck += "- Please select your gender .\n"
            if(focusTextField == nil){
                focusTextField = text_gender
            }
        }
        if(text_hourly.text!.isEmpty){
            inputCheck += "- Please input hourly rate .\n"
            if(focusTextField == nil){
                focusTextField = text_hourly
            }
        }
 
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        guard let rate = Int(text_hourly.text!) else {
            showAlert(viewController: self, title: "Warning", message: "Input number invalid") {_ in
                
            }
            return
        }
        showIndicator(sender: sender, viewController: self)
        webAPI.updateReaderProfile(uid: id, title: text_title.text!, gender: text_gender.text!, hourlyrate: rate) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

            if let _ = responseJSON as? [String: Any] {
                
                DispatchQueue.main.async {
                    hideIndicator(sender: sender)
                    let controller = ReaderTabBarController()
                    controller.modalPresentationStyle = .fullScreen
                    self.present(controller, animated: false)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    hideIndicator(sender: sender)
                    Toast.show(message: "Profile update failed! please try again.", controller: self)
                    print("error3")
                }
            }
        }
    }
    
    @IBAction func EditUserAvatar(_ sender: UIButton) {
        let controller = TakePhotoViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.delegate = self
        self.present(controller, animated: true)
    }
    func chooseFromLibrary() {
        photoType = 0
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func takePhoto() {
        photoType = 1
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func removeCurrentPicture() {
        // call API for remove picture
        //update user profile
        webAPI.updateUserAvatar(uid: self.id, bucketName: "", avatarKey: "") { data, response, error in
            if error == nil {
                // update local
                // Retrieve the saved data from UserDefaults
                if var userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
                    // Use the saved data
                    userInfo["avatarBucketName"] = ""
                    userInfo["avatarKey"] = ""
                    UserDefaults.standard.removeObject(forKey: "USER")
                    UserDefaults.standard.set(userInfo, forKey: "USER")
                    print(userInfo)
                    DispatchQueue.main.async {
                        self.img_avatar.image = UIImage(systemName: "person.circle.fill")
                    }
                    
                } else {
                    // No data was saved
                    print("No data was saved.")
                }
            }
        }
    }
    @IBAction func Later(_ sender: UIButton) {
        let controller = ReaderTabBarController()
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false)
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
extension ReaderBuildProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let awsUpload = AWSMultipartUpload()
            DispatchQueue.main.async {
                showIndicator(sender: nil, viewController: self, color:UIColor.white)
//                Toast.show(message: "Start to upload record files", controller: self)
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

