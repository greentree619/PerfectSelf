//
//  TimePauseViewController.swift
//  PerfectSelf
//
//  Created by user237181 on 5/4/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class TimePauseViewController: UIViewController , UIPickerViewDataSource, UIPickerViewDelegate {

    var isAdding: Bool!
    @IBOutlet weak var timeMenu: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        timeMenu.dataSource = self
        timeMenu.delegate = self
        timeMenu.selectRow(10, inComponent: 0, animated: true)
    }
    
    @IBAction func backDidTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Return the number of components (columns) in the picker view.
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Return the number of rows in the given component.
        return 20
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Return the title for the given row and component.
        return (isAdding ? "+":"-") + " \(row) sec"
    }
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        // Return a custom view for the given row and component.
//        return "ok"
//    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Respond to the user selecting a row in the picker view.
        print("ok", row)
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
