//
//  BookingCollectionViewCell.swift
//  PerfectSelf
//
//  Created by user232392 on 3/23/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import UIKit

class BookingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    @IBAction func JoinMeeting(_ sender: UIButton) {
        print("join")
    }
    
    @IBAction func SendMessage(_ sender: UIButton) {
        print("send message")
    }
    
    @IBAction func CancelBooking(_ sender: UIButton) {
        print("Cancel booking")
    }
}
