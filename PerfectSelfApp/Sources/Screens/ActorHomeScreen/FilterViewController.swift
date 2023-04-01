//
//  FilterViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/31/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import RangeSeekSlider

class FilterViewController: UIViewController {
    var isAvailableSoon = false
    var isOnline = true
    var is15TimeSlot = true
    var is30TimeSlot = false
    var is30PlusTimeSlot = false
    var isStandBy = false
    var isCommercialRead = true
    var isShortRead = false
    var isExtendedRead = false
    
    @IBOutlet weak var sliderView: UIStackView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let rangeSlider = RangeSeekSlider(frame: CGRect(x: 0, y: 0, width: sliderView.frame.width, height: sliderView.frame.height))
        sliderView.addSubview(rangeSlider)
        rangeSlider.minValue = 0
        rangeSlider.maxValue = 100
        rangeSlider.selectedMinValue = 10
        rangeSlider.selectedMaxValue = 30
        rangeSlider.step = 1
        
    }
    @IBAction func tapCallback(_ sender: UITapGestureRecognizer) {
          self.dismiss(animated: true);
      }

    @IBAction func ApplyFilter(_ sender: UIButton) {
       
//        let controller = ActorFindReaderViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
        self.dismiss(animated: true) {
            print("ok")
            let controller = ActorFindReaderViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @IBAction func SelectMale(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func SelectFemale(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func CloseFilterModal(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func SelectOnlineNow(_ sender: UIButton) {
        isOnline = !isOnline
        
        if isOnline {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        }
    }
    
    @IBAction func SelectAvailableSoon(_ sender: UIButton) {
        isAvailableSoon = !isAvailableSoon
        
        if isAvailableSoon {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        }
    }
    
    @IBAction func Select15TimeSlot(_ sender: UIButton) {
        is15TimeSlot = !is15TimeSlot
        
        if is15TimeSlot {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        }
    }
    
    @IBAction func Select30TimeSlot(_ sender: UIButton) {
        is30TimeSlot = !is30TimeSlot
        
        if is30TimeSlot {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        }
    }
    
    @IBAction func Select30OverTimeSlot(_ sender: UIButton) {
        is30PlusTimeSlot = !is30PlusTimeSlot
        
        if is30PlusTimeSlot {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        }
    }
    
    @IBAction func SelectStandByTimeSlot(_ sender: UIButton) {
        isStandBy = !isStandBy
        
        if isStandBy {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        }
    }
    
    @IBAction func SelectCommercialRead(_ sender: UIButton) {
        isCommercialRead = !isCommercialRead
        
        if isCommercialRead {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            sender.tintColor = .white
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
            sender.tintColor = UIColor(rgb: 0x4865FF)
        }
    }
    
    @IBAction func SelectShortRead(_ sender: UIButton) {
        isShortRead = !isShortRead
        
        if isShortRead {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            sender.tintColor = .white
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
            sender.tintColor = UIColor(rgb: 0x4865FF)
        }
    }
    
    @IBAction func SelectExtendedRead(_ sender: UIButton) {
        isExtendedRead = !isExtendedRead
        
        if isExtendedRead {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            sender.tintColor = .white
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
            sender.tintColor = UIColor(rgb: 0x4865FF)
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
