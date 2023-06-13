//
//  FilterViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/31/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import RangeSeekSlider
protocol FilterDelegate {
    func setFilterParams(isAvailableSoon: Bool,isOnline: Bool,timeSlotType: Int,
                         isCommercialRead: Bool,isShortRead: Bool,isExtendedRead: Bool
                         ,isDateSelected: Bool,fromDate: Date,toDate: Date, minPrice: Float, maxPrice: Float,gender: [Int], isExplicitRead: Bool)
}

class FilterViewController: UIViewController, SelectDateDelegate {
    func didPassData(fromDate: Date, toDate: Date) {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yyyy"
        text_date_range.text = df.string(from: fromDate) + "-" + df.string(from: toDate)
        isDateSelected = true
        self.fromDate = fromDate
        self.toDate = toDate
    }
    var delegate: FilterDelegate?
    var originType = 0
    
    var isAvailableSoon = false
    var isOnline = true
    var timeSlotType = 0
    var isCommercialRead = true
    var isShortRead = false
    var isExtendedRead = false
    var isDateSelected = false
    var fromDate = Date()
    var toDate = Date()
    var isMaleSelected = false
    var isFemaleSelected = false
    var isExplicitRead = false
    var genderCheckAry: [UIButton] = [UIButton]()
    
    var parentUIViewController : UIViewController?
    
    @IBOutlet weak var maleGenderchk: UIButton!
    @IBOutlet weak var fmaleGenderChk: UIButton!
    @IBOutlet weak var nonBinGenderChk: UIButton!
    @IBOutlet weak var genderqueerGenderChk: UIButton!
    @IBOutlet weak var genderFluidGenChk: UIButton!
    @IBOutlet weak var transGenderChk: UIButton!
    @IBOutlet weak var agenderGenderChk: UIButton!
    @IBOutlet weak var bigGenderChk: UIButton!
    @IBOutlet weak var twoSpiritGenderChk: UIButton!
    @IBOutlet weak var androgynousGenderChk: UIButton!
    @IBOutlet weak var unkownGenderChk: UIButton!
    @IBOutlet weak var allGenderChk: UIButton!
    
    @IBOutlet weak var btn_standby: UIButton!
    @IBOutlet weak var btn_45min: UIButton!
    @IBOutlet weak var btn_30min: UIButton!
    @IBOutlet weak var btn_15min: UIButton!
    @IBOutlet weak var sliderView: UIStackView!
    @IBOutlet weak var text_date_range: UITextField!
    
    var rangeSlider : RangeSeekSlider = RangeSeekSlider(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        genderCheckAry.removeAll()
        genderCheckAry = [maleGenderchk, fmaleGenderChk, nonBinGenderChk, genderqueerGenderChk, genderFluidGenChk, transGenderChk, agenderGenderChk, bigGenderChk, twoSpiritGenderChk, androgynousGenderChk, unkownGenderChk]
        
        rangeSlider = RangeSeekSlider(frame: CGRect(x: 0, y: 0, width: sliderView.frame.width-35, height: sliderView.frame.height))
        sliderView.addSubview(rangeSlider)
        rangeSlider.minValue = 0
        rangeSlider.maxValue = 100
        rangeSlider.selectedMinValue = 0
        rangeSlider.selectedMaxValue = 100
        rangeSlider.step = 1
        
    }
    @IBAction func tapCallback(_ sender: UITapGestureRecognizer) {
          self.dismiss(animated: true);
      }

