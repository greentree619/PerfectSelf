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
//    @IBOutlet weak var modal_filter: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let r = UIImage(named: "reader");
    let backgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: false)
        modal_sort.alpha = 0;
//        modal_filter.alpha = 0;
        
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
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapReader))
            iv.addGestureRecognizer(tap)
            iv.isUserInteractionEnabled = true
            
            containerView.addSubview(iv)
        }
   
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 800)
        
        scrollView.addSubview(containerView)
        scrollView.contentSize = containerView.frame.size

    }
    @objc func tapReader() {
        let controller = ActorReaderDetailViewController()
        self.navigationController?.pushViewController(controller, animated: true)
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
    
//    @IBAction func FilterApply(_ sender: UIButton) {
//
//        UIView.animate(withDuration: 0.5) {
//            self.modal_filter.alpha = 0;
//        };
//    }
    
    @IBAction func GoBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
