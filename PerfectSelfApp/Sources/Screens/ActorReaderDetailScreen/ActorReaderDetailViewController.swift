//
//  ActorReaderDetailViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorReaderDetailViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var uid: String = ""
    @IBOutlet weak var btn_overview: UIButton!
    @IBOutlet weak var btn_videointro: UIButton!
    @IBOutlet weak var btn_review: UIButton!
    
    @IBOutlet weak var line_overview: UIImageView!
    @IBOutlet weak var line_videointro: UIImageView!
    @IBOutlet weak var line_review: UIImageView!
    
    @IBOutlet weak var view_review: UIStackView!
    @IBOutlet weak var view_videointro: UIStackView!
    @IBOutlet weak var view_overview: UIStackView!
   
    @IBOutlet weak var view_container: UIView!
    // info
    
    @IBOutlet weak var reader_avatar: UIImageView!
    @IBOutlet weak var reader_name: UILabel!
    @IBOutlet weak var reader_title: UILabel!
    @IBOutlet weak var reader_hourly: UILabel!
    @IBOutlet weak var reader_skill: UILabel!
    @IBOutlet weak var reader_about: UITextView!
    @IBOutlet weak var timeslotList: UICollectionView!
    
//    var items = ["1", "2", "3", "3", "2", "4"]
    var items = [Availability]()
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
        self.view_videointro.alpha = 0
        self.view_review.alpha = 0
        self.view_overview.frame.origin.x = 0
        self.view_videointro.frame.origin.x = self.view_container.frame.width
        self.view_review.frame.origin.x = self.view_container.frame.width
        
        // call api for reader details
        showIndicator(sender: nil, viewController: self)
        
        webAPI.getReaderById(id:uid) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let item = try JSONDecoder().decode(ReaderProfileDetail.self, from: data)
                print(item)
                DispatchQueue.main.async {
                    self.reader_name.text = item.userName
                    self.reader_title.text = item.title
                    self.reader_about.text = item.about
                    self.reader_hourly.text = "$\(item.hourlyPrice/4) / 15 mins"
                    self.reader_skill.text = item.skills
                    if !item.avatarBucketName.isEmpty {
                        let url = "https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/\(item.avatarBucketName)/\(item.avatarKey)"
                        self.reader_avatar.imageFrom(url: URL(string: url)!)
                    }
                    //call API for available time slots
                    
                    webAPI.getAvailabilityById(uid: self.uid) {data1, response1, error1 in
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
                            print(error)
                            DispatchQueue.main.async {
                                Toast.show(message: "Something went wrong. try again later", controller: self)
                            }
                        }
                    }
                }
            }
            catch {
                print(error)
                DispatchQueue.main.async {
                    Toast.show(message: "Something went wrong. try again later", controller: self)
                }
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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: self.items[indexPath.row].date)
    
        dateFormatter.dateFormat = "EEE"
        let weekDay = dateFormatter.string(from: date ?? Date())
        
        dateFormatter.dateFormat = "dd MMM"
        let dayMonth = dateFormatter.string(from: date ?? Date())
        
        cell.lbl_num_slot.text = "1 slot";
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
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view_overview.alpha = 1
            self.view_videointro.alpha = 0
            self.view_review.alpha = 0
            self.view_overview.frame.origin.x = 0
            self.view_videointro.frame.origin.x = self.view_container.frame.width
            self.view_review.frame.origin.x = self.view_container.frame.width
        })        
    }
    
    @IBAction func ShowVideoIntro(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_overview.tintColor = .black
        btn_review.tintColor = .black
        line_overview.isHidden = true
        line_videointro.isHidden = false
        line_review.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view_overview.alpha = 0
            self.view_videointro.alpha = 1
            self.view_review.alpha = 0
            self.view_overview.frame.origin.x = -self.view_container.frame.width
            self.view_videointro.frame.origin.x = 0
            self.view_review.frame.origin.x = self.view_container.frame.width
        })
    }
    
    @IBAction func ShowReview(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_overview.tintColor = .black
        btn_videointro.tintColor = .black
        line_overview.isHidden = true
        line_videointro.isHidden = true
        line_review.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view_overview.alpha = 0
            self.view_videointro.alpha = 0
            self.view_review.alpha = 1
            self.view_overview.frame.origin.x = -self.view_container.frame.width
            self.view_videointro.frame.origin.x = -self.view_container.frame.width
            self.view_review.frame.origin.x = 0
        })
    }
    @IBAction func BookAppointment(_ sender: UIButton) {
        let controller = ActorBookAppointmentViewController();
        controller.rUid = uid
        controller.modalPresentationStyle = .fullScreen
     
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
    }
    

    @IBAction func GoBack(_ sender: UIButton) {
//        _ = navigationController?.popViewController(animated: true)
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
    
        self.dismiss(animated: false)
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
