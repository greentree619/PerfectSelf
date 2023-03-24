//
//  ReaderCollectionViewCell.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/23/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class ReaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var readerAvatar: UIImageView!
    @IBOutlet weak var readerName: UILabel!
    @IBOutlet weak var availableDate: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var salary: UILabel!
   
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

}
