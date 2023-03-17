//
//  ActorChatViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorChatViewController: UIViewController {

    @IBOutlet weak var modal_confirm_call: UIStackView!
    @IBOutlet weak var noMessage: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        modal_confirm_call.isHidden = true;
        noMessage.isHidden = false;
    }

    @IBAction func CancelCall(_ sender: UIButton) {
        modal_confirm_call.isHidden = true;
    }
    @IBAction func ConfirmCall(_ sender: UIButton) {
        modal_confirm_call.isHidden = true;
    }
    @IBAction func DoVoiceCall(_ sender: UIButton) {
        modal_confirm_call.isHidden = false;
    }
    
    @IBAction func DoVideoCall(_ sender: UIButton) {
        modal_confirm_call.isHidden = false;
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
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
