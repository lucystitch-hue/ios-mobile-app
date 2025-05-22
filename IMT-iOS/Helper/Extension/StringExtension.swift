//
//  StringExtension.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//


import Foundation
import UIKit
import SceneKit
import CryptoSwift

//MARK: Standard
extension String {
    var isASCII: Bool {
        return self.allSatisfy(\.isASCII)
    }
    
    var isNumbers: Bool {
        return self.allSatisfy(\.isNumber)
    }
    
    var isContainsUppercase: Bool {
        var isContainsUppercase = false
        let uppercase = CharacterSet.uppercaseLetters
        self.unicodeScalars.forEach {
            if (uppercase.contains($0)) {
                isContainsUppercase = true
            }
        }
        return isContainsUppercase
    }
    
    var isContainsLowercase: Bool {
        var isContainsLowercase = false
        let lowercase = CharacterSet.lowercaseLetters
        unicodeScalars.forEach {
            if (lowercase.contains($0)) {
                isContainsLowercase = true
            }
        }
        return isContainsLowercase
    }
    
    func defaultValue(_ value: String = "") -> String {
        if(self.isEmpty) {
            return value;
        }
        return self;
    }
    
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }
    
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }
    
    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func changeFormatTime() -> String {
        let listString = self.split(separator: " ")
        let dateString = listString[0]
        let listDate = dateString.split(separator: "-")
        let year = listDate[0]
        let month = listDate[1]
        let day = listDate[2]
        return "\(day)/\(month)/\(year) \(listString[1])"
    }
    
    func isVNCharacter() -> Bool {
        return matches("^[a-zA-Z]+$")
    }
    
    func isContainsSpecialCharacter() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9_-].*", options: [])
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) != nil
    }
    
    func convertToUnsign() -> String {
        var value: String = self.folding(options: .diacriticInsensitive,locale: Locale(identifier: "en-EN"))
        value = value.replace(target: "đ", withString: "d")
        return value
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func security(symbol: String = "*") -> String {
        let securityProtocol = String(repeating: symbol, count: 4)
        let securityValue = self.replacingOccurrences(of: self, with: securityProtocol)
        return securityValue
    }
    
    func toRGB() -> UIColor? {
        if(self.count == 9) {
            var i = 0;
            var red: String = ""
            var blue: String = ""
            var green: String = ""
            
            self.forEach { character in
                if(i <= 2) {
                    red.append(character)
                } else if(i <= 5) {
                    green.append(character)
                } else if(i <= 8) {
                    blue.append(character)
                }
                
                i += 1
            }
            
            guard let nRed = Float(red) else  { return nil }
            guard let nGreen = Float(green) else { return nil }
            guard let nBlue = Float(blue) else { return nil }
            
            return UIColor(displayP3Red: CGFloat(nRed / 255.0), green: CGFloat(nGreen / 255.0), blue: CGFloat(nBlue / 255.0), alpha: 1)
        }
        return nil
    }
    
    func hasHttpsPrefix() -> Bool {
        let pattern = #"https:\/\/"# //
        
        if let range = self.range(of: pattern, options: .regularExpression) {
            return range.lowerBound == self.startIndex
        }
        
        return false
    }
    
    func toValidURL() -> String {
        if(!self.hasHttpsPrefix()) {
            return "https://\(self)"
        }
        
        return self
    }
    
    func boolean() -> Bool {
        if self == "1" {
            return true
        }
        return false
    }
    
    func integer(_ defaultValue: Int = 0) -> Int {
        return Int(self) ?? defaultValue
    }
    
    func double(_ defaultValue: Double = 0) -> Double {
        return Double(self) ?? defaultValue
    }
}

//MARK: Number
extension String {
    func isNumber() -> Bool {
        return matches("^[0-9]+$");
    }
    
    func isNumber(limit: Int) -> Bool {
        return matches("^(^[0-9]{0,\(limit)})$");
    }
    
    func isDecimal(integralPart: Int, fractionalPart: Int) -> Bool{
        let value = self.replace(target: ",", withString: "")
        return value.matches("^(^[0-9]{0,\(integralPart)})*(\\.[0-9]{0,\(fractionalPart)})?$");
    }
    
    func rawNumber() -> String {
        return self.replace(target: ",", withString: "").replace(target: ".", withString: "");
    }
    
    func toNumber() -> NSNumber {
        let value = self.replace(target: ",", withString: "")
        return NSNumber(value: Double(value) ?? 0);
    }
    
    
    func toFloatNumber() -> NSNumber {
        return NSNumber(value: Double(self) ?? 0)
    }
    
