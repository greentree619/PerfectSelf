//
//  ActorProfileEditViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/19/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import DropDown

class ActorProfileEditViewController: UIViewController {

    let dropDownForGender = DropDown()
    let dropDownForAgeRange = DropDown()
    let dropDownForCountry = DropDown()
    let dropDownForState = DropDown()
    let dropDownForCity = DropDown()
    let dropDownForAgency = DropDown()
    let dropDownForVaccination = DropDown()
    
    @IBOutlet weak var genderview: UIStackView!
    @IBOutlet weak var text_gender: UITextField!
    
    @IBOutlet weak var ageview: UIStackView!
    @IBOutlet weak var text_age: UITextField!
    
    @IBOutlet weak var text_country: UITextField!
    @IBOutlet weak var countryview: UIStackView!
    
    @IBOutlet weak var text_state: UITextField!
    @IBOutlet weak var stateview: UIStackView!
    
    @IBOutlet weak var text_city: UITextField!
    @IBOutlet weak var cityview: UIStackView!
    
    @IBOutlet weak var agencyview: UIStackView!
    @IBOutlet weak var text_agency: UITextField!
    
    @IBOutlet weak var vaccinationview: UIStackView!
    @IBOutlet weak var text_vaccination: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set dropdown
        dropDownForGender.anchorView = genderview // UIView or UIBarButtonItem
        dropDownForAgeRange.anchorView = ageview
        // The list of items to display. Can be changed dynamically
        dropDownForGender.dataSource = ["Select...", "Male", "Female", "Decline to self-identity"]
        dropDownForAgeRange.dataSource = ["Select...", "10-20", "21-30", "31-40", "41-50", "over 50"]
        // Action triggered on selection
        dropDownForGender.selectionAction = { [unowned self] (index: Int, item: String) in
            text_gender.text = item
          
        }
        dropDownForAgeRange.selectionAction = { [unowned self] (index: Int, item: String) in
            text_age.text = item
          
        }
        // Top of drop down will be below the anchorView
        dropDownForGender.bottomOffset = CGPoint(x: 0, y:(dropDownForGender.anchorView?.plainView.bounds.height)!)
        dropDownForAgeRange.bottomOffset = CGPoint(x: 0, y:(dropDownForAgeRange.anchorView?.plainView.bounds.height)!)
        
        dropDownForGender.dismissMode = .onTap
        dropDownForAgeRange.dismissMode = .onTap
        
        dropDownForCountry.anchorView = countryview
        dropDownForCountry.dataSource = ["Not listed", "Country", "Country", "Country"]
        dropDownForCountry.selectionAction = { [unowned self] (index: Int, item: String) in
            text_country.text = item
          
        }
        dropDownForCountry.bottomOffset = CGPoint(x: 0, y:(dropDownForCountry.anchorView?.plainView.bounds.height)!)
        dropDownForCountry.dismissMode = .onTap
        
        // State
        dropDownForState.anchorView = stateview
        dropDownForState.dataSource = ["Not listed", "State", "State", "State"]
        dropDownForState.selectionAction = { [unowned self] (index: Int, item: String) in
            text_state.text = item
          
        }
        dropDownForState.bottomOffset = CGPoint(x: 0, y:(dropDownForState.anchorView?.plainView.bounds.height)!)
        dropDownForState.dismissMode = .onTap
        
        // City
        dropDownForCity.anchorView = cityview
        dropDownForCity.dataSource = ["Not listed", "City", "City", "City"]
        dropDownForCity.selectionAction = { [unowned self] (index: Int, item: String) in
            text_city.text = item
          
        }
        dropDownForCity.bottomOffset = CGPoint(x: 0, y:(dropDownForCity.anchorView?.plainView.bounds.height)!)
        dropDownForCity.dismissMode = .onTap
        
        // Agency
        dropDownForAgency.anchorView = agencyview
        dropDownForAgency.dataSource = ["Not listed", "Agency", "Agency", "Agency"]
        dropDownForAgency.selectionAction = { [unowned self] (index: Int, item: String) in
            text_agency.text = item
          
        }
        dropDownForAgency.bottomOffset = CGPoint(x: 0, y:(dropDownForAgency.anchorView?.plainView.bounds.height)!)
        dropDownForAgency.dismissMode = .onTap
        
        // Vaccination
        dropDownForVaccination.anchorView = vaccinationview
        dropDownForVaccination.dataSource = ["Not listed", "Vaccination", "Vaccination", "Vaccination"]
        dropDownForVaccination.selectionAction = { [unowned self] (index: Int, item: String) in
            text_vaccination.text = item
          
        }
        dropDownForVaccination.bottomOffset = CGPoint(x: 0, y:(dropDownForVaccination.anchorView?.plainView.bounds.height)!)
        dropDownForVaccination.dismissMode = .onTap
        
        
        DropDown.startListeningToKeyboard()
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.link
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().cellHeight = 40
        DropDown.appearance().setupCornerRadius(5) // available since v2.3.6
        
        
    }

    @IBAction func SaveChanges(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.dismiss(animated: false)
    }
    @IBAction func ShowDropDownForAge(_ sender: UIButton) {
        dropDownForAgeRange.show()
    }
    @IBAction func ShowDropDownForGender(_ sender: UIButton) {
        dropDownForGender.show()
        
    }
    @IBAction func ShowCountryDropDown(_ sender: UIButton) {
        dropDownForCountry.show()
    }
    @IBAction func ShowStateDropDown(_ sender: UIButton) {
        dropDownForState.show()
    }
    @IBAction func ShowCityDropDown(_ sender: UIButton) {
        dropDownForCity.show()
    }
    @IBAction func ShowAgencyDropDown(_ sender: UIButton) {
        dropDownForAgency.show()
    }
    @IBAction func ShowVaccinationDropDown(_ sender: UIButton) {
        dropDownForVaccination.show()
    }
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
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
