//
//  ReaderProfileEditPersonalInfoViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ReaderProfileEditPersonalInfoViewController: UIViewController {
    var username = ""
    var usertitle = ""
    var uid = ""
    @IBOutlet weak var readerTitle: UITextField!
    @IBOutlet weak var readerName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        readerName.text = username
        readerTitle.text = usertitle
    }


    @IBAction func SaveChange(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(readerTitle.text!.isEmpty){
            inputCheck += "- Please input title.\n"
            if(focusTextField == nil){
                focusTextField = readerTitle
            }
        }
 
        if(readerName.text!.isEmpty){
            inputCheck += "- Please input name.\n"
            if(focusTextField == nil){
                focusTextField = readerName
            }
        }
        
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        // call API for about update
        showIndicator(sender: nil, viewController: self)

        webAPI.editReaderProfile(uid: uid, title: readerTitle.text!, hourlyPrice: -1, about: "", introBucketName: "", introVideokey: "", skills: "", auditionType: -1, isExplicitRead: nil) { data, response, error in
            
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    hideIndicator(sender: nil);
                }
                return
            }
//            print("333")
//            if let httpResponse = response as? HTTPURLResponse {
//                print("statusCode: \(httpResponse.statusCode)")
//            }
            DispatchQueue.main.async {
                if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
                    // Use the saved data
                    print(userInfo)
                    webAPI.updateUserInfo(uid: self.uid, userType: -1, bucketName: userInfo["avatarBucketName"] as! String, avatarKey: userInfo["avatarKey"] as! String, username: self.readerName.text!, email: "", password: "", firstName: "", lastName: "", dateOfBirth: "", gender: -1, currentAddress: "", permanentAddress: "", city: "", nationality: "", phoneNumber: "", isLogin: true, fcmDeviceToken: "", deviceKind: -1) { data, response, error in
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil);
                        }
                       
                        guard let _ = data, error == nil else {
                            print(error?.localizedDescription ?? "No data")
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
