//
//  DateExtension.swift
//  IMT-iOS
//
//  Created by dev on 07/03/2023.
//

import Foundation
import UIKit

enum IMTDateFormatter: String, CaseIterable {
    case dashDateTime = "yyyy-MM-dd HH:mm:ss"
    case dashDate = "yyyy-MM-dd"
    case slashDateTime = "dd/MM/yyyy HH:mm:ss"
    case slashDate = "dd/MM/yyyy"
    case IMTM_D_EEE = "M/d(EEE)"
    case IMTYY_M_D = "yy/M/d"
    case IMTYYYYMMDD = "yyyyMMdd"
    case IMTHHMM = "HHmm"
    case IMTHHColonMM = "HH:mm"
    case IMTMMdd = "MMdd"
    case IMTyyyyMMddTimestamp = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    case IMTYYYYMD = "yyyyMd"
    case IMTMM = "MM"
    case IMTDD = "dd"
    case IMTYYYY = "yyyy"
    case IMTYYYYMMddhhMM = "yyyyMMddHHmm"
    case IMTYYYYMMddForwardSlash = "yyyy/MM/dd"
    case IMTYYYYMdhhMM = "yyyy/M/d H:m"
    case IMTYYYYMdhMM = "yyyy/M/d H:mm"
    case IMTMMSignaldd = "MM/dd"
    
}

extension Date {
    
    func toServer() -> String {
        return toString(format: .dashDate)
    }
    
    func toString(format fmt: IMTDateFormatter) -> String {
        return toString(format: fmt.rawValue)
    }
    
    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }
}

extension Date {

    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: Constants.localeIdentifier)
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
    
    func toAttributeIMTShort() -> NSAttributedString {
        let date = self.toString(format: "M/d")
        let day = self.toString(format: "(EEE)");
        
        let attrs = NSMutableAttributedString()
        let attrDate = NSAttributedString(string: date, attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(12)])
        let attrDay = NSAttributedString(string: day, attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(12)])
        
        attrs.append(attrDate)
        attrs.append(attrDay)
        
        return attrs
    }
    
    func startOfMonth() -> Date {
        var components = Calendar.currentUTC.dateComponents([.year,.month], from: self)
        components.day = 1
        let firstDateOfMonth: Date = Calendar(identifier: .gregorian).date(from: components)!
        return firstDateOfMonth
    }
    
    func endOfMonth() -> Date {
        return Calendar.currentUTC.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func beginningOfDay() -> Date {
        return Calendar.currentUTC.startOfDay(for: self)
    }
    
    func endOfDay() -> Date {
        return Calendar.currentUTC.date(byAdding: .day, value: 1, to: self.beginningOfDay())?.addingTimeInterval(-1) ?? self
    }
    
    func nextDay() -> Date {
        return Calendar.currentUTC.date(byAdding: .day, value: 1, to: self) ?? self
    }
    
    func previousDay() -> Date {
        return Calendar.currentUTC.date(byAdding: .day, value: -1, to: self) ?? self
    }
    
    func addMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.currentUTC.date(byAdding: .month, value: numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeMonths(numberOfMonths: Int) -> Date {
        let endDate = Calendar.currentUTC.date(byAdding: .month, value: -numberOfMonths, to: self)
        return endDate ?? Date()
    }
    
    func removeYears(numberOfYears: Int) -> Date {
        let endDate = Calendar.currentUTC.date(byAdding: .year, value: -numberOfYears, to: self)
        return endDate ?? Date()
    }
    
    func getHumanReadableDayString() -> String {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let calendar = Calendar(identifier: .gregorian).component(.weekday, from: self)
        return weekdays[calendar - 1]
    }
    
    func timeSinceDate(fromDate: Date) -> String {
        let earliest = self < fromDate ? self  : fromDate
        let latest = (earliest == self) ? fromDate : self
    
        let components:DateComponents = Calendar(identifier: .gregorian).dateComponents([.minute,.hour,.day,.weekOfYear,.month,.year,.second], from: earliest, to: latest)
        let year = components.year  ?? 0
        let month = components.month  ?? 0
        let week = components.weekOfYear  ?? 0
        let day = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        let seconds = components.second ?? 0
        
        
        if year >= 2{
            return "\(year) years ago"
        }else if (year >= 1){
            return "1 year ago"
        }else if (month >= 2) {
             return "\(month) months ago"
        }else if (month >= 1) {
         return "1 month ago"
        }else  if (week >= 2) {
            return "\(week) weeks ago"
        } else if (week >= 1){
            return "1 week ago"
        } else if (day >= 2) {
            return "\(day) days ago"
        } else if (day >= 1){
           return "1 day ago"
        } else if (hours >= 2) {
            return "\(hours) hours ago"
        } else if (hours >= 1){
            return "1 hour ago"
        } else if (minutes >= 2) {
            return "\(minutes) minutes ago"
        } else if (minutes >= 1){
            return "1 minute ago"
        } else if (seconds >= 3) {
            return "\(seconds) seconds ago"
        } else {
            return "Just now"
        }
        
    }
    
    func daysBetween(date: Date, identifier: Calendar.Identifier = .gregorian) -> Int {
        return Date.between(start: self, end: date, type: .day, identifier: identifier)
    }
    
    func hoursBetween(date: Date, identifier: Calendar.Identifier = .gregorian) -> Int {
        return Date.between(start: self, end: date, type: .hour, identifier: identifier)
    }
    
    func minutesBetween(date: Date, identifier: Calendar.Identifier = .gregorian) -> Int {
        return Date.between(start: self, end: date, type: .minute, identifier: identifier)
    }
    
    func secondsBetween(date: Date, identifier: Calendar.Identifier = .gregorian) -> Int {
        return Date.between(start: self, end: date, type: .second, identifier: identifier)
    }
    
    func getYear() -> Int {
        return Calendar.currentUTC.component(.year, from: self)
    }
    
    func getMonth() -> Int {
        return Calendar.currentUTC.component(.month, from: self)
    }
    
    func getDay() -> Int {
        return Calendar.currentUTC.component(.day, from: self)
    }
    
    func getHour() -> Int {
        return Calendar.currentUTC.component(.hour, from: self)
    }
    
    func getYears(range: Int) -> [Int] {
        let currentYear = getYear()
        let fromYear = currentYear - range
        return (fromYear...currentYear).map({ return $0 })
    }
    
    func getAge(format: IMTDateFormatter, identifier: NSCalendar.Identifier = .gregorian) -> Int? {
        let birthday = self
        let now = Date.japanDate
        
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: identifier)
        let calendarAge = calendar.components(.year, from: birthday, to: now, options: [])
        let age = calendarAge.year
        return age
    }
}

//MARK: Static
extension Date {
    static func between(start: Date, end: Date, type: Calendar.Component, identifier: Calendar.Identifier = .gregorian) -> Int {
        let dateComponents = Calendar(identifier: identifier).dateComponents([type], from: start, to: end)
        return dateComponents.value(for: type)!
    }
    
    static func sysdate() -> Date {
        var calendar = Calendar.current
        let components: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let curentComponents = calendar.dateComponents(components, from: Date())
        calendar.timeZone = TimeZone.UTCTimeZone()!
        let result = calendar.date(from: curentComponents)
        return result ?? japanDate
    }
    
    static func days(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count

        return numDays
    }
    
    static var japanDate: Date {
        let nowUTC = Date()
        guard let timeZone = TimeZone(abbreviation: "ICT") else { return nowUTC }
        let timeZoneOffset = Double(timeZone.secondsFromGMT(for: nowUTC))
        guard let japanDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else { return nowUTC }
        
        return japanDate
    }
}
