//
//  ReaderProfileEditSkillViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
public enum TypeOfAccordianView {
    case Classic
    case Formal
}

class ReaderProfileEditSkillViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var typeOfAccordianView = TypeOfAccordianView.Formal
    
    @IBOutlet weak var skillView: UIStackView!
    @IBOutlet weak var selectedSkillList: UICollectionView!
//    @IBOutlet weak var selectedSkillView: UIStackView!
    var items = [String]()
    let cellsPerRow = 1
    
    let headerLabel = ["Skill Set 1", "Skill Set 2", "Skill Set 3"]
    let innerLabel = [
        ["skill 11", "skill 12", "skill 13"],
        ["skill 21", "skill 22"],
        ["skill 31", "skill 32", "skill 33", "skill 34"]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "SkillCell", bundle: nil)
        selectedSkillList.register(nib, forCellWithReuseIdentifier: "Skill Cell")
        selectedSkillList.dataSource = self
        selectedSkillList.delegate = self
        selectedSkillList.allowsSelection = true
    
        
         let accordionView = MKAccordionView(frame: CGRect(x: 0, y: 0, width: skillView.bounds.width, height: skillView.bounds.height-50))
          
        accordionView.delegate = self;
        accordionView.dataSource = self;
        accordionView.isCollapsedAllWhenOneIsOpen = true
        skillView.addSubview(accordionView);
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
        return CGSize(width: 80, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Skill Cell", for: indexPath) as! SkillCell
        cell.skillName.text = items[indexPath.row]
        // return card
//        cell.layer.masksToBounds = false
//        cell.layer.shadowOffset = CGSizeZero
//        cell.layer.shadowRadius = 8
//        cell.layer.shadowOpacity = 0.2
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.borderWidth = 0
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // add the code here to perform action on the cell
        items.remove(at: indexPath.row)
        selectedSkillList.reloadData()
//        let cell = collectionView.cellForItem(at: indexPath) as? LibraryCollectionViewCell
    }

    @IBAction func SaveChanges(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.dismiss(animated: false)
    }
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.dismiss(animated: true)
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

// MARK: - Implemention of MKAccordionViewDelegate method
extension ReaderProfileEditSkillViewController : MKAccordionViewDelegate {
    
  func accordionView(_ accordionView: MKAccordionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch typeOfAccordianView {
            case .Classic :
                 return 50
            case .Formal :
                 return 40
        }
    }
    
    func accordionView(_ accordionView: MKAccordionView, heightForHeaderIn section: Int) -> CGFloat {
        switch typeOfAccordianView {
        case .Classic :
            return 50
        case .Formal :
            return 40
        }
    }
    
    func accordionView(_ accordionView: MKAccordionView, heightForFooterIn section: Int) -> CGFloat {
        switch typeOfAccordianView {
        case .Classic :
            return 0
        case .Formal :
            return 12
        }
    }
    
    func accordionView(_ accordionView: MKAccordionView, viewForHeaderIn section: Int, isSectionOpen sectionOpen: Bool) -> UIView? {
     
        return getHeaderViewForAccordianType(typeOfAccordianView, accordionView: accordionView, section: section,  isSectionOpen: sectionOpen);
        
    }
    
    func accordionView(_ accordionView: MKAccordionView, viewForFooterIn section: Int, isSectionOpen sectionOpen: Bool) -> UIView? {
        
        switch typeOfAccordianView {
        case .Classic :
            
          let view  = UIView(frame: CGRect(x: 0, y:0, width: accordionView.bounds.width, height: 0))
          view.backgroundColor = UIColor.clear
          return view
            
        case .Formal :
          let view : UIView! = UIView(frame: CGRect(x: 0, y:0, width: accordionView.bounds.width, height:12))
          view.backgroundColor = UIColor.white
          return view
        }
        
    }
    
