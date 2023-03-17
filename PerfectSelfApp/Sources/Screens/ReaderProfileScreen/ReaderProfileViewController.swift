//
//  ReaderProfileViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ReaderProfileViewController: UIViewController {

    var isChangingMode = false
    
    @IBOutlet weak var btn_edit_userinfo: UIButton!
    @IBOutlet weak var btn_edit_rate: UIButton!
    @IBOutlet weak var btn_edit_about: UIButton!
    @IBOutlet weak var btn_edit_skills: UIButton!
    @IBOutlet weak var btn_edit_availability: UIButton!
    
    @IBOutlet weak var view_viewall_availability: UIStackView!
    @IBOutlet weak var view_viewall_skills: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btn_edit_userinfo.isHidden = true;
        btn_edit_rate.isHidden = true;
        btn_edit_about.isHidden = true;
        btn_edit_skills.isHidden = true;
        btn_edit_availability.isHidden = true;
    }

    @IBAction func EditUserInfo(_ sender: UIButton) {
        let controller = ReaderProfileEditPersonalInfoViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditRate(_ sender: UIButton) {
        let controller = ReaderProfileEditPersonalInfoViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditAbout(_ sender: UIButton) {
        let controller = ReaderProfileEditAboutViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditSkills(_ sender: UIButton) {
        let controller = ReaderProfileEditSkillViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditAvailability(_ sender: UIButton) {
        let controller = ReaderProfileEditAvailabilityViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditProfile(_ sender: UIButton) {

        if isChangingMode {
            sender.isEnabled = false
//            sender.setTitle("Edit Profile", for: UIButton.State.normal)
          
            let myNormalAttributedTitle = NSAttributedString(string: "Edit Profile", attributes: [NSAttributedString.Key.font : UIFont(name: "Arial", size: 10.0)!])
            sender.setAttributedTitle(myNormalAttributedTitle, for: .normal)
            sender.isEnabled = true;
            isChangingMode = false;
            view_viewall_skills.isHidden = false;
            view_viewall_availability.isHidden = false;
            btn_edit_userinfo.isHidden = true;
            btn_edit_rate.isHidden = true;
            btn_edit_about.isHidden = true;
            btn_edit_skills.isHidden = true;
            btn_edit_availability.isHidden = true;
        }
        else {
            sender.isEnabled = false;
//            sender.setTitle("Save Changes", for: UIButton.State.normal)
            let myNormalAttributedTitle = NSAttributedString(string: "Save Changes", attributes: [NSAttributedString.Key.font : UIFont(name: "Arial", size: 10.0)!])
            sender.setAttributedTitle(myNormalAttributedTitle, for: .normal)
            sender.isEnabled = true;
            isChangingMode = true;
            view_viewall_skills.isHidden = true;
            view_viewall_availability.isHidden = true;
            btn_edit_userinfo.isHidden = false;
            btn_edit_rate.isHidden = false;
            btn_edit_about.isHidden = false;
            btn_edit_skills.isHidden = false;
            btn_edit_availability.isHidden = false;
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
