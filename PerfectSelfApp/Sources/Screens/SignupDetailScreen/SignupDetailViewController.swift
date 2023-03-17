//
//  SignupDetailViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class SignupDetailViewController: UIViewController {

    
    @IBOutlet weak var btn_actor: UIButton!
    @IBOutlet weak var btn_reader: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SelectActorThpe(_ sender: UIButton) {
        sender.borderWidth = 3;
        btn_reader.borderWidth = 0;
    }
    
    @IBAction func SelectReaderType(_ sender: UIButton) {
        sender.borderWidth = 3;
        btn_actor.borderWidth = 0;
    }
    
    @IBAction func FinishSignUp(_ sender: UIButton) {
        let controller = ActorTabBarController();
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
