//
//  ReaderView.swift
//  PerfectSelf
//
//  Created by user232392 on 3/23/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation

import UIKit
class ReaderView: UIView {
    let lblName: UILabel
    let avatarView: UIImageView
    let lblAvailability: UILabel
    let lblAvailableTime: UILabel
    let divideView: UIImageView
    let starView: UIImageView
    let lblReview: UILabel
    let lblHourly: UILabel
    
    let avatar = UIImage(systemName: "person.fill")
    let star = UIImage(systemName: "star.fill")
    let divide = UIImage(named: "filter_divide")
    
    var tapCallback: (() -> Void)?

    init(frame: CGRect, name: String, hourlyPrice: Int) {
        // Initialize the label with the input text

        avatarView = UIImageView(frame: CGRect(x: 10, y: 10, width: frame.height-20, height: frame.height-20))
        avatarView.image = avatar
        lblName = UILabel(frame: CGRect(x: frame.height, y: 10, width: frame.width-frame.height, height: 30))
        lblName.text = name
        lblAvailability = UILabel(frame: CGRect(x: frame.height, y: 50, width: 100, height: 30))
        lblAvailability.text = "Available on"
        lblAvailableTime = UILabel(frame: CGRect(x: frame.height+120, y: 50, width: 100, height: 30))
        lblAvailableTime.text = "Feb 25, 6:00 PM"
        divideView = UIImageView(frame: CGRect(x: frame.height, y: 90, width: frame.width-frame.height-10, height: 1))
        divideView.image = divide
        starView = UIImageView(frame: CGRect(x: frame.height, y: 101, width: 20, height: 20))
        starView.image = star
        lblReview = UILabel(frame: CGRect(x: frame.height+25, y: 101, width: 50, height: 30))
        lblReview.text = "5.0 (13)"
        lblHourly = UILabel(frame: CGRect(x: frame.height+120, y: 101, width: 50, height: 30))
        lblHourly.text = "$\(hourlyPrice/4) / 15 mins"
        super.init(frame: frame)

        // Add the label as a subview
        addSubview(avatarView)
        addSubview(lblName)
        addSubview(lblAvailability)
        addSubview(lblAvailableTime)
        addSubview(starView)
        addSubview(lblReview)
        addSubview(avatarView)
        addSubview(lblHourly)
       
        // Set the background color of the view
        backgroundColor = UIColor(rgb: 0xE5E5E5)

        // Add a tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handleTap() {
        // Call the tapCallback closure if it exists
        tapCallback?()
    }
}
