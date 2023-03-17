//
//  ActorLibraryViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorLibraryViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    let v = UIImage(named: "video");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let containerView = UIView()
        let num = 0...8
        
        for i in num {
            let iv = UIImageView()
            iv.image = v;
            iv.layer.masksToBounds = false;
            iv.layer.shadowOpacity = 0.5;
            iv.layer.shadowRadius = 5;
            iv.layer.shadowOffset = CGSize(width: 5, height: 5);
            
            if i%2 == 0 {
                iv.frame = CGRect(x: 20, y:Int(scrollView.frame.width*0.5-10)*i/2, width:Int(scrollView.frame.width*0.5-30), height:Int(scrollView.frame.width*0.5-30))
                print(110*i)
            }
            else {
                iv.frame = CGRect(x: Int(scrollView.frame.width*0.5+10), y:Int(scrollView.frame.width*0.5-10)*(i-1)/2, width:Int(scrollView.frame.width*0.5-30), height:Int(scrollView.frame.width*0.5-30))
                print(110*(i-1))
            }
            
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
