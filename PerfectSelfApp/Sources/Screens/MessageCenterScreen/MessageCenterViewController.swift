//
//  ActorMessageCenterViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/16/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class MessageCenterViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

//    @IBOutlet weak var scrollView: UIScrollView!
//    let r = UIImage(named: "reader");
    let divide = UIImage(named: "filter_divide");
    @IBOutlet weak var chatCardList: UICollectionView!
    @IBOutlet weak var btn_back: UIButton!
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
    let cellsPerRow = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ChatCardCollectionViewCell", bundle: nil)
        chatCardList.register(nib, forCellWithReuseIdentifier: "Chat Card Collection View Cell")
        chatCardList.dataSource = self
        chatCardList.delegate = self
        chatCardList.allowsSelection = true
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        let userType = UserDefaults.standard.string(forKey: "USER_TYPE")
        btn_back.isHidden = userType == "reader"
    }
    
    // MARK: - ChatCard List Delegate.
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Chat Card Collection View Cell", for: indexPath) as! ChatCardCollectionViewCell
        cell.lbl_unviewednum.text = self.items[indexPath.row];
        
        // return card
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOffset = CGSize(width: 3,height: 3)
//        cell.layer.shadowRadius = 8
//        cell.layer.shadowOpacity = 0.2
//        cell.contentView.layer.cornerRadius = 12
//        cell.contentView.layer.borderWidth = 1.0
//        cell.contentView.layer.borderColor = UIColor.clear.cgColor
//        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt" + String(indexPath.row))
        
        let roomUid = "1234567890"//self.items[indexPath.row].roomUid
        let controller = ChatViewController(roomUid: roomUid);
        controller.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        
        self.present(controller, animated: false)
//        self.navigationController?.pushViewController(controller, animated: true);
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
    }
  
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
