//
//  ActorBookingViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBookingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var btn_upcoming: UIButton!
    @IBOutlet weak var btn_past: UIButton!
    @IBOutlet weak var btn_pending: UIButton!
    
    @IBOutlet weak var line_upcoming: UIImageView!
    @IBOutlet weak var line_pending: UIImageView!
    @IBOutlet weak var line_past: UIImageView!

    @IBOutlet weak var bookList: UICollectionView!
    //    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bookListFlow: UICollectionViewFlowLayout!
    var items = [BookingCard]()

    @IBOutlet weak var view_rate: UIStackView!
    
    @IBOutlet weak var img_star1: UIImageView!
    @IBOutlet weak var img_star2: UIImageView!
    @IBOutlet weak var img_star3: UIImageView!
    @IBOutlet weak var img_star4: UIImageView!
    @IBOutlet weak var img_star5: UIImageView!
    
    let cellsPerRow = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "BookingCollectionViewCell", bundle: nil)
        bookList.register(nib, forCellWithReuseIdentifier: "Booking Collection View Cell")
        bookList.dataSource = self
        bookList.delegate = self
        bookList.allowsSelection = true
        // Do any additional setup after loading the view.
        line_pending.isHidden = true
        line_past.isHidden = true
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
       //call API to fetch booking list
       showIndicator(sender: nil, viewController: self)
        let id = UserDefaults.standard.string(forKey: "USER_ID")!
        webAPI.getBookingsByUid(uid: id) { data, response, error in
           DispatchQueue.main.async {
               hideIndicator(sender: nil)
           }
           
           guard let data = data, error == nil else {
               print(error?.localizedDescription ?? "No data")
               return
           }
           do {
               let respItems = try JSONDecoder().decode([BookingCard].self, from: data)
               //print(items)
               DispatchQueue.main.async {
                   self.items.removeAll()
                   self.items.append(contentsOf: respItems)
//                    for (i, reader) in items.enumerated() {
//                    }
                   self.bookList.reloadData()
               }

           } catch {
               print(error)
               DispatchQueue.main.async {
                   Toast.show(message: "Fetching reader list failed! please try again.", controller: self)
               }
           }
       }
    }
    // MARK: - Booking List Delegate.
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
        return CGSize(width: size, height: size*145/328)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Booking Collection View Cell", for: indexPath) as! BookingCollectionViewCell
        let roomUid = self.items[indexPath.row].roomUid

        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let datestart = dateFormatter.date(from: self.items[indexPath.row].bookStartTime)
        let dateend = dateFormatter.date(from: self.items[indexPath.row].bookEndTime)
        
        print(self.items[indexPath.row].bookStartTime)
        print(self.items[indexPath.row].bookEndTime)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd MMM, yyyy"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "hh:mm a"
        
        
        cell.lbl_name.text = self.items[indexPath.row].readerName;
        cell.lbl_date.text = dateFormatter1.string(from: datestart ?? Date())
        cell.lbl_time.text = dateFormatter2.string(from: datestart ?? Date()) + "-" + dateFormatter2.string(from: dateend ?? Date())
        
        cell.navigationController = self.navigationController
        cell.parentViewController = self
        cell.roomUid = roomUid
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt")
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
    }
    
    @IBAction func ShowUpcomingBookings(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_pending.tintColor = .black
        btn_past.tintColor = .black
        line_upcoming.isHidden = false
        line_pending.isHidden = true
        line_past.isHidden = true
    }
    
    @IBAction func ShowPendingBookings(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_upcoming.tintColor = .black
        btn_past.tintColor = .black
        line_upcoming.isHidden = true
        line_pending.isHidden = false
        line_past.isHidden = true
    }
    
    @IBAction func ShowPastBookings(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_upcoming.tintColor = .black
        btn_pending.tintColor = .black
        line_upcoming.isHidden = true
        line_pending.isHidden = true
        line_past.isHidden = false
    }
    
    @IBAction func CloseRateView(_ sender: UIButton) {
        view_rate.isHidden = true
    }
    
    @IBAction func RateWithStar1(_ sender: UITapGestureRecognizer) {
        img_star1.tintColor = UIColor(rgb: 0xFFCC00)
        img_star2.tintColor = UIColor(rgb: 0x9498AB)
        img_star3.tintColor = UIColor(rgb: 0x9498AB)
        img_star4.tintColor = UIColor(rgb: 0x9498AB)
        img_star5.tintColor = UIColor(rgb: 0x9498AB)
    }
    @IBAction func RateWithStar2(_ sender: UITapGestureRecognizer) {
        img_star1.tintColor = UIColor(rgb: 0xFFCC00)
        img_star2.tintColor = UIColor(rgb: 0xFFCC00)
        img_star3.tintColor = UIColor(rgb: 0x9498AB)
        img_star4.tintColor = UIColor(rgb: 0x9498AB)
        img_star5.tintColor = UIColor(rgb: 0x9498AB)
    }
    
    @IBAction func RateWithStar3(_ sender: UITapGestureRecognizer) {
        img_star1.tintColor = UIColor(rgb: 0xFFCC00)
        img_star2.tintColor = UIColor(rgb: 0xFFCC00)
        img_star3.tintColor = UIColor(rgb: 0xFFCC00)
        img_star4.tintColor = UIColor(rgb: 0x9498AB)
        img_star5.tintColor = UIColor(rgb: 0x9498AB)
    }
    
    @IBAction func RateWithStar4(_ sender: UITapGestureRecognizer) {
        img_star1.tintColor = UIColor(rgb: 0xFFCC00)
        img_star2.tintColor = UIColor(rgb: 0xFFCC00)
        img_star3.tintColor = UIColor(rgb: 0xFFCC00)
        img_star4.tintColor = UIColor(rgb: 0xFFCC00)
        img_star5.tintColor = UIColor(rgb: 0x9498AB)
    }
    
    @IBAction func RateWithStar5(_ sender: UITapGestureRecognizer) {
        img_star1.tintColor = UIColor(rgb: 0xFFCC00)
        img_star2.tintColor = UIColor(rgb: 0xFFCC00)
        img_star3.tintColor = UIColor(rgb: 0xFFCC00)
        img_star4.tintColor = UIColor(rgb: 0xFFCC00)
        img_star5.tintColor = UIColor(rgb: 0xFFCC00)
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
