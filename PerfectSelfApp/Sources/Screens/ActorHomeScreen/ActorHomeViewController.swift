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

class ActorHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    @IBOutlet weak var filtermodal: UIStackView!
    
    @IBOutlet weak var readerList: UICollectionView!
    
    @IBOutlet weak var readerListFlow: UICollectionViewFlowLayout!
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    
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
    let cellsPerRow = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ReaderCollectionViewCell", bundle: nil)
        readerList.register(nib, forCellWithReuseIdentifier: "Reader Collection View Cell")
        readerList.dataSource = self
        readerList.delegate = self
        
        // Do any additional setup after loading the view.
        filtermodal.alpha = 0;
        
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
//                    //                    Toast.show(message: "Reader list fetched!", controller: self)
//                    //activityIndicatorView.stopAnimating()
//                    //indicatorView.removeFromSuperview()
//                    //activityIndicatorView.stopAnimating()
//
//                    //                    for (i, reader) in items.enumerated() {
//                    //
//                    //
//                    //                    }
//                }
//
//            } catch {
//                print(error)
//                DispatchQueue.main.async {
//                    //hideIndicator(sender: sender)
//                    Toast.show(message: "Fetching reader list failed! please try again.", controller: self)
//                }
//            }
//        }
    }
    
    // MARK: - Reader List Delegate.
    func collectionView(_ collectionView: UICollectionView,        numberOfItemsInSection section: Int) -> Int {
         // myData is the array of items
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        return CGSize(width: size, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reader Collection View Cell", for: indexPath) as! ReaderCollectionViewCell
        cell.readerName.text = self.items[indexPath.row];
        // return card
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt")
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
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
