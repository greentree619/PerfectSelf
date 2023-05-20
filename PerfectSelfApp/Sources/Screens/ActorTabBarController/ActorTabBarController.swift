//
//  ActorTabBarController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/13/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import JJFloatingActionButton
import MobileCoreServices

class ActorTabBarController: UITabBarController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var videoUrl: URL?
//    let alertController = UIAlertController(title: nil, message: "", preferredStyle: .actionSheet);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tabBar.tintColor = .white;
        tabBar.unselectedItemTintColor = .white.withAlphaComponent(0.67);
        tabBar.isTranslucent = false;
        UITabBar.appearance().backgroundColor = UIColor(rgb: 0x7587D9)
        setupVCs();
  
        // Add floating button
        let actionButton = JJFloatingActionButton()
        actionButton.addItem(title: "Create Slate", image: UIImage(systemName: "plus.circle")) { item in
          // do something
            
        }
        actionButton.addItem(title: "Create Self Tape", image: UIImage(systemName: "plus.circle")) { item in
            // do something
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
                print("captureVideoPressed and camera available.")

                let imagePicker = UIImagePickerController()

                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.mediaTypes = [kUTTypeMovie as String]
                imagePicker.allowsEditing = false

                imagePicker.showsCameraControls = true

                self.present(imagePicker, animated: true, completion: nil)
                Toast.show(message: "Start to create self tap.", controller:  self)
              } else {
                print("Camera not available.")
              }
        }

        actionButton.buttonDiameter = 50;
        actionButton.overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5);
        actionButton.buttonColor =  UIColor(rgb: 0x7587D9);
      
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
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
              createNavController(for: ActorHomeViewController(), title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "homekit")!),
              createNavController(for: ActorLibraryViewController(), title: NSLocalizedString("Library", comment: ""), image: UIImage(systemName: "book")!),
              UINavigationController(rootViewController: UIViewController()),
              createNavController(for: ActorBookingViewController(), title: NSLocalizedString("Book", comment: ""), image: UIImage(systemName: "calendar")!),
              createNavController(for: ActorProfileViewController(), title: NSLocalizedString("FindReader", comment: ""), image: UIImage(systemName: "person")!)
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
    
    //    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //        self.videoUrl = info[UIImagePickerController.InfoKey.mediaURL.rawValue] as! URL?
    //        print(self.videoUrl!)//let pathString = self.videoUrl?.relativePath
    //        Toast.show(message: "Video Url: \(self.videoUrl!)", controller:  self)
    //        //self.dismiss(animated: true, completion: nil)
    //    }
    func imagePickerController(  didFinishPickingMediaWithInfo info:NSDictionary!) {
        videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL?
        print(self.videoUrl!)//let pathString = self.videoUrl?.relativePath
        Toast.show(message: "Video Url: \(self.videoUrl!)", controller:  self)
        self.dismiss(animated: true, completion: nil)
        
//        //Then Upload video
//        let prefixKey = "\(getDateString())/self-tape/"
//        awsUpload.multipartUpload(filePath: self.videoUrl!, prefixKey: prefixKey){ error -> Void in
//            if(error == nil)
//            {
//                DispatchQueue.main.async {
//                    //Omitted hideIndicator(sender: nil)
//                    //Toast.show(message: "Completed to upload record files", controller: uiViewContoller!)
//                }
//                if let userInfo = UserDefaults.standard.object(forKey: "USER") as? [String:Any] {
//                    // Use the saved data
//                    let uid = userInfo["uid"] as! String
//
//                    webAPI.addLibrary(uid: uid, tapeName: "tapeName", bucketName: "video-client-upload-123456798", tapeKey: "\(prefixKey)\(self.videoUrl!.lastPathComponent)")
//                } else {
//                    // No data was saved
//                    print("No data was saved.")
//                }
//            }
//            else
//            {
//                DispatchQueue.main.async {
//                    //Omitted hideIndicator(sender: nil)
//                    Toast.show(message: "Failed to upload record files", controller: uiViewContoller!)
//                }
//            }
//        }
    }
}
