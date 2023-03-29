//
//  CreditCardCell.swift
//  PerfectSelf
//
//  Created by user232392 on 3/29/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
import AnimatedCardInput

class CreditCardCell: UITableViewCell {


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        /// cardNumberDigitsLimit: Indicates maximum length of card number. Defaults to 16.
        /// cardNumberChunkLengths: Indicates format of card number,
        ///                         e.g. [4, 3] means that number of length 7 will be split
        ///                         into two parts of length 4 and 3 respectively (XXXX XXX).
        /// CVVNumberDigitsLimit: Indicates maximum length of CVV number.
        let cardView = CardView(
            cardNumberDigitsLimit: 16,
            cardNumberChunkLengths: [4, 4, 4, 4],
            CVVNumberDigitsLimit: 3
        )
        contentView.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
