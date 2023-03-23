//
//  ActorBuildProfile3ViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/18/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import DropDown

class ActorBuildProfile3ViewController: UIViewController {

    var username:String = ""
    var gender:String = ""
    var agerange:String = ""
    var height:String = ""
    var weight: String = ""
    
    let dropDownForCountry = DropDown()
    let dropDownForState = DropDown()
    let dropDownForCity = DropDown()
    let dropDownForAgency = DropDown()
    let dropDownForVaccination = DropDown()
    
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
        
        // The view to which the drop down will appear on
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
    @IBAction func Later(_ sender: UIButton) {
        let controller = ActorTabBarController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func Done(_ sender: UIButton) {
        var inputCheck: String = ""
        var focusTextField: UITextField? = nil
        if(text_country.text!.isEmpty){
            inputCheck += "- Please select country .\n"
            if(focusTextField == nil){
                focusTextField = text_country
            }
        }
        if(text_state.text!.isEmpty){
            inputCheck += "- Please select state .\n"
            if(focusTextField == nil){
                focusTextField = text_state
            }
        }
        if(text_city.text!.isEmpty){
            inputCheck += "- Please select city .\n"
            if(focusTextField == nil){
                focusTextField = text_city
            }
        }
        if(text_agency.text!.isEmpty){
            inputCheck += "- Please select agency .\n"
            if(focusTextField == nil){
                focusTextField = text_agency
            }
        }
        if(text_vaccination.text!.isEmpty){
            inputCheck += "- Please select vaccination .\n"
            if(focusTextField == nil){
                focusTextField = text_vaccination
            }
        }
        if(!inputCheck.isEmpty){
            showAlert(viewController: self, title: "Confirm", message: inputCheck) { UIAlertAction in
                focusTextField!.becomeFirstResponder()
            }
            return
        }
        showIndicator(sender: sender, viewController: self)
        let uid = UserDefaults.standard.string(forKey: "USER_ID")
        webAPI.createActorProfile(actoruid: uid!, ageRange: agerange, height: height, weight: weight, country: text_country.text != nil ? text_country.text!: "", state: text_state.text != nil ? text_state.text! : "", city: text_city.text != nil ? text_city.text! : "", agency: text_agency.text != nil ? text_agency.text! : "", vaccination: text_vaccination.text != nil ? text_vaccination.text! : "") { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])

            if let _ = responseJSON as? [String: Any] {
                
                DispatchQueue.main.async {
                    hideIndicator(sender: sender)
                    let controller = ActorTabBarController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
            else
            {
                DispatchQueue.main.async {
                    hideIndicator(sender: sender)
                    Toast.show(message: "Profile update failed! please try again.", controller: self)
                    print("error3")
                }
            }
        }

    }
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true);
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
