//
//  ActorBookingViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBookingViewController: UIViewController {

    
    @IBOutlet weak var scrollView: UIScrollView!
    let r = UIImage(named: "reader");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let containerView = UIView()
        let num = 0...10
        for i in num {
            let iv = UIImageView()
          
            iv.image = r;
            iv.layer.masksToBounds = false;
            iv.layer.shadowOpacity = 0.5;
            iv.layer.shadowRadius = 5;
            iv.layer.shadowOffset = CGSize(width: 2, height: 5);
            iv.frame = CGRect(x: 20, y:120*i, width:Int(scrollView.frame.width-40), height:100)
            containerView.addSubview(iv)
        }
   
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 800)
        
        scrollView.addSubview(containerView)
        scrollView.contentSize = containerView.frame.size
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
