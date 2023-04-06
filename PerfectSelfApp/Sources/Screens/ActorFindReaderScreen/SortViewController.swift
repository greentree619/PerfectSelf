//
//  SortViewController.swift
//  PerfectSelf
//
//  Created by user232392 on 4/6/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {
    @IBOutlet weak var btn_relevance: UIButton!
    @IBOutlet weak var btn_pricehightolow: UIButton!
    @IBOutlet weak var btn_pricelowtohigh: UIButton!
    @IBOutlet weak var btn_soonest: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func tapCallback(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    @IBAction func SaveToApply(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    @IBAction func SelectRelevance(_ sender: UIButton) {
        btn_relevance.tintColor = UIColor(rgb: 0x4383C4)
        btn_pricehightolow.tintColor = .black
        btn_pricelowtohigh.tintColor = .black
        btn_soonest.tintColor = .black
    }
    
    @IBAction func SelectPriceHighToLow(_ sender: UIButton) {
        btn_relevance.tintColor = .black
        btn_pricehightolow.tintColor = UIColor(rgb: 0x4383C4)
        btn_pricelowtohigh.tintColor = .black
        btn_soonest.tintColor = .black
    }
    @IBAction func SelectPriceLowToHigh(_ sender: UIButton) {
        btn_relevance.tintColor = .black
        btn_pricehightolow.tintColor = .black
        btn_pricelowtohigh.tintColor = UIColor(rgb: 0x4383C4)
        btn_soonest.tintColor = .black
    }
    @IBAction func SelectAvailableSoonest(_ sender: UIButton) {
        btn_relevance.tintColor = .black
        btn_pricehightolow.tintColor = .black
        btn_pricelowtohigh.tintColor = .black
        btn_soonest.tintColor = UIColor(rgb: 0x4383C4)
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
