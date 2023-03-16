//
//  ActorReaderDetailViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorReaderDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func BookAppointment(_ sender: UIButton) {
        let controller = ActorBookAppointmentViewController();
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func DoChat(_ sender: UIButton) {
        let controller = ActorChatViewController();
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func GoBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        print("ok")
    }
    
    @IBAction func EditProfile(_ sender: UIButton) {
        print("edit profile")
    }
    @IBAction func GetLink(_ sender: UIButton) {
        print("get link")
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
