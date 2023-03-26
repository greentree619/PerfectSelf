//
//  ReaderProfileViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ReaderProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var isEditingMode = false
    
    @IBOutlet weak var btn_edit_userinfo: UIButton!
    @IBOutlet weak var btn_edit_highlight: UIButton!
    @IBOutlet weak var btn_edit_about: UIButton!
    @IBOutlet weak var btn_edit_skills: UIButton!
    @IBOutlet weak var btn_edit_availability: UIButton!
    
//    @IBOutlet weak var view_viewall_availability: UIStackView!
//    @IBOutlet weak var view_viewall_skills: UIStackView!
    
    @IBOutlet weak var view_review: UIStackView!
    @IBOutlet weak var view_videointro: UIStackView!
    @IBOutlet weak var view_overview: UIStackView!
    
    @IBOutlet weak var btn_overview: UIButton!
    @IBOutlet weak var btn_videointro: UIButton!
    @IBOutlet weak var btn_review: UIButton!
    
    @IBOutlet weak var line_overview: UIImageView!
    @IBOutlet weak var line_videointro: UIImageView!
    @IBOutlet weak var line_review: UIImageView!
    
    @IBOutlet weak var readerTitle: UILabel!
    @IBOutlet weak var readerAbout: UITextView!
    @IBOutlet weak var readerSkills: UILabel!
    @IBOutlet weak var hourlyPrice: UILabel!
    @IBOutlet weak var timeslotList: UICollectionView!
    var items = [Availability]()
