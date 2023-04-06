//
//  ActorProfileChangePasswordViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/19/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorProfileChangePasswordViewController: UIViewController {

    @IBOutlet weak var text_oldpass: UITextField!
    @IBOutlet weak var text_newpass: UITextField!
    @IBOutlet weak var text_confirmpass: UITextField!
    let show = UIImage(named: "icons8-eye-20")! as UIImage
    let hide = UIImage(named : "icons8-hide-20")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SaveNewPassword(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.dismiss(animated: false)
    }
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.dismiss(animated: false)
    }
    
    @IBAction func ShowOldPassword(_ sender: UIButton) {
        text_oldpass.isSecureTextEntry = !text_oldpass.isSecureTextEntry
        
        if text_oldpass.isSecureTextEntry {
            sender.setImage(hide, for: .normal)
        }
        else {
            sender.setImage(show, for: .normal)
        }
    }
    
    @IBAction func ShowNewPassword(_ sender: UIButton) {
        text_newpass.isSecureTextEntry = !text_newpass.isSecureTextEntry
        
        if text_newpass.isSecureTextEntry {
            sender.setImage(hide, for: .normal)
        }
        else {
            sender.setImage(show, for: .normal)
        }
    }

    @IBAction func ShowConfirmPassword(_ sender: UIButton) {
        text_confirmpass.isSecureTextEntry = !text_confirmpass.isSecureTextEntry
        
        if text_confirmpass.isSecureTextEntry {
            sender.setImage(hide, for: .normal)
        }
        else {
            sender.setImage(show, for: .normal)
        }
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
