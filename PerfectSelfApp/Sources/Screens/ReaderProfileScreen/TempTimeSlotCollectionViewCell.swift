//
//  TempTimeSlotCollectionViewCell.swift
//  PerfectSelf
//
//  Created by user232392 on 4/8/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit
protocol RemoveDelegate {
    func didRemoveTimeSlot(index: Int, repeatFlag: Int)
}
class TempTimeSlotCollectionViewCell: UICollectionViewCell {
    var delegate: RemoveDelegate?
    var index: Int!
    var repeatFlag: Int!
    @IBOutlet weak var timeslot: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func Remove(_ sender: UIButton) {
        self.delegate?.didRemoveTimeSlot(index: index, repeatFlag: repeatFlag)
    }
}
