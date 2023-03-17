//
//  Item.swift
//  PerfectSelf
//
//  Created by user232392 on 3/15/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
import UIKit
class Item: UIView {
    let label: UILabel
    var tapCallback: (() -> Void)?

    init(frame: CGRect, labelText: String) {
        // Initialize the label with the input text
        label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 30))
        label.text = labelText

        super.init(frame: frame)

        // Add the label as a subview
        addSubview(label)

        // Set the background color of the view
        backgroundColor = UIColor.yellow

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
