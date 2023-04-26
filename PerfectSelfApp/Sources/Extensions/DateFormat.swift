//
//  DateFormat.swift
//  PerfectSelf
//
//  Created by user232392 on 3/26/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation
extension Date {

    static func getStringFromDate(date: Date) -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return dateFormatter.string(from: date)

    }
    static func getDateFromString(date: String) -> Date? {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        return dateFormatter.date(from: date)

    }
}
