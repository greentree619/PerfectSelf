//
//  ActorFindReaderViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ActorFindReaderViewController: UIViewController {

    @IBOutlet weak var modal_sort: UIView!
    @IBOutlet weak var modal_filter: UIView!
    @IBOutlet weak var btn_filter: UIButton!
    @IBOutlet weak var btn_sort: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let r = UIImage(named: "reader");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        modal_sort.alpha = 0;
        modal_filter.alpha = 0;
        
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
    @IBAction func SortReaders(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
           self.modal_sort.alpha = 1;
        };

    }

    @IBAction func FilterReaders(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.modal_filter.alpha = 1;
        };
    }
    
    @IBAction func SortApply(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            self.modal_sort.alpha = 0;
        };
        
    }
    
    @IBAction func FilterApply(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            self.modal_filter.alpha = 0;
        };
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
