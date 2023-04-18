//
//  ActorLibraryViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import HSPopupMenu

class ActorLibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var videoList: UICollectionView!
    var uid = ""
    var items = [VideoCard]()
    let cellsPerRow = 2
    var menuArray: [HSMenu] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
        videoList.register(nib, forCellWithReuseIdentifier: "Video Collection View Cell")
        videoList.dataSource = self
        videoList.delegate = self
        videoList.allowsSelection = true
        // Do any additional setup after loading the view.
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            uid = userInfo["uid"] as! String
        } else {
            // No data was saved
            print("No data was saved.")
        }
        
        showIndicator(sender: nil, viewController: self)
        webAPI.getLibraryByUid(uid: uid){ data, response, error in
            DispatchQueue.main.async {
                hideIndicator(sender: nil)
            }
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let respItems = try JSONDecoder().decode([VideoCard].self, from: data)
                //print(items)
                DispatchQueue.main.async {
                    self.items.removeAll()
                    self.items.append(contentsOf: respItems)
                    //                    for (i, reader) in items.enumerated() {
                    //                    }
                    self.videoList.reloadData()
                }
                
            } catch {
                print(error)
                DispatchQueue.main.async {
                    Toast.show(message: "Fetching reader list failed! please try again.", controller: self)
                }
            }
        }
        //
        let menu1 = HSMenu(icon: nil, title: "Create Folder")
        let menu2 = HSMenu(icon: nil, title: "Edit")

        menuArray = [menu1, menu2]
    }
 
    @IBAction func ShowFolderMenu(_ sender: UIButton) {
        let originInWindow = sender.convert(CGPoint.zero, to: nil)
        
        let x = originInWindow.x
        let y = originInWindow.y + sender.frame.height

        print("Button coordinates: (\(x), \(y))")
        let popupMenu = HSPopupMenu(menuArray: menuArray, arrowPoint: CGPoint(x: x, y: y))
        popupMenu.popUp()
        popupMenu.delegate = self

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
        let size = Int((collectionView.bounds.width - totalSpace - 2) / CGFloat(cellsPerRow))
       
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Video Collection View Cell", for: indexPath) as! VideoCollectionViewCell
        cell.name.text = self.items[indexPath.row].tapeName
        let thumb = "https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/\(self.items[indexPath.row].tapeKey)-0.jpg"
        cell.tapeThumb.imageFrom(url: URL(string:thumb )!)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        let d = df.date(from: self.items[indexPath.row].createdTime)
        df.dateFormat = "dd-MM-yyyy"
        cell.createdDate.text = df.string(from: d ?? Date())
        // return card
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOffset = CGSizeZero
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
        
        selectedTape = self.items[indexPath.row]
        let projectViewController = ProjectViewController()
        projectViewController.modalPresentationStyle = .fullScreen
        self.present(projectViewController, animated: false, completion: nil)
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
extension ActorLibraryViewController: HSPopupMenuDelegate {
    func popupMenu(_ popupMenu: HSPopupMenu, didSelectAt index: Int) {
        print("selected index is: " + "\(index)")
    }
}
