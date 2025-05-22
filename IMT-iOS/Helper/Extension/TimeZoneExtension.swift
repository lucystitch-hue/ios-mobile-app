//
//  TimeZoneExtension.swift
//  IMT-iOS
//
//  Created by Hoang Do on 29/11/2023.
//

import Foundation

extension TimeZone {
    private struct Constants {
        static let UTCZoneIdentifier = "UTC"
    }
    
    public static func UTCTimeZone() -> TimeZone? {
        return TimeZone(identifier: Constants.UTCZoneIdentifier)
    }
}