    func isNonKatakanaOrNonHiragana() -> Bool {
        return matches("[^ぁ-んァ-ンーヴゔ]")
    }
}

//MARK: Date
extension String {
    func toDate(_ format: String = "dd/MM/yyyy", checkFull: Bool = true) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.localeIdentifier)
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let string = self.replace(target: ".0", withString: "")
        
        if let date = formatter.date(from: string) {
            return date
        } else if (!checkFull) {
            return nil
        }

        for iCase in IMTDateFormatter.allCases {
            formatter.dateFormat = iCase.rawValue;
            if let date = formatter.date(from: string) {
                return date
            }
        }
        
        return nil;
    }
    
    func toDate(_ format: IMTDateFormatter = .slashDate) -> Date? {
        return toDate(format.rawValue)
    }
    
    func format(with withFormat: String, to toFormat: String) -> String? {
        return toDate(withFormat)?.toString(format: toFormat)
    }
    
    func format(with withFormat:  IMTDateFormatter, to toFormat: IMTDateFormatter) -> String? {
        return self.format(with: withFormat.rawValue, to: toFormat.rawValue)
    }
    
    func toYear() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = IMTDateFormatter.IMTYYYY.rawValue
        dateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        if let year = dateFormatter.date(from: self) {
            let yearString = dateFormatter.string(from: year)
            return yearString
        } else {
            return nil
        }
    }
    
    func toMonth() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = IMTDateFormatter.IMTMM.rawValue
        dateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        if let month = dateFormatter.date(from: self) {
            let monthString = dateFormatter.string(from: month)
            return monthString
        } else {
            return nil
        }
    }
    
    func toDay() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = IMTDateFormatter.IMTDD.rawValue
        dateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        if let day = dateFormatter.date(from: self) {
            let dayString = dateFormatter.string(from: day)
            return dayString
        } else {
            return nil
        }
    }
    
    func toDateSeverCovert() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        dateFormatter.locale = Locale(identifier: Constants.localeIdentifier)
        dateFormatter.timeZone = TimeZone(identifier: "UTC")

        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    
    
    func toDateServer() -> String? {
        let value = self.toDate()?.toString(format: IMTDateFormatter.dashDateTime.rawValue);
        return value;
    }
    
    func toDateVN() -> String? {
        let value = self.toDate()?.toString(format: IMTDateFormatter.slashDate.rawValue);
        return value;
    }
    
    func attributeNotificationDateHour() -> NSAttributedString {
        let fromDate = self.toDateSeverCovert() ?? Date()

        let toDate = Date.sysdate()
        let days = fromDate.daysBetween(date: toDate, identifier: .japanese)
        
        var attrs = NSMutableAttributedString()
        
        if(days == 0) {
            var attrNumber: NSAttributedString!
            var attrLabel: NSAttributedString!
            
            let minutes = fromDate.minutesBetween(date: toDate, identifier: .japanese)
            
            if(minutes < 60) {
                attrNumber = NSAttributedString(string: "\(minutes)", attributes: [NSAttributedString.Key.font: UIFont.appFontNumberBoldSize(13)])
                attrLabel = NSAttributedString(string: .date.minutesBefore, attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(13)])
            } else {
                let hours = fromDate.hoursBetween(date: toDate, identifier: .japanese)
                
                attrNumber = NSAttributedString(string: "\(hours)", attributes: [NSAttributedString.Key.font: UIFont.appFontNumberBoldSize(13)])
                attrLabel = NSAttributedString(string: .date.hoursBefore, attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(13)])
            }
            
            attrs.append(attrNumber)
            attrs.append(attrLabel)
        } else if(days < 1) {
            let hours = fromDate.hoursBetween(date: toDate, identifier: .japanese)
            
            let attrNumber = NSAttributedString(string: "\(hours)", attributes: [NSAttributedString.Key.font: UIFont.appFontNumberBoldSize(13)])
            let attrLabel = NSAttributedString(string: .date.hoursBefore, attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(13)])
            
            attrs.append(attrNumber)
            attrs.append(attrLabel)
            
        } else if(days >= 1 || days <= 28) {
            let attrNumber = NSAttributedString(string: "\(days)", attributes: [NSAttributedString.Key.font: UIFont.appFontNumberBoldSize(13)])
            let attrLabel = NSAttributedString(string: .date.daysBefore, attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(13)])
            
            attrs.append(attrNumber)
            attrs.append(attrLabel)
        } else {
            let fmtDate = fromDate.toString(format: .IMTYY_M_D)
            
            attrs = NSMutableAttributedString(string: fmtDate, attributes: [NSAttributedString.Key.font: UIFont.appFontNumberBoldSize(13)])
        }
        
        return attrs
    }
}