    @IBAction func tapSelectAvailableDate(_ sender: UITapGestureRecognizer) {
        let controller = DateSelectViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func ApplyFilter(_ sender: UIButton) {
        self.dismiss(animated: true) {
            if self.originType == 0 {
                let controller = ActorFindReaderViewController()
                
                controller.isAvailableSoon = self.isAvailableSoon
                controller.isOnline = self.isOnline
                controller.timeSlotType = self.timeSlotType
                controller.isDateSelected = self.isDateSelected
                controller.fromDate = self.fromDate
                controller.toDate = self.toDate
                controller.minPrice = Float(self.rangeSlider.selectedMinValue)
                controller.maxPrice = Float(self.rangeSlider.selectedMaxValue)
                controller.gender = self.getSelectedGenderAry()
                controller.isCommercialRead = self.isCommercialRead
                controller.isShortRead = self.isShortRead
                controller.isExtendedRead = self.isExtendedRead
                controller.isComfortableWithExplicitRead = self.isExplicitRead
                
                self.parentUIViewController?.navigationController?.pushViewController(controller, animated: true)
            }
            else {
                // call delegate
                let mg =  self.getSelectedGenderAry()
                self.delegate?.setFilterParams(isAvailableSoon: self.isAvailableSoon, isOnline: self.isOnline, timeSlotType: self.timeSlotType, isCommercialRead: self.isCommercialRead, isShortRead: self.isShortRead, isExtendedRead: self.isExplicitRead, isDateSelected: self.isDateSelected, fromDate: self.fromDate, toDate: self.toDate, minPrice: Float(self.rangeSlider.selectedMinValue), maxPrice: Float(self.rangeSlider.selectedMaxValue), gender: mg, isExplicitRead: self.isExplicitRead)
            }
        }
    }
    
    @IBAction func SelectMale(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isMaleSelected = !isMaleSelected
    }
    
    @IBAction func SelectFemale(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isFemaleSelected = !isFemaleSelected
    }
    
    @IBAction func nonBinaryDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func GenderqueerDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func genderfluidDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func transgenderDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func agenderDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func bigenderDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func twoSpiritDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func androgynousDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func unkownDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func allGenderDidTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        maleGenderchk.isSelected = sender.isSelected
        fmaleGenderChk.isSelected = sender.isSelected
        nonBinGenderChk.isSelected = sender.isSelected
        genderqueerGenderChk.isSelected = sender.isSelected
        genderFluidGenChk.isSelected = sender.isSelected
        transGenderChk.isSelected = sender.isSelected
        agenderGenderChk.isSelected = sender.isSelected
        bigGenderChk.isSelected = sender.isSelected
        twoSpiritGenderChk.isSelected = sender.isSelected
        androgynousGenderChk.isSelected = sender.isSelected
        unkownGenderChk.isSelected = sender.isSelected
        allGenderChk.isSelected = sender.isSelected
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
        timeSlotType = 0
        sender.backgroundColor = UIColor(rgb: 0x4865FF)
        sender.setTitleColor(.white, for: .normal)
        
        btn_30min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_30min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_45min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_45min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_standby.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_standby.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
    }
    
    @IBAction func Select30TimeSlot(_ sender: UIButton) {
        timeSlotType = 1
        sender.backgroundColor = UIColor(rgb: 0x4865FF)
        sender.setTitleColor(.white, for: .normal)
        
        btn_15min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_15min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_45min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_45min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_standby.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_standby.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
    }
    
    @IBAction func Select45OverTimeSlot(_ sender: UIButton) {
        timeSlotType = 2
        sender.backgroundColor = UIColor(rgb: 0x4865FF)
        sender.setTitleColor(.white, for: .normal)
        
        btn_15min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_15min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_30min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_30min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_standby.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_standby.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
    }
    
    @IBAction func SelectStandByTimeSlot(_ sender: UIButton) {
        timeSlotType = 3
        sender.backgroundColor = UIColor(rgb: 0x4865FF)
        sender.setTitleColor(.white, for: .normal)
        
        btn_15min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_15min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_30min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_30min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_45min.backgroundColor = UIColor(rgb: 0xFFFFFF)
        btn_45min.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
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
    
    @IBAction func SelectExplicitRead(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isExplicitRead = !isExplicitRead
    }
    
    func getSelectedGenderAry()->[Int]
    {
        var ret = [Int]()
        for (index, chk) in genderCheckAry.enumerated() {
            //print("\(index) is from \(chk.isSelected)")
            if( chk.isSelected ) {ret.append(index)}
        }
        return ret
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