    func getHeaderViewForAccordianType(_ type : TypeOfAccordianView, accordionView: MKAccordionView, section: Int, isSectionOpen sectionOpen: Bool) -> UIView {
        switch type {
        case .Classic :
          let view : UIView! = UIView(frame: CGRect(x: 0, y:0, width: accordionView.bounds.width, height: 50))
            
            // Background Image
            let bgImageView : UIImageView = UIImageView(frame: view.bounds)
            bgImageView.image = UIImage(named: ( sectionOpen ? "grayBarSelected" : "grayBar"))!
            view.addSubview(bgImageView)
            
            // Arrow Image
          let arrowImageView : UIImageView = UIImageView(frame: CGRect(x: 15, y:15, width:20, height:20))
            arrowImageView.image = UIImage(named: ( sectionOpen ? "close" : "open"))!
            view.addSubview(arrowImageView)
            
            
            // Title Label
          let titleLabel : UILabel = UILabel(frame: CGRect(x:50, y:0, width: view.bounds.width - 120, height: view.bounds.height ))
            titleLabel.text = headerLabel[section]
            titleLabel.textColor = UIColor.white
            view.addSubview(titleLabel)
            
            return view
            
        case .Formal :
            
          let view : UIView! = UIView(frame: CGRect(x:0, y:0, width: accordionView.bounds.width , height: 40))
            view.backgroundColor = UIColor(rgb: 0xE5E5E5)
            view.cornerRadius = 10
            view.clipsToBounds = false
            
            // Image before Home
          let bgImageView : UIImageView = UIImageView(frame: CGRect(x: 10, y:12, width:16, height:16))
//          let bgImageView : UIImageView = UIImageView(frame: CGRect(x: 5, y:16, width:11, height:8))
            bgImageView.image = UIImage(systemName: ( sectionOpen ? "record.circle" : "circle"))!
            bgImageView.tintColor = .black
//            bgImageView.image = UIImage(named: ( sectionOpen ? "favorites-pointer" : "favorites-pointer"))!
            view.addSubview(bgImageView)
            
            // Arrow Image
//          let arrowImageView : UIImageView = UIImageView(frame: CGRect( x: view.bounds.width - 12 - 10 , y: 15, width: 12, height: 6))
//            arrowImageView.image = UIImage(named: ( sectionOpen ? "arrow-down" : "arrow-up"))!
//            view.addSubview(arrowImageView)
            
            
            // Title Label
          let titleLabel : UILabel = UILabel(frame: CGRect(x: 36, y: 0, width: view.bounds.width - 120, height: view.bounds.height))
          titleLabel.text = headerLabel[section]
          titleLabel.textColor = UIColor.black
          titleLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
            view.addSubview(titleLabel)
            
          return view
        }
    }
    
}

// MARK: - Implemention of MKAccordionViewDatasource method
extension ReaderProfileEditSkillViewController : MKAccordionViewDatasource {
    
    func numberOfSectionsInAccordionView(_ accordionView: MKAccordionView) -> Int {
        return 3 //TODO: count of section array
    }
    
    func accordionView(_ accordionView: MKAccordionView, numberOfRowsIn section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return 4
        default:
            return 3
        }
    }
    
    func accordionView(_ accordionView: MKAccordionView , cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return getCellForAccordionType(typeOfAccordianView, accordionView: accordionView, cellForRowAt: indexPath)
    }
    
    func accordionView(_ accordionView: MKAccordionView, didSelectRowAt indexPath: IndexPath) {
        
//        print("accordionView \(indexPath.section) \(indexPath.item)")
        if items.contains(innerLabel[indexPath.section][indexPath.item]) {
            return 
        }
        
        items.append(innerLabel[indexPath.section][indexPath.item])
        selectedSkillList.reloadData()
    }
    
    
    func getCellForAccordionType(_ accordionType: TypeOfAccordianView, accordionView: MKAccordionView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch accordionType {
            
            case .Classic :
              let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
              //cell?.imageView = UIImageView(image: UIImage(named: "lightGrayBarWithBluestripe"))
              
              // Background view
              let bgView : UIView? = UIView(frame: CGRect(x:0, y:0, width: accordionView.bounds.width, height: 50))
              let bgImageView : UIImageView! = UIImageView(image: UIImage(named: "lightGrayBarWithBluestripe"))
              bgImageView.frame = (bgView?.bounds)!
              bgImageView.contentMode = .scaleToFill
              bgView?.addSubview(bgImageView)
              cell.backgroundView = bgView
              
              // You can assign cell.selectedBackgroundView also for selected mode
              
              cell.textLabel?.text = innerLabel[indexPath.section][indexPath.item]
              return cell
          
            case .Formal :
              let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
                
                
                // You can assign cell.selectedBackgroundView also for selected mode
                
            cell.textLabel?.text = innerLabel[indexPath.section][indexPath.item]
              cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
              return cell
        }
        
    }
}

