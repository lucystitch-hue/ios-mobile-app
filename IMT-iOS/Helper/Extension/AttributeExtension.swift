//
//  AttributeExtension.swift
//  IMT-iOS
//
//  Created by dev on 28/07/2023.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func makeHyperlink(text: String, url: String, font: UIFont = .appFontW4Size(16)) -> NSAttributedString {
        var fullText = text
        fullText += " \(url)"
        let substringRange = NSRange(location: (text as NSString).length + 1, length: (url as NSString).length)
        let attributedString = NSMutableAttributedString(string: fullText, attributes: [NSAttributedString.Key.font: font])
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: substringRange)
        attributedString.addAttribute(.link, value: url, range: substringRange )
        return attributedString
    }
    
    func attributeCount(key: NSAttributedString.Key) -> Int {
        var count = 0
        self.enumerateAttribute(key, in: NSMakeRange(0, length)) { value, range, _ in
            count += 1
        }
        return count
    }
}
