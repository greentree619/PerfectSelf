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

        webAPI.editReaderProfileTitle(uid: uid, title: readerTitle.text!) { data, response, error in
            
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
                webAPI.editReaderProfileName(uid: self.uid, username: self.readerName.text!) { data, response, error in
                    DispatchQueue.main.async {
                        hideIndicator(sender: nil);
                    }
                   
                    guard let _ = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    DispatchQueue.main.async {
                        
                        self.dismiss(animated: false)
                    }
                }
            }
        }
    }
    @IBAction func GoBack(_ sender: UIButton) {
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
