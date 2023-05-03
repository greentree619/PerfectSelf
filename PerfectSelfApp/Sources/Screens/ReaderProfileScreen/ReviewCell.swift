//
//  ReviewCell.swift
//  PerfectSelf
//
//  Created by user232392 on 4/19/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {

    @IBOutlet weak var img_avatar: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var text_review: UITextView!
    @IBOutlet weak var lbl_score: UILabel!
    @IBOutlet weak var lbl_reviewDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
