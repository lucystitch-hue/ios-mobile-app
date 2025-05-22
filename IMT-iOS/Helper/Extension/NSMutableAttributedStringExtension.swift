//
//  NSMutableAttributedStringExtension.swift
//  IMT-iOS
//
//  Created on 21/02/2024.
//
    

import Foundation

extension NSMutableAttributedString {
    func highlight(substring: String, with attributes: [NSAttributedString.Key: Any]) {
        let string = self.string as NSString
        let range = string.range(of: substring)
        if range.length > 0 {
            self.addAttributes(attributes, range: range)
        }
    }
}
