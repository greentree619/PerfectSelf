//
//  ActorHomeViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import RangeSeekSlider

class ActorHomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate
{
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var readerList: UICollectionView!
    
    @IBOutlet weak var spin: UIActivityIndicatorView!
    @IBOutlet weak var readerListFlow: UICollectionViewFlowLayout!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var img_actor_avatar: UIImageView!
    
    @IBOutlet weak var btn_sponsored: UIButton!
    @IBOutlet weak var btn_availablesoon: UIButton!
    @IBOutlet weak var btn_topRate: UIButton!
    let backgroundView = UIView()
    
    var isSponsored = true
    var isAvailableSoon = false
    var isTopRated = false
    var searchString = ""
    
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
        
        // Retrieve the saved data from UserDefaults
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            let name = userInfo["userName"] as? String
            let bucketName = userInfo["avatarBucketName"] as? String
            let avatarKey = userInfo["avatarKey"] as? String
            greetingLabel.text = "Hi, " + (name ?? "User")
            if (bucketName != nil && avatarKey != nil) {
                let url = "https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/\( bucketName!)/\(avatarKey!)"
                img_actor_avatar.imageFrom(url: URL(string: url)!)
            }
        } else {
            // No data was saved
            print("No data was saved.")
        }
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchReaderList()
        //call API for badge appear
    }
    
    @IBAction func didSearchStringChanged(_ sender: UITextField) {
        searchString = sender.text ?? ""
        fetchReaderList()
    }
    func fetchReaderList() {
        spin.isHidden = false
        spin.startAnimating()
        // call API to fetch reader list
        webAPI.getReaders(readerName: searchString,isSponsored: isSponsored, isAvailableSoon: isAvailableSoon,isTopRated: isTopRated, isOnline: nil, availableTimeSlotType: nil, availableFrom: nil, availableTo: nil, minPrice: nil, maxPrice: nil, gender: nil, sortBy: nil) { data, response, error in
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
        return CGSize(width: size, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reader Collection View Cell", for: indexPath) as! ReaderCollectionViewCell
        
        if self.items[indexPath.row].avatarBucketName != nil {
            let url = "https://perfectself-avatar-bucket.s3.us-east-2.amazonaws.com/\( self.items[indexPath.row].avatarBucketName!)/\( self.items[indexPath.row].avatarKey!)"
            cell.readerAvatar.imageFrom(url: URL(string: url)!)
        }
        cell.readerName.text = self.items[indexPath.row].userName;
        cell.salary.text = "$" + String((self.items[indexPath.row].hourlyPrice ?? 0)/4)
        cell.score.text = String(self.items[indexPath.row].score)
        cell.review.text = "(\(self.items[indexPath.row].reviewCount))"
        cell.status.backgroundColor = self.items[indexPath.row].isLogin ? UIColor(rgb: 0x34C759) : UIColor(rgb: 0xAAAAAA)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let date = dateFormatter.date(from: self.items[indexPath.row].date ?? "1900-01-01T00:00:00Z")
    
        let dfforlabel = DateFormatter()
        dfforlabel.dateFormat = "MMM dd, hh:mm a"
        cell.availableDate.text = dfforlabel.string(from: date!)
        // return card
        cell.layer.masksToBounds = false
        cell.layer.shadowOffset = CGSizeZero
        cell.layer.shadowRadius = 3
        cell.layer.shadowOpacity = 0.15
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
        fetchReaderList()
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
        fetchReaderList()
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
        fetchReaderList()
    }
    
    @IBAction func ViewAll(_ sender: UIButton) {
        isSponsored = false
        isAvailableSoon = false
        isTopRated = false
        
        btn_sponsored.backgroundColor = UIColor(rgb: 0xE5E5E5)
        btn_sponsored.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_availablesoon.backgroundColor = UIColor(rgb: 0xE5E5E5)
        btn_availablesoon.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        btn_topRate.backgroundColor = UIColor(rgb: 0xE5E5E5)
        btn_topRate.setTitleColor(UIColor(rgb: 0x4865FF), for: .normal)
        
        fetchReaderList()
    }
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
