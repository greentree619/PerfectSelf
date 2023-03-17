//
//  ReaderProfileEditAvailabilityViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import BDatePicker

class ReaderProfileEditAvailabilityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    @IBAction func ShowCalendar(_ sender: Any) {
        let _ = BDatePicker.show(on: self, handledBy: HandleDateDidChange)

        func HandleDateDidChange(to newDate: Date?)
         {
             guard let date = newDate else
             {
//               dateLabel.text = "nil"
                 print("nil");
                 return
             }
             print(date.description);
            //dateLabel.text = date.description
         }
    }
    
    @IBAction func SelectFromTime(_ sender: UIButton) {
    }
    
    @IBAction func SelectToTime(_ sender: UIButton) {
    }
    @IBAction func SaveChanges(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
