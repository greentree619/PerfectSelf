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
    
    @IBOutlet weak var btn_edit_profile: UIButton!
    
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

    @IBAction func EditProfile(_ sender: UIButton) {

        if isChangingMode {
            btn_edit_profile.setTitle("Edit Profile", for: .normal)
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
            btn_edit_profile.setTitle("Save Changes", for: .normal)
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
