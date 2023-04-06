//
//  ActorHomeViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import RangeSeekSlider

class ActorHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var readerList: UICollectionView!
    
    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var readerListFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var greetingLabel: UILabel!
    let backgroundView = UIView()
    
    var isSponsored = true
    var isAvailableSoon = false
    var isTopRated = false
    
    var items = [ReaderProfileCard]()
    let cellsPerRow = 1
  
    override func viewDidLoad() {
        super.viewDidLoad()
         
        let nib = UINib(nibName: "ReaderCollectionViewCell", bundle: nil)
        readerList.register(nib, forCellWithReuseIdentifier: "Reader Collection View Cell")
        readerList.dataSource = self
        readerList.delegate = self
        readerList.allowsSelection = true
        // Do any additional setup after loading the view.
        let name = UserDefaults.standard.string(forKey: "USER_NAME")
        greetingLabel.text = "Hi, " + (name ?? "")
        fetchReaderList()
    }
    func fetchReaderList() {
        spin.isHidden = false
        spin.startAnimating()
        // call API to fetch reader list
        webAPI.getAllReaders() { data, response, error in
            DispatchQueue.main.async {
                self.spin.stopAnimating()
                self.spin.isHidden = true
            }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
               
                let respItems = try JSONDecoder().decode([ReaderProfileCard].self, from: data)
                //print(items)
                DispatchQueue.main.async {
                    self.items.removeAll()
                    self.items.append(contentsOf: respItems)
//                    for (i, reader) in items.enumerated() {
//                    }
                    self.readerList.reloadData()
                }

            } catch {
                print(error)
                DispatchQueue.main.async {
                    Toast.show(message: "Fetching reader list failed! please try again.", controller: self)
                }
            }
        }
    }
    // MARK: - Reader List Delegate.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         // myData is the array of items
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        return CGSize(width: size, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reader Collection View Cell", for: indexPath) as! ReaderCollectionViewCell
        cell.readerName.text = self.items[indexPath.row].userName;
        cell.salary.text = "$" + String((self.items[indexPath.row].hourlyPrice ?? 0)/4)
        // return card
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSizeZero
        cell.layer.shadowRadius = 8
        cell.layer.shadowOpacity = 0.2
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt" + String(indexPath.row))
        let controller = ActorReaderDetailViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.uid = self.items[indexPath.row].uid

        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
    }
    
    @IBAction func ShowFilterModal(_ sender: UIButton) {
        let controller = FilterViewController()
        controller.modalPresentationStyle = .overFullScreen
        controller.parentUIViewController = self
        self.present(controller, animated: true)
        
    }
//    @objc func tapCallback() {
//        backgroundView.removeFromSuperview()
//        self.filtermodal.alpha = 0;
//    }
//    @IBAction func ApplyFilter(_ sender: UIButton) {
//        backgroundView.removeFromSuperview()
//        self.filtermodal.alpha = 0;
//
//        let controller = ActorFindReaderViewController()
//        self.navigationController?.pushViewController(controller, animated: false)
//
//    }
//    @IBAction func SelectMale(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//    }
//    @IBAction func SelectFemale(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//    }
//
//    @IBAction func CloseFilterModal(_ sender: UIButton) {
//        backgroundView.removeFromSuperview()
//        self.filtermodal.alpha = 0;
//    }
//
    
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
//
//    @IBAction func SelectOnlineNow(_ sender: UIButton) {
//        isOnline = !isOnline
//
//        if isOnline {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//        }
//    }
//
//    @IBAction func SelectAvailableSoon1(_ sender: UIButton) {
//        isAvailableSoon = !isAvailableSoon
//
//        if isAvailableSoon {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//        }
//    }
//
//    @IBAction func Select15TimeSlot(_ sender: UIButton) {
//        is15TimeSlot = !is15TimeSlot
//
//        if is15TimeSlot {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//        }
//    }
//
//    @IBAction func Select30TimeSlot(_ sender: UIButton) {
//        is30TimeSlot = !is30TimeSlot
//
//        if is30TimeSlot {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//        }
//    }
//
//    @IBAction func Select30OverTimeSlot(_ sender: UIButton) {
//        is30PlusTimeSlot = !is30PlusTimeSlot
//
//        if is30PlusTimeSlot {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//        }
//    }
//
//    @IBAction func SelectStandByTimeSlot(_ sender: UIButton) {
//        isStandBy = !isStandBy
//
//        if isStandBy {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//        }
//    }
//
//    @IBAction func SelectCommercialRead(_ sender: UIButton) {
//        isCommercialRead = !isCommercialRead
//
//        if isCommercialRead {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//            sender.tintColor = .white
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//            sender.tintColor = UIColor(rgb: 0x4865FF)
//        }
//    }
//
//    @IBAction func SelectShortRead(_ sender: UIButton) {
//        isShortRead = !isShortRead
//
//        if isShortRead {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//            sender.tintColor = .white
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//            sender.tintColor = UIColor(rgb: 0x4865FF)
//        }
//    }
//
//    @IBAction func SelectExtendedRead(_ sender: UIButton) {
//        isExtendedRead = !isExtendedRead
//
//        if isExtendedRead {
//            sender.backgroundColor = UIColor(rgb: 0x4865FF)
//            sender.setTitleColor(.white, for: .normal)
//            sender.tintColor = .white
//        }
//        else {
//            sender.backgroundColor = UIColor(rgb: 0xFFFFFF)
//            sender.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
//            sender.tintColor = UIColor(rgb: 0x4865FF)
//        }
//    }
    
    @IBAction func GoMessageCenter(_ sender: UIButton) {
        let controller = MessageCenterViewController()
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
