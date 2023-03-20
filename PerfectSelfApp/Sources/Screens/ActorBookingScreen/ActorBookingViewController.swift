//
//  ActorBookingViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorBookingViewController: UIViewController {

    
    @IBOutlet weak var btn_upcoming: UIButton!
    @IBOutlet weak var btn_past: UIButton!
    @IBOutlet weak var btn_pending: UIButton!
    
    @IBOutlet weak var line_upcoming: UIImageView!
    @IBOutlet weak var line_pending: UIImageView!
    @IBOutlet weak var line_past: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    let r = UIImage(named: "book");
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        line_pending.isHidden = true
        line_past.isHidden = true
        
        let containerView = UIView()
        let num = 0...10
        for i in num {
            let iv = UIImageView()
            iv.image = r;
            iv.layer.masksToBounds = false;
            iv.layer.shadowOpacity = 0.3;
            iv.layer.shadowRadius = 3;
            iv.layer.shadowOffset = CGSize(width: 2, height: 3);
            iv.frame = CGRect(x: 0, y:120*i, width:Int(scrollView.frame.width), height:100)
            containerView.addSubview(iv)
        }
   
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 800)
        
        scrollView.addSubview(containerView)
        scrollView.contentSize = containerView.frame.size
//        let containerView = UIView()
//
//        let num = 0...10
//        for i in num {
//
//            let item = Item(frame: CGRect(x: 0, y:120*i, width:Int(scrollView.frame.width), height:100), labelText: "Booking History")
//            item.tapCallback = {
//                let controller = ActorReaderDetailViewController();
//
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
//
//            item.layer.masksToBounds = false;
//            item.layer.shadowOpacity = 0.5;
//            item.layer.shadowRadius = 5;
//            item.layer.shadowOffset = CGSize(width: 2, height: 5);
//            item.layer.cornerRadius = 10
//
//            containerView.addSubview(item)
//        }
//
//        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 1310)
//
//        scrollView.addSubview(containerView)
//        scrollView.contentSize = containerView.frame.size
    }

    @IBAction func ShowUpcomingBookings(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_pending.tintColor = .black
        btn_past.tintColor = .black
        line_upcoming.isHidden = false
        line_pending.isHidden = true
        line_past.isHidden = true
    }
    
    @IBAction func ShowPendingBookings(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_upcoming.tintColor = .black
        btn_past.tintColor = .black
        line_upcoming.isHidden = true
        line_pending.isHidden = false
        line_past.isHidden = true
    }
    
    @IBAction func ShowPastBookings(_ sender: UIButton) {
        sender.tintColor = UIColor(rgb: 0x4063FF)
        btn_upcoming.tintColor = .black
        btn_pending.tintColor = .black
        line_upcoming.isHidden = true
        line_pending.isHidden = true
        line_past.isHidden = false
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
