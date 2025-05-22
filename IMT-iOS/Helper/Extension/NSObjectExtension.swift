//
//  NSObjectExtension.swift
//  IMT-iOS
//
//  Created on 26/01/2024.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
