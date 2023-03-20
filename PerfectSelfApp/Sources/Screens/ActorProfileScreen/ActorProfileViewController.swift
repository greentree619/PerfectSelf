//
//  ActorProfileViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/19/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func EditProfile(_ sender: UIButton) {
        let controller = ActorProfileEditViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func ChangePassword(_ sender: UIButton) {
        let controller = ActorProfileChangePasswordViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func LogOut(_ sender: UIButton) {
        
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
