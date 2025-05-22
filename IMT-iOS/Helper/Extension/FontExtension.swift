//
//  FontExtension.swift
//  IMT-iOS
//
//  Created on 29/02/2024.
//
    

import Foundation
import UIKit

extension UIFont {

    static func swizzle() {
        method_exchangeImplementations(
                class_getInstanceMethod(self, #selector(getter: ascender))!,
                class_getInstanceMethod(self, #selector(getter: swizzledAscender))!
        )
        method_exchangeImplementations(
                class_getInstanceMethod(self, #selector(getter: lineHeight))!,
                class_getInstanceMethod(self, #selector(getter: swizzledLineHeight))!
        )
    }

    private var isHiragino: Bool {
        fontName.contains("Hiragino")
    }

    @objc private var swizzledAscender: CGFloat {
        if isHiragino {
            return self.swizzledAscender * 1.15
        } else {
            return self.swizzledAscender
        }
    }

    @objc private var swizzledLineHeight: CGFloat {
        if isHiragino {
            return self.swizzledLineHeight * 1.25
        } else {
            return self.swizzledLineHeight
        }
    }

}
