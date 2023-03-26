//
//  DateFormat.swift
//  PerfectSelf
//
//  Created by user232392 on 3/26/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
extension Date {

 static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        return dateFormatter.string(from: Date())

    }
}
