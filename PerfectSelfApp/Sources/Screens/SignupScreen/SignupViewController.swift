//
//  SignupViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    let show = UIImage(named: "icons8-eye-20")! as UIImage
    let hide = UIImage(named : "icons8-hide-20")! as UIImage
    let showconfirm = UIImage(named: "icons8-eye-20")! as UIImage
    let hideconfirm = UIImage(named : "icons8-hide-20")! as UIImage
    
    @IBOutlet weak var text_confirmpassword: UITextField!
    @IBOutlet weak var text_password: UITextField!
    @IBOutlet weak var btn_showpassword: UIButton!
    
    @IBOutlet weak var btn_showconfirmpassword: UIButton!
    
    var isShowPass = false;
    var isShowPassConfirm = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func ChangeShowPassword(_ sender: UIButton) {
        isShowPass = !isShowPass;
        
        if isShowPass {
            text_password.isSecureTextEntry = false;
            sender.setImage(show, for: UIControl.State.normal);
        }
        else {
            text_password.isSecureTextEntry = true;
            sender.setImage(hide, for: UIControl.State.normal);
        }
    }
    
    @IBAction func ChangeShowCornfirmPass(_ sender: UIButton) {
        isShowPassConfirm = !isShowPassConfirm;
        
        if isShowPassConfirm {
            text_confirmpassword.isSecureTextEntry = false;
            sender.setImage(show, for: UIControl.State.normal);
        }
        else {
            text_confirmpassword.isSecureTextEntry = true;
            sender.setImage(hide, for: UIControl.State.normal);
        }
        
    }
    @IBAction func SignUp(_ sender: UIButton) {
        let controller = SignupDetailViewController();
        self.navigationController?.pushViewController(controller, animated: true);
        
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
