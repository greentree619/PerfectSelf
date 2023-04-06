//
//  LoginViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var lbl_version: UILabel!
    @IBAction func login(_ sender: UIButton) {
        let controller = LoginDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func signup(_ sender: UIButton) {
        let controller = SignupViewController()

        self.navigationController?.pushViewController(controller, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
           let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String {
            lbl_version.text = "version \(version).\(build)"
            print("version \(version)====\(build)")
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
