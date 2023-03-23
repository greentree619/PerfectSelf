//
//  ActorHomeViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import FSCalendar

struct ReaderProfile: Codable {
    let title: String
    let readerUid: String
    let hourlyPrice: Int
    let voiceType: Int
    let others: Int
    let about: String
    let skills: String
    let id: Int
    let isDeleted: Bool
    let createdTime: String
    let updatedTime: String
    let deletedTime: String
}

class ActorHomeViewController: UIViewController {
    
    @IBOutlet weak var filtermodal: UIStackView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let r = UIImage(named: "reader");
    let backgroundView = UIView()
    
    var isSponsored = true
    var isAvailableSoon = false
    var isTopRated = false
    var isOnline = true
    var is15TimeSlot = true
    var is30TimeSlot = false
    var is30PlusTimeSlot = false
    var isStandBy = false
    var isCommercialRead = true
    var isShortRead = false
    var isExtendedRead = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        filtermodal.alpha = 0;
        let containerView = UIView()
        let indicatorView = UIView()
        indicatorView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.center = indicatorView.center
        indicatorView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        scrollView.addSubview(indicatorView)
        scrollView.contentSize = indicatorView.frame.size
        
        // call API to fetch reader list
        
        webAPI.getAllReaders() { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            
            do {
                let items = try JSONDecoder().decode([ReaderProfile].self, from: data)
                print(items)

                DispatchQueue.main.async {
//                    Toast.show(message: "Reader list fetched!", controller: self)
                    activityIndicatorView.stopAnimating()
                    indicatorView.removeFromSuperview()
                    activityIndicatorView.stopAnimating()
                    
                    for (i, reader) in items.enumerated() {
                        let item = ReaderView(frame: CGRect(x: 0, y:120*i, width:Int(self.scrollView.frame.width), height:100), name: "Reader Name", hourlyPrice: reader.hourlyPrice)
                        item.tapCallback = {
                            //                let controller = ActorReaderDetailViewController();
                            //
                            //                self.navigationController?.pushViewController(controller, animated: true)
                            print("tapped reader")

                        }

                        item.layer.masksToBounds = false;
                        item.layer.shadowOpacity = 0.5;
                        item.layer.shadowRadius = 5;
                        item.layer.shadowOffset = CGSize(width: 2, height: 5);
                        item.layer.cornerRadius = 10

                        containerView.addSubview(item)

                    }

                    containerView.frame = CGRect(x: 0, y: 0, width: Int(self.scrollView.frame.width), height: items.count*120+50)
                    self.scrollView.addSubview(containerView)
                    self.scrollView.contentSize = containerView.frame.size

                }

            } catch {
                print(error)
                DispatchQueue.main.async {
                    //hideIndicator(sender: sender)
                    indicatorView.removeFromSuperview()
                    Toast.show(message: "Fetching reader list failed! please try again.", controller: self)
                }
            }
            
//            if let _ = responseJSON as? [String: Any] {
//
//                DispatchQueue.main.async {
////                    hideIndicator(sender: sender)
//                    containerView.removeFromSuperview()
//                    Toast.show(message: "Reader list fetched!", controller: self)
//                }
//            }
//            else
//            {
//                DispatchQueue.main.async {
////                    hideIndicator(sender: sender)
//                    Toast.show(message: "Fetching reader list failed! please try again.", controller: self)
//                }
//            }
        }
//
//
//        let num = 0...10
//        for i in num {
//
//            let item = Item(frame: CGRect(x: 0, y:120*i, width:Int(scrollView.frame.width), height:100), labelText: "Booking History")
//            item.tapCallback = {
////                let controller = ActorReaderDetailViewController();
////
////                self.navigationController?.pushViewController(controller, animated: true)
//            }
//
//            item.layer.masksToBounds = false;
//            item.layer.shadowOpacity = 0.5;
//            item.layer.shadowRadius = 5;
//            item.layer.shadowOffset = CGSize(width: 2, height: 5);
//            item.layer.cornerRadius = 10
//
//            containerView.addSubview(item)
//        }
//

//        let containerView = UIView()
//        let num = 0...5
//        for i in num {
//            let iv = UIImageView()
//            iv.image = r;
//            iv.layer.masksToBounds = false;
//            iv.layer.shadowOpacity = 0.3;
//            iv.layer.shadowRadius = 3;
//            iv.layer.shadowOffset = CGSize(width: 2, height: 3);
//            iv.frame = CGRect(x: 0, y:120*i, width:Int(scrollView.frame.width), height:100)
//            containerView.addSubview(iv)
//        }
//
//        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 750)
//
//        scrollView.addSubview(containerView)
//        scrollView.contentSize = containerView.frame.size
    }
    
    @IBAction func ShowFilterModal(_ sender: UIButton) {
        UIView.animate(withDuration:0.3) {
            self.filtermodal.alpha = 1;
        }
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundView, belowSubview: filtermodal)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCallback))
        backgroundView.addGestureRecognizer(tap)
        backgroundView.isUserInteractionEnabled = true
        
    }
    @objc func tapCallback() {
        backgroundView.removeFromSuperview()
        self.filtermodal.alpha = 0;
    }
    @IBAction func ApplyFilter(_ sender: UIButton) {
        backgroundView.removeFromSuperview()
        self.filtermodal.alpha = 0;
        
        let controller = ActorFindReaderViewController()
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func SelectMale(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    @IBAction func SelectFemale(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func CloseFilterModal(_ sender: UIButton) {
        backgroundView.removeFromSuperview()
        self.filtermodal.alpha = 0;
    }
    
    
    //
    //    @IBAction func ShowCalendar(_ sender: UIButton) {
    //        let _ = BDatePicker.show(on: self, handledBy: HandleDateDidChange)
    //
    //        func HandleDateDidChange(to newDate: Date?)
    //         {
    //             guard let date = newDate else
    //             {
    ////               dateLabel.text = "nil"
    //                 print("nil");
    //                 return
    //             }
    //             print(date.description);
    //            //dateLabel.text = date.description
    //         }
    ////        CalendarViewController.present(
    ////                    initialView: self,
    ////                    delegate: self)
    //    }
    
    @IBAction func SelectSponsored(_ sender: UIButton) {
        isSponsored = !isSponsored
        
        if isSponsored {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xE5E5E5)
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
            sender.backgroundColor = UIColor(rgb: 0xE5E5E5)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        }
    }
    @IBAction func SelectTopRated(_ sender: UIButton) {
        isTopRated = !isTopRated
        
        if isTopRated {
            sender.backgroundColor = UIColor(rgb: 0x4865FF)
            sender.setTitleColor(.white, for: .normal)
            
        }
        else {
            sender.backgroundColor = UIColor(rgb: 0xE5E5E5)
            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        }
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
    
    @IBAction func SelectAvailableSoon1(_ sender: UIButton) {
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
    
    @IBAction func GoMessageCenter(_ sender: UIButton) {
        let controller = ActorMessageCenterViewController()
        self.navigationController?.pushViewController(controller, animated: true)
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
