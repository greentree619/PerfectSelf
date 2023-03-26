//
//  ChatCardCollectionViewCell.swift
//  PerfectSelf
//
//  Created by user232392 on 3/25/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ChatCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_unviewednum: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_message: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
