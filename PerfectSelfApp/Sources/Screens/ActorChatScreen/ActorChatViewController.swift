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
    let backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        modal_confirm_call.isHidden = true;
        noMessage.isHidden = false;
    }

    @IBAction func CancelCall(_ sender: UIButton) {
        backgroundView.removeFromSuperview()
        modal_confirm_call.isHidden = true;
    }
    @IBAction func ConfirmCall(_ sender: UIButton) {
        backgroundView.removeFromSuperview()
        modal_confirm_call.isHidden = true;
    }
    @IBAction func DoVoiceCall(_ sender: UIButton) {
        modal_confirm_call.isHidden = false;
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundView, belowSubview: modal_confirm_call)
 
    }
    
    @IBAction func DoVideoCall(_ sender: UIButton) {
        modal_confirm_call.isHidden = false;
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundView, belowSubview: modal_confirm_call)
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
