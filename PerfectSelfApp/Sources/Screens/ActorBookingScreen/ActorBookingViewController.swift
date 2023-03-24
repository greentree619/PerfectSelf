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
    
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    //    let r = UIImage(named: "book");
    let cellsPerRow = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "BookingCollectionViewCell", bundle: nil)
        bookList.register(nib, forCellWithReuseIdentifier: "Booking Collection View Cell")
        bookList.dataSource = self
        bookList.delegate = self
        
        // Do any additional setup after loading the view.
        line_pending.isHidden = true
        line_past.isHidden = true
        
        
//        let containerView = UIView()
//        let num = 0...10
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
//        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 800)
//
//        scrollView.addSubview(containerView)
//        scrollView.contentSize = containerView.frame.size
//        let containerView = UIView()
//
//        let num = 0...10
//        for i in num {
//
//            let item = Item(frame: CGRect(x: 0, y:120*i, width:Int(scrollView.frame.width), height:100), labelText: "Booking History")
//            item.tapCallback = {
//                let controller = ActorReaderDetailViewController();
//
//                self.navigationController?.pushViewController(controller, animated: true)
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
//        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 1310)
//
//        scrollView.addSubview(containerView)
//        scrollView.contentSize = containerView.frame.size
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
        return CGSize(width: size, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Booking Collection View Cell", for: indexPath) as! BookingCollectionViewCell
        cell.lbl_name.text = self.items[indexPath.row];
        cell.layer.masksToBounds = false
        cell.layer.shadowRadius = 5
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.backgroundColor = UIColor(rgb: 0xE5E5E5)
        // return card
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
