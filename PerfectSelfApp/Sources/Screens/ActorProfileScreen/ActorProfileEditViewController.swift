//
//  ActorProfileEditViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/19/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import DropDown
import Photos

class ActorProfileEditViewController: UIViewController, PhotoDelegate {
    var id = ""
    var photoType = 0//0: from lib, 1: from camera
    let dropDownForGender = DropDown()
    let dropDownForAgeRange = DropDown()
    let dropDownForCountry = DropDown()
    let dropDownForState = DropDown()
    let dropDownForCity = DropDown()
    let dropDownForAgency = DropDown()
    let dropDownForVaccination = DropDown()
    
    @IBOutlet weak var genderview: UIStackView!
    @IBOutlet weak var text_gender: UITextField!
    
    @IBOutlet weak var img_user_avatar: UIImageView!
    @IBOutlet weak var ageview: UIStackView!
    @IBOutlet weak var text_age: UITextField!
    
    @IBOutlet weak var text_country: UITextField!
    @IBOutlet weak var countryview: UIStackView!
    
    @IBOutlet weak var text_state: UITextField!
    @IBOutlet weak var stateview: UIStackView!
    
    @IBOutlet weak var text_city: UITextField!
    @IBOutlet weak var cityview: UIStackView!
    
    @IBOutlet weak var agencyview: UIStackView!
    @IBOutlet weak var text_agency: UITextField!
    
    @IBOutlet weak var vaccinationview: UIStackView!
    @IBOutlet weak var text_vaccination: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set dropdown
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
        
        dropDownForCountry.anchorView = countryview
        dropDownForCountry.dataSource = ["Not listed", "Country", "Country", "Country"]
        dropDownForCountry.selectionAction = { [unowned self] (index: Int, item: String) in
            text_country.text = item
          
        }
        dropDownForCountry.bottomOffset = CGPoint(x: 0, y:(dropDownForCountry.anchorView?.plainView.bounds.height)!)
        dropDownForCountry.dismissMode = .onTap
        
        // State
        dropDownForState.anchorView = stateview
        dropDownForState.dataSource = ["Not listed", "State", "State", "State"]
        dropDownForState.selectionAction = { [unowned self] (index: Int, item: String) in
            text_state.text = item
          
        }
        dropDownForState.bottomOffset = CGPoint(x: 0, y:(dropDownForState.anchorView?.plainView.bounds.height)!)
        dropDownForState.dismissMode = .onTap
        
        // City
        dropDownForCity.anchorView = cityview
        dropDownForCity.dataSource = ["Not listed", "City", "City", "City"]
        dropDownForCity.selectionAction = { [unowned self] (index: Int, item: String) in
            text_city.text = item
          
        }
        dropDownForCity.bottomOffset = CGPoint(x: 0, y:(dropDownForCity.anchorView?.plainView.bounds.height)!)
        dropDownForCity.dismissMode = .onTap
        
        // Agency
        dropDownForAgency.anchorView = agencyview
        dropDownForAgency.dataSource = ["Not listed", "Agency", "Agency", "Agency"]
        dropDownForAgency.selectionAction = { [unowned self] (index: Int, item: String) in
            text_agency.text = item
          
        }
        dropDownForAgency.bottomOffset = CGPoint(x: 0, y:(dropDownForAgency.anchorView?.plainView.bounds.height)!)
        dropDownForAgency.dismissMode = .onTap
        
        // Vaccination
        dropDownForVaccination.anchorView = vaccinationview
        dropDownForVaccination.dataSource = ["Not listed", "Vaccination", "Vaccination", "Vaccination"]
        dropDownForVaccination.selectionAction = { [unowned self] (index: Int, item: String) in
            text_vaccination.text = item
          
        }
        dropDownForVaccination.bottomOffset = CGPoint(x: 0, y:(dropDownForVaccination.anchorView?.plainView.bounds.height)!)
        dropDownForVaccination.dismissMode = .onTap
        
        
        DropDown.startListeningToKeyboard()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.link
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 40
        DropDown.appearance().setupCornerRadius(5) // available since v2.3.6
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Retrieve the saved data from UserDefaults
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            id = userInfo["uid"] as! String
            
