//
//  OverlayViewContoller.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/27/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import WebRTC

class OverlayViewController: UIViewController {
    init() {
        super.init(nibName: String(describing: OverlayViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    }
    
    @IBAction func backDidTap(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
}
