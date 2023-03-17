//
//  LibraryViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/26/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import WebRTC

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    //var items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48"]
            
    @IBOutlet weak var libraryCollection: UICollectionView!
        
    @IBOutlet weak var libraryCollectionFlow: UICollectionViewFlowLayout!
    
    init() {
        super.init(nibName: String(describing: LibraryViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellsPerRow = 2
    var libraryUrls = [String]()
    override func viewDidLoad() {
        let nib = UINib(nibName: "LibraryCell", bundle: nil)
        libraryCollection.register(nib, forCellWithReuseIdentifier: "LibraryCell")
        libraryCollection.dataSource = self
        libraryCollection.delegate = self
        
        webAPI.getLibraryURLs(urls: &libraryUrls)
    }
    
    @IBAction func backDidTap(_ sender: UIButton)
    {
        self.dismiss(animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView,        numberOfItemsInSection section: Int) -> Int {
         // myData is the array of items
        return self.libraryUrls.count
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LibraryCell", for: indexPath) as! LibraryCell
        cell.label.text = self.libraryUrls[indexPath.row];
        cell.thumbnail.imageFrom(url: URL(string: self.libraryUrls[indexPath.row])!)
        // return card
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        print("didDeselectItemAt")
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
    }
}
