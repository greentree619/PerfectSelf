//
//  ActorLibraryViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorLibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var videoList: UICollectionView!
//    var items = [VideoCard]()
    var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9","10", "11", "12", "13"]
    let cellsPerRow = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
        videoList.register(nib, forCellWithReuseIdentifier: "Video Collection View Cell")
        videoList.dataSource = self
        videoList.delegate = self
        videoList.allowsSelection = true
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - Video List Delegate.
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
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Video Collection View Cell", for: indexPath) as! VideoCollectionViewCell
        cell.name.text = self.items[indexPath.row]
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
        controller.readerUid = self.items[indexPath.row]
        self.navigationController?.pushViewController(controller, animated: true)
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
