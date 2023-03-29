//
//  VideoCollectionViewCell.swift
//  PerfectSelf
//
//  Created by user232392 on 3/24/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tapeThumb: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        print("play")
    }
    
    @IBAction func editVideo(_ sender: UIButton) {
        print("edit")
    }
}
