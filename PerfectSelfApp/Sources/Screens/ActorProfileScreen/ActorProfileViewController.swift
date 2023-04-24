//
//  ActorProfileViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/19/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import Photos

class ActorProfileViewController: UIViewController, PhotoDelegate {

    var id = ""
    var photoType = 0//0: from lib, 1: from camera
    @IBOutlet weak var lbl_fullname: UILabel!
    @IBOutlet weak var lbl_username: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var img_user_avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Retrieve the saved data from UserDefaults
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            id = userInfo["uid"] as! String
            let name = userInfo["userName"] as? String
            let fname = userInfo["firstName"] as? String
            let lname = userInfo["lastName"] as? String
            let email = userInfo["email"] as? String
            
            let bucketName = userInfo["avatarBucketName"] as? String
            let avatarKey = userInfo["avatarKey"] as? String
            
            if (bucketName != nil && avatarKey != nil) {
                let url = "https://\( bucketName!).s3.us-east-2.amazonaws.com/\(avatarKey!)"
                img_user_avatar.imageFrom(url: URL(string: url)!)
            }
            lbl_fullname.text = (fname ?? "") + " " + (lname ?? "")
            lbl_username.text = name
            lbl_email.text = email
        } else {
            // No data was saved
            print("No data was saved.")
        }
    }
    @IBAction func UploadImage(_ sender: UIButton) {
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
                        self.img_user_avatar.image = UIImage(systemName: "person.fill")
                    }
                    
                } else {
                    // No data was saved
                    print("No data was saved.")
                }
            }
        }
    }
    @IBAction func EditProfile(_ sender: UITapGestureRecognizer) {
        let controller = ActorProfileEditViewController()
        controller.modalPresentationStyle = .fullScreen
       
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
    }
    
    @IBAction func ChangePassword(_ sender: UITapGestureRecognizer) {
        let controller = ActorProfileChangePasswordViewController()
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
        
    }
    
    @IBAction func LogOut(_ sender: UITapGestureRecognizer) {
        // Optional: Dismiss the tab bar controller
        // Delete localstorage
        UserDefaults.standard.removeObject(forKey: "USER")
        // Delete localstorage
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.dismiss(animated: false, completion: nil)
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
extension ActorProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let awsUpload = AWSMultipartUpload()
            DispatchQueue.main.async {
                showIndicator(sender: nil, viewController: self, color:UIColor.white)
//                Toast.show(message: "Start to upload record files", controller: self)
            }
            // Get the URL of the selected image
            var avatarUrl: URL? = nil
            //Upload audio at first
            guard let image = info[.originalImage] as? UIImage else {
                //dismiss(animated: true, completion: nil)
                return
            }
            // save to local and get URL
            if self.photoType == 1 {
                // Save the image to the photo library
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                // Get the file path of the saved image
                guard let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset else {
                    return
                }
                let options = PHContentEditingInputRequestOptions()
                options.canHandleAdjustmentData = {(adjustmentData: PHAdjustmentData) -> Bool in
                    return true
                }
                asset.requestContentEditingInput(with: options) { (contentEditingInput, _) in
                    avatarUrl = contentEditingInput?.fullSizeImageURL
                }
            }
            else {
                avatarUrl = info[.imageURL] as? URL
            }
            if avatarUrl != nil {
                //Then Upload image
                awsUpload.uploadImage(filePath: avatarUrl!, bucketName: "perfectself-avatar-bucket", prefix: self.id) { (error: Error?) -> Void in
                    if(error == nil)
                    {
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil)
                            Toast.show(message: "Avatar Image upload completed.", controller: self)
                            // update avatar
                            let url = "https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/\(self.id)/\(String(describing: avatarUrl!.lastPathComponent))"
                            self.img_user_avatar.imageFrom(url: URL(string: url)!)
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
