//
//  ActorSetPaymentViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/15/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorSetPaymentViewController: UIViewController {

    var readerUid: String = ""
    var bookingTime: String = ""
    var bookingDate: String = ""
    var script: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    @IBAction func DoCheckout(_ sender: UIButton) {
        let controller = ActorBookConfirmationViewController();

        controller.readerUid = readerUid
        controller.bookingTime = bookingTime
        controller.bookingDate = bookingDate
        controller.script = script
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
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