//    ["1", "2", "3", "3", "2", "4"]
    let cellsPerRow = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TimeSlotCollectionViewCell", bundle: nil)
        timeslotList.register(nib, forCellWithReuseIdentifier: "Time Slot Collection View Cell")
        timeslotList.dataSource = self
        timeslotList.delegate = self
        timeslotList.allowsSelection = true
        // Do any additional setup after loading the view.
        line_videointro.isHidden = true
        line_review.isHidden = true
        view_videointro.isHidden = true
        view_review.isHidden = true
        btn_edit_userinfo.isHidden = true;
        btn_edit_highlight.isHidden = true;
        btn_edit_about.isHidden = true;
        btn_edit_skills.isHidden = true;
        btn_edit_availability.isHidden = true;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
        // call API for reader profile
        let uid = UserDefaults.standard.string(forKey: "USER_ID")!
        showIndicator(sender: nil, viewController: self)
        
        // FIXME
        webAPI.getReaderById(id: "1") { data, response, error in
//        webAPI.getReaderById(id:uid) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let item = try JSONDecoder().decode(ReaderProfileDetail.self, from: data)
                print(item)
                DispatchQueue.main.async {
                    self.readerTitle.text = item.title
                    self.readerAbout.text = item.about
                    self.hourlyPrice.text = "$\((item.hourlyPrice ?? 0)/4) / 15 mins"
                    self.readerSkills.text = item.skills
                    
                    //call API for available time slots
                    
                    webAPI.getAvailabilityById(id: uid) {data1, response1, error1 in
                        DispatchQueue.main.async {
                            hideIndicator(sender: nil);
                        }
                        guard let data1 = data1, error1 == nil else {
                            print(error1?.localizedDescription ?? "No data")
                            return
                        }
                        do {
                            let respItems = try JSONDecoder().decode([Availability].self, from: data1)
                            print(respItems)
                            DispatchQueue.main.async {
                                //update availability time slots
                                self.items.removeAll()
                                self.items.append(contentsOf: respItems)
            //                    for (i, reader) in items.enumerated() {
            //                    }
                                self.timeslotList.reloadData()
                            }
                        }
                        catch {
                            DispatchQueue.main.async {
                                Toast.show(message: "Something went wrong. try again later", controller: self)
                            }
                            print("there")
                        }
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    Toast.show(message: "Something went wrong. try again later", controller: self)
                }
                print("here")
            }
        }
        
    }
    // MARK: - Time Slot List Delegate.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         // myData is the array of items
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//        let totalSpace = flowLayout.sectionInset.top
//        + flowLayout.sectionInset.bottom
//        + (flowLayout.minimumLineSpacing * CGFloat(cellsPerRow - 1))
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRow))
        return CGSize(width: 80, height: 74)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Time Slot Collection View Cell", for: indexPath) as! TimeSlotCollectionViewCell

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: self.items[indexPath.row].date)!
    
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd MM"
        let dayMonth = dateFormatter.string(from: date)
        
        cell.lbl_num_slot.text = "\(self.items[indexPath.row]) slot";
        cell.lbl_weekday.text = weekDay
        cell.lbl_date_month.text = dayMonth
        // return card
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOffset = CGSizeZero
//        cell.layer.shadowRadius = 8
//        cell.layer.shadowOpacity = 0.2
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt")
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
    }
    @IBAction func ShowOverview(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_videointro.tintColor = .black
        btn_review.tintColor = .black
        line_overview.isHidden = false
        line_videointro.isHidden = true
        line_review.isHidden = true
        view_overview.isHidden = false
        view_videointro.isHidden = true
        view_review.isHidden = true
    }
    
    @IBAction func ShowVideoIntro(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_overview.tintColor = .black
        btn_review.tintColor = .black
        line_overview.isHidden = true
        line_videointro.isHidden = false
        line_review.isHidden = true
        view_overview.isHidden = true
        view_videointro.isHidden = false
        view_review.isHidden = true
    }
    
    @IBAction func ShowReview(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_overview.tintColor = .black
        btn_videointro.tintColor = .black
        line_overview.isHidden = true
        line_videointro.isHidden = true
        line_review.isHidden = false
        view_overview.isHidden = true
        view_videointro.isHidden = true
        view_review.isHidden = false
    }
    @IBAction func EditUserInfo(_ sender: UIButton) {
        let controller = ReaderProfileEditPersonalInfoViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditHighlight(_ sender: UIButton) {
        let controller = ReaderProfileEditPersonalInfoViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditAbout(_ sender: UIButton) {
        let controller = ReaderProfileEditAboutViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditSkills(_ sender: UIButton) {
        let controller = ReaderProfileEditSkillViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditAvailability(_ sender: UIButton) {
        let controller = ReaderProfileEditAvailabilityViewController()
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    @IBAction func EditProfile(_ sender: UIButton) {

        if isEditingMode {
//            sender.isEnabled = false
          
//            let myNormalAttributedTitle = NSAttributedString(string: "Edit Profile", attributes: [NSAttributedString.Key.font : UIFont(name: "Arial", size: 10.0)!])
//            sender.setAttributedTitle(myNormalAttributedTitle, for: .normal)
//            sender.isEnabled = true;
            isEditingMode = false;
//            view_viewall_skills.isHidden = false;
//            view_viewall_availability.isHidden = false;
            btn_edit_userinfo.isHidden = true;
            btn_edit_highlight.isHidden = true;
            btn_edit_about.isHidden = true;
            btn_edit_skills.isHidden = true;
            btn_edit_availability.isHidden = true;
            
            // Call API for create/update reader's profile
//
//            showIndicator(sender: sender, viewController: self)
//            let uid = UserDefaults.standard.string(forKey: "USER_ID")
//
//            webAPI.createReaderProfile(readeruid: uid!, title: readerTitle.text != nil ? readerTitle.text! : "", about: readerAbout.text != nil ? readerAbout.text! : "", hourlyprice: "120", skills: "") { data, response, error in
//                guard let data = data, error == nil else {
//                    print(error?.localizedDescription ?? "No data")
//                    return
//                }
//                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//
//                if let _ = responseJSON as? [String: Any] {
//
//                    DispatchQueue.main.async {
//                        hideIndicator(sender: sender)
//                        Toast.show(message: "Profile updated successfully!", controller: self)
//                    }
//                }
//                else
//                {
//                    DispatchQueue.main.async {
//                        hideIndicator(sender: sender)
//                        Toast.show(message: "Profile update failed! please try again.", controller: self)
//                    }
//                }
//            }
            
        }
        else {
//            sender.isEnabled = false;
////            sender.setTitle("Save Changes", for: UIButton.State.normal)
//            let myNormalAttributedTitle = NSAttributedString(string: "Save Changes", attributes: [NSAttributedString.Key.font : UIFont(name: "Arial", size: 10.0)!])
//            sender.setAttributedTitle(myNormalAttributedTitle, for: .normal)
//            sender.isEnabled = true;
            isEditingMode = true;
//            view_viewall_skills.isHidden = true;
//            view_viewall_availability.isHidden = true;
            btn_edit_userinfo.isHidden = false;
            btn_edit_highlight.isHidden = false;
            btn_edit_about.isHidden = false;
            btn_edit_skills.isHidden = false;
            btn_edit_availability.isHidden = false;
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
