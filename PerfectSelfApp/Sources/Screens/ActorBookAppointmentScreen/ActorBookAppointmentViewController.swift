//
//  ActorBookAppointmentViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/21/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBookAppointmentViewController: UIViewController {

    var isSelected9AM = false
    var isSelected10AM = false
    var isSelected11AM = false
    var isSelected2PM = false
    var isSelected3PM = false
    var isSelected4PM = false
    
    @IBOutlet weak var btn_9am: UIButton!
    @IBOutlet weak var btn_10am: UIButton!
    @IBOutlet weak var btn_11am: UIButton!
    @IBOutlet weak var btn_2pm: UIButton!
    @IBOutlet weak var btn_3pm: UIButton!
    @IBOutlet weak var btn_4pm: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }


    @IBAction func ContinueToUploadScript(_ sender: UIButton) {
        let controller = ActorBookUploadScriptiewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func Select9Time(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        
        isSelected9AM = !isSelected9AM

        if isSelected9AM {
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            
//            isSelected9AM = false
            isSelected10AM = false
            isSelected11AM = false
            isSelected2PM = false
            isSelected3PM = false
            isSelected4PM = false
//            btn_9am.backgroundColor = .white
//            btn_9am.setTitleColor(.black, for: .normal)
            btn_10am.backgroundColor = .white
            btn_10am.setTitleColor(.black, for: .normal)
            btn_11am.backgroundColor = .white
            btn_11am.setTitleColor(.black, for: .normal)
            btn_2pm.backgroundColor = .white
            btn_2pm.setTitleColor(.black, for: .normal)
            btn_3pm.backgroundColor = .white
            btn_3pm.setTitleColor(.black, for: .normal)
            btn_4pm.backgroundColor = .white
            btn_4pm.setTitleColor(.black, for: .normal)
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    @IBAction func Select10Time(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        isSelected10AM = !isSelected10AM

        if isSelected10AM {
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            
            isSelected9AM = false
//            isSelected10AM = false
            isSelected11AM = false
            isSelected2PM = false
            isSelected3PM = false
            isSelected4PM = false
            btn_9am.backgroundColor = .white
            btn_9am.setTitleColor(.black, for: .normal)
//            btn_10am.backgroundColor = .white
//            btn_10am.setTitleColor(.black, for: .normal)
            btn_11am.backgroundColor = .white
            btn_11am.setTitleColor(.black, for: .normal)
            btn_2pm.backgroundColor = .white
            btn_2pm.setTitleColor(.black, for: .normal)
            btn_3pm.backgroundColor = .white
            btn_3pm.setTitleColor(.black, for: .normal)
            btn_4pm.backgroundColor = .white
            btn_4pm.setTitleColor(.black, for: .normal)
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    @IBAction func Select11Time(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        isSelected11AM = !isSelected11AM

        if isSelected11AM {
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            
            isSelected9AM = false
            isSelected10AM = false
//            isSelected11AM = false
            isSelected2PM = false
            isSelected3PM = false
            isSelected4PM = false
            btn_9am.backgroundColor = .white
            btn_9am.setTitleColor(.black, for: .normal)
            btn_10am.backgroundColor = .white
            btn_10am.setTitleColor(.black, for: .normal)
//            btn_11am.backgroundColor = .white
//            btn_11am.setTitleColor(.black, for: .normal)
            btn_2pm.backgroundColor = .white
            btn_2pm.setTitleColor(.black, for: .normal)
            btn_3pm.backgroundColor = .white
            btn_3pm.setTitleColor(.black, for: .normal)
            btn_4pm.backgroundColor = .white
            btn_4pm.setTitleColor(.black, for: .normal)
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    @IBAction func Select2Time(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        isSelected2PM = !isSelected2PM

        if isSelected2PM {
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            
            isSelected9AM = false
            isSelected10AM = false
            isSelected11AM = false
//            isSelected2PM = false
            isSelected3PM = false
            isSelected4PM = false
            btn_9am.backgroundColor = .white
            btn_9am.setTitleColor(.black, for: .normal)
            btn_10am.backgroundColor = .white
            btn_10am.setTitleColor(.black, for: .normal)
            btn_11am.backgroundColor = .white
            btn_11am.setTitleColor(.black, for: .normal)
//            btn_2pm.backgroundColor = .white
//            btn_2pm.setTitleColor(.black, for: .normal)
            btn_3pm.backgroundColor = .white
            btn_3pm.setTitleColor(.black, for: .normal)
            btn_4pm.backgroundColor = .white
            btn_4pm.setTitleColor(.black, for: .normal)
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    @IBAction func Select3Time(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        isSelected3PM = !isSelected3PM

        if isSelected3PM {
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            
            isSelected9AM = false
            isSelected10AM = false
            isSelected11AM = false
            isSelected2PM = false
//            isSelected3PM = false
            isSelected4PM = false
            btn_9am.backgroundColor = .white
            btn_9am.setTitleColor(.black, for: .normal)
            btn_10am.backgroundColor = .white
            btn_10am.setTitleColor(.black, for: .normal)
            btn_11am.backgroundColor = .white
            btn_11am.setTitleColor(.black, for: .normal)
            btn_2pm.backgroundColor = .white
            btn_2pm.setTitleColor(.black, for: .normal)
//            btn_3pm.backgroundColor = .white
//            btn_3pm.setTitleColor(.black, for: .normal)
            btn_4pm.backgroundColor = .white
            btn_4pm.setTitleColor(.black, for: .normal)
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    @IBAction func Select4Time(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        isSelected4PM = !isSelected4PM

        if isSelected4PM {
            sender.backgroundColor = .black
            sender.setTitleColor(.white, for: .normal)
            
            isSelected9AM = false
            isSelected10AM = false
            isSelected11AM = false
            isSelected2PM = false
            isSelected3PM = false
//            isSelected4PM = false
            btn_9am.backgroundColor = .white
            btn_9am.setTitleColor(.black, for: .normal)
            btn_10am.backgroundColor = .white
            btn_10am.setTitleColor(.black, for: .normal)
            btn_11am.backgroundColor = .white
            btn_11am.setTitleColor(.black, for: .normal)
            btn_2pm.backgroundColor = .white
            btn_2pm.setTitleColor(.black, for: .normal)
            btn_3pm.backgroundColor = .white
            btn_3pm.setTitleColor(.black, for: .normal)
//            btn_4pm.backgroundColor = .white
//            btn_4pm.setTitleColor(.black, for: .normal)
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(.black, for: .normal)
        }
    }
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
