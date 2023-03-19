//
//  ActorBuildProfile1ViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/18/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBuildProfile1ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func Later(_ sender: UIButton) {
        let controller = ActorTabBarController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func BuildProfile(_ sender: UIButton) {
        let controller = ActorBuildProfile2ViewController()
        self.navigationController?.pushViewController(controller, animated: true)
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
