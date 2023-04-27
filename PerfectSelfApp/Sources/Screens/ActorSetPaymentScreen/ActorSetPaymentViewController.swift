//
//  ActorSetPaymentViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/15/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorSetPaymentViewController: UIViewController {

    var readerUid: String = ""
    var readerName: String = ""
    var bookingStartTime: String = ""
    var bookingEndTime: String = ""
    var bookingDate: String = ""
    var script: String = ""
    var scriptBucket: String = ""
    var scriptKey: String = ""
    
    @IBOutlet weak var paymentMethodView: UIStackView!
    let headerLabel = ["Credit & Debit Cards", "Skill Set 2", "Skill Set 3"]
    let innerLabel = [
        ["skill 11", "skill 12", "skill 13"],
        ["skill 21", "skill 22"],
        ["skill 31", "skill 32", "skill 33", "skill 34"]
    ]
    var typeOfAccordianView = TypeOfAccordianView.Formal
        

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         let accordionView = MKAccordionView(frame: CGRect(x: 0, y: 0, width: paymentMethodView.bounds.width, height: paymentMethodView.bounds.height))

        accordionView.delegate = self;
        accordionView.dataSource = self;
        accordionView.isCollapsedAllWhenOneIsOpen = true
        
        paymentMethodView.addSubview(accordionView);
    }

    @IBAction func DoCheckout(_ sender: UIButton) {
        let controller = ActorBookConfirmationViewController();

        controller.readerUid = readerUid
        controller.readerName = readerName
        controller.bookingStartTime = bookingStartTime
        controller.bookingEndTime = bookingEndTime
        controller.bookingDate = bookingDate
        controller.script = script
        controller.scriptBucket = self.scriptBucket
        controller.scriptKey = self.scriptKey
        controller.modalPresentationStyle = .fullScreen
        
//        let transition = CATransition()
//        transition.duration = 0.5 // Set animation duration
//        transition.type = CATransitionType.push // Set transition type to push
//        transition.subtype = CATransitionSubtype.fromRight // Set transition subtype to from right
//        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        self.present(controller, animated: false)
    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.5 // Set animation duration
        transition.type = CATransitionType.push // Set transition type to push
        transition.subtype = CATransitionSubtype.fromLeft // Set transition subtype to from right
        self.view.window?.layer.add(transition, forKey: kCATransition) // Add transition to window layer
        
        self.dismiss(animated: false)
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
extension ActorSetPaymentViewController : MKAccordionViewDelegate {

  func accordionView(_ accordionView: MKAccordionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        switch typeOfAccordianView {
            case .Classic :
                 return 50
            case .Formal :
            return 200
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
            return 0
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
          let view : UIView! = UIView(frame: CGRect(x: 0, y:0, width: accordionView.bounds.width, height:0))

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
//            view.backgroundColor = UIColor(red: 220.0/255.0, green: 221.0/255.0, blue: 223.0/255.0, alpha: 1.0)

            // Image before Home
          let bgImageView : UIImageView = UIImageView(frame: CGRect(x: 10, y:12, width:16, height:16))
//          let bgImageView : UIImageView = UIImageView(frame: CGRect(x: 5, y:16, width:11, height:8))
            bgImageView.image = UIImage(systemName: ( sectionOpen ? "record.circle" : "circle"))!
            bgImageView.tintColor = .black
//            bgImageView.image = UIImage(named: ( sectionOpen ? "favorites-pointer" : "favorites-pointer"))!
            view.addSubview(bgImageView)

            switch section {
            case 0:
                // icon image
                let icImageView : UIImageView = UIImageView(frame: CGRect(x: 36, y:12, width:24, height:16))
      //          let bgImageView : UIImageView = UIImageView(frame: CGRect(x: 5, y:16, width:11, height:8))
                icImageView.image = UIImage(systemName: "creditcard.fill")!
                icImageView.tintColor = .black
      //            bgImageView.image = UIImage(named: ( sectionOpen ? "favorites-pointer" : "favorites-pointer"))!
                  view.addSubview(icImageView)

                // Title Label
              let titleLabel : UILabel = UILabel(frame: CGRect(x: 70, y: 0, width: view.bounds.width - 160, height: view.bounds.height))
    //          let titleLabel : UILabel = UILabel(frame: CGRect(x: 23, y: 0, width: view.bounds.width - 120, height: view.bounds.height))
              titleLabel.text = headerLabel[section]
              titleLabel.textColor = UIColor.black
              titleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
            view.addSubview(titleLabel)
            case 1:
                let icImageView : UIImageView = UIImageView(frame: CGRect(x: 36, y:7, width:60, height:26))
      //          let bgImageView : UIImageView = UIImageView(frame: CGRect(x: 5, y:16, width:11, height:8))
                icImageView.image = UIImage(named: "apple")!
                icImageView.tintColor = .black
      //            bgImageView.image = UIImage(named: ( sectionOpen ? "favorites-pointer" : "favorites-pointer"))!
                  view.addSubview(icImageView)

            case 2:

                // icon image
                let icImageView : UIImageView = UIImageView(frame: CGRect(x: 36, y:7, width:60, height:26))
      //          let bgImageView : UIImageView = UIImageView(frame: CGRect(x: 5, y:16, width:11, height:8))
                icImageView.image = UIImage(named: "paypal")!
                icImageView.tintColor = .black
      //            bgImageView.image = UIImage(named: ( sectionOpen ? "favorites-pointer" : "favorites-pointer"))!
                  view.addSubview(icImageView)
            default:
                print("oops!")
            }

          return view
        }
    }

}

// MARK: - Implemention of MKAccordionViewDatasource method
extension ActorSetPaymentViewController : MKAccordionViewDatasource {

    func numberOfSectionsInAccordionView(_ accordionView: MKAccordionView) -> Int {
        return 3 //TODO: count of section array
    }

    func accordionView(_ accordionView: MKAccordionView, numberOfRowsIn section: Int) -> Int {
        return 1
    }

    func accordionView(_ accordionView: MKAccordionView , cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return getCellForAccordionType(typeOfAccordianView, accordionView: accordionView, cellForRowAt: indexPath)
    }

    func accordionView(_ accordionView: MKAccordionView, didSelectRowAt indexPath: IndexPath) {

        print("accordionView \(indexPath.section) \(indexPath.item)")
//        if items.contains(innerLabel[indexPath.section][indexPath.item]) {
//            return
//        }
//
//        items.append(innerLabel[indexPath.section][indexPath.item])
//        selectedSkillList.reloadData()
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
            
            let cell = accordionView.tableView?.dequeueReusableCell(withIdentifier: "Credit Card Cell", for: indexPath) as! CreditCardCell
            
//            cell.name.text = innerLabel[indexPath.section][indexPath.item]
            return cell
        
//              let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
//
//
//                // You can assign cell.selectedBackgroundView also for selected mode
//
//            cell.textLabel?.text = innerLabel[indexPath.section][indexPath.item]
//              cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.thin)
//              return cell
        }

    }
}

