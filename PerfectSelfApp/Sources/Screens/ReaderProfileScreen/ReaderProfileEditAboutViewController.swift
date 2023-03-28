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
    var uid = ""
    var about = ""
    @IBOutlet weak var text_about: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        text_about.text = about
    }

    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SaveChanges(_ sender: UIButton) {
        // call API for about update
        showIndicator(sender: nil, viewController: self)
//        let uid = UserDefaults.standard.string(forKey: "USER_ID")!
        webAPI.editReaderProfileAbout(uid: uid, about: text_about.text) { data, response, error in
            DispatchQueue.main.async {
                hideIndicator(sender: nil);
            }
            guard let _ = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
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
