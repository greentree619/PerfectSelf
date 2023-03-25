//
//  OverlayViewContoller.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 2/27/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//
import UIKit
import WebRTC
import Photos

class OverlayViewController: UIViewController {
    var uploadVideourl: URL?
    var count = 5
    var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
//        guard let url = uploadVideourl else { return }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @IBAction func backDidTap(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    
}