            let bucketName = userInfo["avatarBucketName"] as? String
            let avatarKey = userInfo["avatarKey"] as? String
            
            if (bucketName != nil && avatarKey != nil) {
                let url = "https://\( bucketName!).s3.us-east-2.amazonaws.com/\(avatarKey!)"
                img_user_avatar.imageFrom(url: URL(string: url)!)
            }
        } else {
            // No data was saved
            print("No data was saved.")
        }
    }
    @IBAction func SaveChanges(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.dismiss(animated: false)
    }
    @IBAction func ShowDropDownForAge(_ sender: UIButton) {
        dropDownForAgeRange.show()
    }
    @IBAction func ShowDropDownForGender(_ sender: UIButton) {
        dropDownForGender.show()
        
    }
    @IBAction func ShowCountryDropDown(_ sender: UIButton) {
        dropDownForCountry.show()
    }
    @IBAction func ShowStateDropDown(_ sender: UIButton) {
        dropDownForState.show()
    }
    @IBAction func ShowCityDropDown(_ sender: UIButton) {
        dropDownForCity.show()
    }
    @IBAction func ShowAgencyDropDown(_ sender: UIButton) {
        dropDownForAgency.show()
    }
    @IBAction func ShowVaccinationDropDown(_ sender: UIButton) {
        dropDownForVaccination.show()
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
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    func removeCurrentPicture() {
        // call API for remove picture
        //update user profile
        webAPI.updateUserInfo(uid: self.id, userType: -1, bucketName: "", avatarKey: "", username: "", email: "", password: "", firstName: "", lastName: "", dateOfBirth: "", gender: -1, currentAddress: "", permanentAddress: "", city: "", nationality: "", phoneNumber: "", isLogin: true, fcmDeviceToken: "", deviceKind: -1) { data, response, error in
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

/// Mark:https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/{room-id-000-00}/{647730C6-5E86-483A-859E-5FBF05767018.jpeg}
extension ActorProfileEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            //Omitted let awsUpload = AWSMultipartUpload()
            DispatchQueue.main.async {
                showIndicator(sender: nil, viewController: self, color:UIColor.white)
//                Toast.show(message: "Start to upload record files", controller: self)
            }
            // Get the URL of the selected image
            var avatarUrl: URL? = nil
            //Upload audio at first
            guard let image = (self.photoType == 0 ? info[.originalImage] : info[.editedImage]) as? UIImage else {
                //dismiss(animated: true, completion: nil)
                DispatchQueue.main.async {
                    hideIndicator(sender: nil)
                }
                return
            }
            // save to local and get URL
            if self.photoType == 1 {
                let imgName = UUID().uuidString
                let documentDirectory = NSTemporaryDirectory()
                let localPath = documentDirectory.appending(imgName)

                let data = image.jpegData(compressionQuality: 0.3)! as NSData
                data.write(toFile: localPath, atomically: true)
                avatarUrl = URL.init(fileURLWithPath: localPath)
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
                            webAPI.updateUserInfo(uid: self.id, userType: -1, bucketName: "perfectself-avatar-bucket", avatarKey: "\(self.id)/\(avatarUrl!.lastPathComponent)", username: "", email: "", password: "", firstName: "", lastName: "", dateOfBirth: "", gender: -1, currentAddress: "", permanentAddress: "", city: "", nationality: "", phoneNumber: "", isLogin: true, fcmDeviceToken: "", deviceKind: -1) { data, response, error in
                                if error == nil {
                                    // successfully update db
                                    //update local
                                    // Retrieve the saved data from UserDefaults
                                    DispatchQueue.main.async {
                                        if var userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
                                            // Use the saved data
                                            userInfo["avatarBucketName"] = "perfectself-avatar-bucket"
                                            userInfo["avatarKey"] = "\(self.id)/\(avatarUrl!.lastPathComponent)"
                                            UserDefaults.standard.removeObject(forKey: "USER")
                                            UserDefaults.standard.set(userInfo, forKey: "USER")
                                            
                                        } else {
                                            // No data was saved
                                            print("No data was saved.")
                                        }
                                    }
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
