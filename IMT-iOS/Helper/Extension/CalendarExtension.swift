//
//  CalendarExtension.swift
//  IMT-iOS
//
//  Created by dev on 13/12/2023.
//

import Foundation

extension Calendar {
    static var currentUTC: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        if let timeZone = TimeZone(identifier: "UTC") {
            calendar.timeZone = timeZone
        }
        return calendar
    }
}
