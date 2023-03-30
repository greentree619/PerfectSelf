//
//  ActorFindReaderViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorFindReaderViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var btn_relevance: UIButton!
    @IBOutlet weak var btn_pricehightolow: UIButton!
    @IBOutlet weak var btn_pricelowtohigh: UIButton!
    @IBOutlet weak var btn_soonest: UIButton!
    @IBOutlet weak var numberOfReader: UILabel!
    @IBOutlet weak var modal_sort: UIView!
    @IBOutlet weak var readerList: UICollectionView!
    var items = [ReaderProfileCard]()
    let cellsPerRow = 1
    let backgroundView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ReaderCollectionViewCell", bundle: nil)
        readerList.register(nib, forCellWithReuseIdentifier: "Reader Collection View Cell")
        readerList.dataSource = self
        readerList.delegate = self
        readerList.allowsSelection = true
        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        modal_sort.alpha = 0;

        
        showIndicator(sender: nil, viewController: self)
        // call API to fetch reader list
        webAPI.getAllReaders() { data, response, error in
            DispatchQueue.main.async {
                hideIndicator(sender: nil)
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
//                    for (i, reader) in items.enumerated() {
//                    }
                    self.readerList.reloadData()
                    self.numberOfReader.text = "\(respItems.count) Readers Listed"
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
        return CGSize(width: size, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Reader Collection View Cell", for: indexPath) as! ReaderCollectionViewCell
        cell.readerName.text = self.items[indexPath.row].userName;
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
        controller.uid = self.items[indexPath.row].uid
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
    }
    
    @IBAction func SortReaders(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
           self.modal_sort.alpha = 1;
        };
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundView.frame = view.bounds
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(backgroundView, belowSubview: modal_sort)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCallback))
        backgroundView.addGestureRecognizer(tap)
        backgroundView.isUserInteractionEnabled = true
    }
    @objc func tapCallback() {
        backgroundView.removeFromSuperview()
        self.modal_sort.alpha = 0;
    }
//    @IBAction func FilterReaders(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.5) {
//            self.modal_filter.alpha = 1;
//        };
//    }
    
    @IBAction func SortApply(_ sender: UIButton) {
        backgroundView.removeFromSuperview()
        self.modal_sort.alpha = 0;
    }

    @IBAction func SelectRelevance(_ sender: UIButton) {
        btn_relevance.tintColor = UIColor(rgb: 0x4383C4)
        btn_pricehightolow.tintColor = .black
        btn_pricelowtohigh.tintColor = .black
        btn_soonest.tintColor = .black
    }
    
    @IBAction func SelectPriceHighToLow(_ sender: UIButton) {
        btn_relevance.tintColor = .black
        btn_pricehightolow.tintColor = UIColor(rgb: 0x4383C4)
        btn_pricelowtohigh.tintColor = .black
        btn_soonest.tintColor = .black
    }
    @IBAction func SelectPriceLowToHigh(_ sender: UIButton) {
        btn_relevance.tintColor = .black
        btn_pricehightolow.tintColor = .black
        btn_pricelowtohigh.tintColor = UIColor(rgb: 0x4383C4)
        btn_soonest.tintColor = .black
    }
    @IBAction func SelectAvailableSoonest(_ sender: UIButton) {
        btn_relevance.tintColor = .black
        btn_pricehightolow.tintColor = .black
        btn_pricelowtohigh.tintColor = .black
        btn_soonest.tintColor = UIColor(rgb: 0x4383C4)
    }
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
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
