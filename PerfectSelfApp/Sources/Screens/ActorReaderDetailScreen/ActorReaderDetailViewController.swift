//
//  ActorReaderDetailViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorReaderDetailViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var id: String = "1"
    var readerUid: String = ""
    @IBOutlet weak var btn_overview: UIButton!
    @IBOutlet weak var btn_videointro: UIButton!
    @IBOutlet weak var btn_review: UIButton!
    
    @IBOutlet weak var line_overview: UIImageView!
    @IBOutlet weak var line_videointro: UIImageView!
    @IBOutlet weak var line_review: UIImageView!
    
    @IBOutlet weak var view_review: UIStackView!
    @IBOutlet weak var view_videointro: UIStackView!
    @IBOutlet weak var view_overview: UIStackView!
    @IBOutlet weak var view_reader: UIStackView!
    // info
    
    @IBOutlet weak var reader_title: UILabel!
    @IBOutlet weak var reader_hourly: UILabel!
    
    @IBOutlet weak var timeslotList: UICollectionView!
    var items = ["1", "2", "3", "3", "2", "4"]
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
        self.navigationItem.setHidesBackButton(true, animated: false)
        view_reader.isHidden = true
        
        // call api for reader details
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
        webAPI.getReaderById(id: id) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                DispatchQueue.main.async {
                    Toast.show(message: "Something went wrong. try again later", controller: self)
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.removeFromSuperview()
                }
                return
            }
            do {
                let item = try JSONDecoder().decode(ReaderProfileDetail.self, from: data)
                print(item)
                DispatchQueue.main.async {
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.removeFromSuperview()
                    self.view_reader.isHidden = false
                    self.reader_title.text = item.title
                    self.reader_hourly.text = "$\((item.hourlyPrice ?? 0)/4) / 15 mins"
                    self.readerUid = item.readerUid
                }
            }
            catch {
                DispatchQueue.main.async {
                    Toast.show(message: "Something went wrong. try again later", controller: self)
                    activityIndicatorView.stopAnimating()
                    activityIndicatorView.removeFromSuperview()
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
        cell.lbl_num_slot.text = "\(self.items[indexPath.row]) slot";
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
    @IBAction func BookAppointment(_ sender: UIButton) {
        let controller = ActorBookAppointmentViewController();
        controller.rUid = readerUid
        self.navigationController?.pushViewController(controller, animated: true)
    }
    

    @IBAction func GoBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        print("ok")
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
