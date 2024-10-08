//
//  ReaderTabBarController.swift
//  PerfectSelf
//
//  Created by user232392 on 3/14/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
import UIKit
import JJFloatingActionButton

class ReaderTabBarController: UITabBarController {
//    let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet);
    var uid = ""
    var items = [TimeSlot]()
    var skills = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
            // Use the saved data
            uid = userInfo["uid"] as! String
        } else {
            // No data was saved
            print("No data was saved.")
        }
        tabBar.tintColor = .white;
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.67);
        tabBar.isTranslucent = false;
        UITabBar.appearance().backgroundColor = UIColor(rgb: 0x7587D9)
        setupVCs();
  
        // Add floating button
        let actionButton = JJFloatingActionButton()
        actionButton.addItem(title: "Add Availability", image: UIImage(systemName: "plus.circle")) { item in
          // do something
            self.getReaderInfoAndNavigate(to: 1)// 1: nav to availability screen
        }
        actionButton.addItem(title: "Add Skills", image: UIImage(systemName: "plus.circle")) { item in
          // do something
            self.getReaderInfoAndNavigate(to: 2)// 2: nav to skill screen
        }

        actionButton.buttonDiameter = 50;
        actionButton.overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5);
        actionButton.buttonColor =  UIColor(rgb: 0x7587D9);
      
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true;
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        
        if let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let
           tabBarItem = arrayOfTabBarItems[2] as? UITabBarItem {
           tabBarItem.isEnabled = false
        }
        
    }
    func getReaderInfoAndNavigate(to: Int) {
        // call API for reader profile
        showIndicator(sender: nil, viewController: self)
        webAPI.getReaderById(id:self.uid) { data, response, error in
            DispatchQueue.main.async {
                hideIndicator(sender: nil)
            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let item = try JSONDecoder().decode(ReaderProfileDetail.self, from: data)
                DispatchQueue.main.async {
                    self.skills = item.skills.components(separatedBy: ",")
                    
                    self.items.removeAll()
                    for availibility in item.allAvailability {
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd"
                        let tf = DateFormatter()
                        tf.dateFormat = "HH"
                        
                        let index = self.items.firstIndex(where: { df.string(from: Date.getDateFromString(date: $0.date)!) == df.string(from: Date.getDateFromString(date: utcToLocal(dateStr: availibility.date)!)!) })
                        if index == nil {
                            self.items.append(TimeSlot(date: utcToLocal(dateStr: availibility.date)!, time: [Slot](), repeatFlag: 0, isStandBy: false))
                        }
                        let idx = index ?? self.items.count - 1
                        
                        let t = tf.string(from: Date.getDateFromString(date: utcToLocal(dateStr: availibility.fromTime)!)!)
                        
                        var slot = 0
                        switch t {
                        case "09":
                            slot = 1
                        case "10":
                            slot = 2
                        case "11":
                            slot = 3
                        case "14":
                            slot = 4
                        case "15":
                            slot = 5
                        case "16":
                            slot = 6
                        case "17":
                            slot = 7
                        case "18":
                            slot = 8
                        case "19":
                            slot = 9
                        case "20":
                            slot = 10
                        case "21":
                            slot = 11
                        case "22":
                            slot = 12
                        default:
                            slot = 0
                        }
                        self.items[idx].time.append(Slot(id: availibility.id, slot: slot, duration: 0, isDeleted: false))
                    }
                    self.items = self.items.sorted(by: { Date.getDateFromString(date: $0.date)! < Date.getDateFromString(date: $1.date)! })
                    
                    if to == 1 {
                        let controller = ReaderProfileEditAvailabilityViewController()
                        controller.uid = self.uid
                        controller.timeSlotList = self.items
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: false, completion: nil)
                    }
                    else if to == 2 {
                        let controller = ReaderProfileEditSkillViewController()
                        controller.uid = self.uid
                        controller.items = self.skills
                        controller.modalPresentationStyle = .fullScreen
                        self.present(controller, animated: false, completion: nil)
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    hideIndicator(sender: nil);
                    Toast.show(message: "Something went wrong. try again later", controller: self)
                }
            }
        }
    }
    fileprivate func createNavController(for rootViewController: UIViewController,
                                                    title: String,
                                                    image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
//        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        //navController.navigationBar.prefersLargeTitles = true
        // rootViewController.navigationItem.title = title
        return navController
      }
  
    func setupVCs() {
//        var fakeNC = UINavigationController(rootViewController: UIViewController());
//        fakeNC.isToolbarHidden = true;
//        fakeNC.isNavigationBarHidden = true;
        
        viewControllers = [
              createNavController(for: ReaderHomeViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "homekit")!),
              createNavController(for: ReaderBookingViewController(), title: NSLocalizedString("Chat", comment: ""), image: UIImage(systemName: "calendar")!),
              UINavigationController(rootViewController: UIViewController()),
              createNavController(for: MessageCenterViewController(), title: NSLocalizedString("Book", comment: ""), image: UIImage(named: "ellipsis.message")!),
              createNavController(for: ReaderProfileViewController(), title: NSLocalizedString("Profile", comment: ""), image: UIImage(systemName: "person")!)
        ];
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
