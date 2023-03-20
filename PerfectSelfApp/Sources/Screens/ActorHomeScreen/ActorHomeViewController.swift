//
//  ActorHomeViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import FSCalendar
import BDatePicker

class ActorHomeViewController: UIViewController {

    @IBOutlet weak var filtermodal: UIStackView!

    @IBOutlet weak var scrollView: UIScrollView!
 
    let r = UIImage(named: "reader");
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filtermodal.alpha = 0;
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
//        let num = 0...8
//
//        for i in num {
//            let iv = UIImageView()
//            iv.image = v;
//            iv.layer.masksToBounds = false;
//            iv.layer.shadowOpacity = 0.5;
//            iv.layer.shadowRadius = 5;
//            iv.layer.shadowOffset = CGSize(width: 5, height: 5);
//
//            if i%2 == 0 {
//                iv.frame = CGRect(x: 20, y:Int(scrollView.frame.width*0.5-10)*i/2, width:Int(scrollView.frame.width*0.5-30), height:Int(scrollView.frame.width*0.5-30))
//
//            }
//            else {
//                iv.frame = CGRect(x: Int(scrollView.frame.width*0.5+10), y:Int(scrollView.frame.width*0.5-10)*(i-1)/2, width:Int(scrollView.frame.width*0.5-30), height:Int(scrollView.frame.width*0.5-30))
//
//            }
//
//            containerView.addSubview(iv)
//        }
//
//        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: 800)
//
//        scrollView.addSubview(containerView)
//        scrollView.contentSize = containerView.frame.size
    }

    @IBAction func ShowFilterModal(_ sender: UIButton) {
        UIView.animate(withDuration:0.5) {
            self.filtermodal.alpha = 1;
        }
    }
    
    @IBAction func ApplyFilter(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5){
            self.filtermodal.alpha = 0;
        }
    }
    
    @IBAction func ApplyViewAll(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5){
            self.filtermodal.alpha = 0;
        }
    }
    
    @IBAction func CloseFilterModal(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5){
            self.filtermodal.alpha = 0;
        }
    }
    
    @IBAction func OnTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5){
            self.filtermodal.alpha = 0;
        }
    }
    
    @IBAction func ShowCalendar(_ sender: UIButton) {
        let _ = BDatePicker.show(on: self, handledBy: HandleDateDidChange)

        func HandleDateDidChange(to newDate: Date?)
         {
             guard let date = newDate else
             {
//               dateLabel.text = "nil"
                 print("nil");
                 return
             }
             print(date.description);
            //dateLabel.text = date.description
         }
//        CalendarViewController.present(
//                    initialView: self,
//                    delegate: self)
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
extension ActorHomeViewController: PopUpModalDelegate {
    func didTapCancel() {
        self.dismiss(animated: true)
    }

    func didTapAccept(){

    }
}
