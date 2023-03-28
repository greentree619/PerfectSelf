//
//  ReaderHomeViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ReaderHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var switch_mode: UISwitch!
    
    @IBOutlet weak var bookList: UICollectionView!
    var items = [BookingCard]()

    let cellsPerRow = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "BookingCollectionViewCell", bundle: nil)
        bookList.register(nib, forCellWithReuseIdentifier: "Booking Collection View Cell")
        bookList.dataSource = self
        bookList.delegate = self
        bookList.allowsSelection = true
        // Do any additional setup after loading the view.
        switch_mode.transform = CGAffineTransform(scaleX: 0.8, y: 0.75);
        if let thumb = switch_mode.subviews[0].subviews[1].subviews[2] as? UIImageView {
            thumb.transform = CGAffineTransform(scaleX:1.25, y: 1.333)
        }
        
        //call API to fetch booking list
        showIndicator(sender: nil, viewController: self)
        webAPI.getAllBookings() { data, response, error in
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
                    if self.items.isEmpty {
                        self.bookList.isHidden = true
                    }
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
        let isoDate = self.items[indexPath.row].bookStartTime

        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-ddTHH:mm:ssZ"
        let datestart = dateFormatter.date(from:isoDate)
        let dateend = dateFormatter.date(from:self.items[indexPath.row].bookEndTime)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "YY, MMM d"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "hh:mm a"
        
        cell.lbl_name.text = self.items[indexPath.row].readerName;
        cell.lbl_date.text = dateFormatter1.string(from: datestart ?? Date())
        cell.lbl_time.text = dateFormatter2.string(from: datestart ?? Date()) + "-" + dateFormatter2.string(from: dateend ?? Date())
        
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSizeZero
        cell.layer.shadowRadius = 8
        cell.layer.shadowOpacity = 0.2
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        // return card
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt")
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
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
