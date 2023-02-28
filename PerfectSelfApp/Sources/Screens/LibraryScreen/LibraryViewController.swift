//
//  LibraryViewController.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/26/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import WebRTC

class LibraryViewController: UIViewController {
    init() {
        super.init(nibName: String(describing: LibraryViewController.self), bundle: Bundle.main)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
    }
    
    @IBAction func backDidTap(_ sender: UIButton)
    {
        self.dismiss(animated: false)
    }
}
