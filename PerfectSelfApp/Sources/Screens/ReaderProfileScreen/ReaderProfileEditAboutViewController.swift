//
//  ReaderProfileEditAboutViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

//protocol DataDelegate: AnyObject {
//    func dataChanged(data: String)
//}

class ReaderProfileEditAboutViewController: UIViewController {
//    weak var delegate: DataDelegate?

    @IBOutlet weak var text_about: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SaveChanges(_ sender: UIButton) {
        // call API for about update
//        showIndicator(sender: nil, viewController: self)
//        let uid = UserDefaults.standard.string(forKey: "USER_ID")!
//        webAPI.editReaderProfile(readeruid: uid, title: nil, about: text_about.text, hourlyprice: nil, skills: nil) { data, response, error in
//            
//        }
//        
//
//        // Save the data
//        let newData = text_about.text!
//        
//        // Call the delegate method to notify the previous view controller
//        delegate?.dataChanged(data: newData)
//        
        // Pop the current view controller off the navigation stack
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