//MARK: UIImage
extension String {
    func convertBase64StringToImage() -> UIImage? {
        guard let imageData = Data(base64Encoded: self), let image = UIImage(data: imageData) else { return nil }
        return image
    }
}

//MARK: Email
extension String {
    var isValidEmail: Bool {
        return matches("^\\s*+[A-Z0-9a-z-!#$%&'*+/=?^_`{|}~]{0,}(([A-Z0-9a-z-!#$%&'*+/=?^_`{|}~]+\\.){0,})+([A-Z0-9a-z-!#$%&'*+/=?^_`{|}~]{1,})+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,}+\\s*$")
    }
    
    ///Convert characters of username, mailServer to *
    ///Ex: admin@gmail.com -> *****@*****.com
    func mailSecurity() -> String? {
        let symbol = "@"
        let structure = self.components(separatedBy: symbol)
        
        guard let username = structure.first else { return nil }
        guard let domain = structure.last else { return nil }
        
        let domainSymbol = "."
        let domainStructure = domain.components(separatedBy: domainSymbol)
        guard let mailServer = domainStructure.first else { return nil }
        guard let com = domainStructure.last else { return nil }
        
        let securitySymbol = "*"
        
        let usernameProtocol = String(repeating: securitySymbol, count: username.count)
        let usernameSecurity = username.replacingOccurrences(of: username, with: usernameProtocol)
        
        let mailServerProtocol = String(repeating: securitySymbol, count: mailServer.count)
        let mailServerSecurity = mailServer.replacingOccurrences(of: mailServer, with: mailServerProtocol)
        
        let mailSecurity = "\(usernameSecurity)\(symbol)\(mailServerSecurity)\(domainSymbol)\(com)"
        return mailSecurity
    }
    
    func isValidPassword() -> Bool {
        let passwordPolicy = try? NSRegularExpression(pattern: "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?!.*\\W).{8,16}$", options: [])
        let passwordRange = NSRange(location: 0, length: self.utf16.count)
        
        return passwordPolicy?.firstMatch(in: self, options: [], range: passwordRange) != nil && self.range(of: "\\A\\p{ASCII}*\\z", options: .regularExpression) != nil
    }
    
    func allowedCharacterSet() -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")
        let enteredCharacterSet = CharacterSet(charactersIn: self)
        
        return allowedCharacterSet.isSuperset(of: enteredCharacterSet)
    }
}

//MARK: Web
extension String {
    func toBodyData() -> String? {
        let urlStructure = self.components(separatedBy: "?")
        if(urlStructure.count > 1) {
            let body = urlStructure[1]
            return body
        }
        
        return nil
    }
    
    func urlEncoded() -> String? {
        addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
    }
    
    func encode() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)
    }
    
    func decode() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

//MARK: Security
extension String {
    func encrypt() -> String {
        //It return raw string value instead of return string after encryption.
        if(Constants.System.enableEncrypt) {
            return self.aesEncrypt(key: Constants.System.saltKey)
        } else {
            return self
        }
    }
    
    func decrypt() -> String {
        //It return raw string value instead of return string after decryption.
        if(Constants.System.enableEncrypt) {
            return self.aesDecrypt(key: Constants.System.saltKey)
        } else {
            return self
        }
    }
    
    private func aesEncrypt(key: String) -> String {
        var result = ""
        do {
            let key: [UInt8] = Array(key.utf8) as [UInt8]
            let aes = try AES(key: key, blockMode: ECB(), padding: .pkcs5) // AES128 .ECB pkcs7
            let encrypted = try aes.encrypt(Array(self.utf8))
            result = encrypted.toBase64()
        } catch {
            return self
        }
        
        return result
    }
    
    private func aesDecrypt(key: String) -> String {
        var result = ""
        do {
            let encrypted = self
            let key: [UInt8] = Array(key.utf8) as [UInt8]
            let aes = try AES(key: key, blockMode: ECB(), padding: .pkcs5) // AES128 .ECB pkcs7
            let decrypted = try aes.decrypt(Array(base64: encrypted))
            result = String(data: Data(decrypted), encoding: .utf8) ?? self
        } catch {
            return self
        }
        
        return result
    }
}
