//
//  HomeViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/27/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import WebRTC

class HomeViewController: UIViewController {
    
    init() {
        super.init(nibName: String(describing: HomeViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    }
    
    @IBAction func homeDidTap(_ sender: UIButton) {
    }
    
    @IBAction func libraryDidTap(_ sender: UIButton) {
    }
    
    @IBAction func scheduleDidTap(_ sender: Any) {
    }
    
    @IBAction func userDidTap(_ sender: UIButton) {
    }
}
