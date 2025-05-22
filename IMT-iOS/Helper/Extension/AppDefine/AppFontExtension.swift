//
//  AppFontExtension.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import Foundation
import UIKit

//MARK: AppDefine
extension UIFont {
    static func appFontW3Size(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Hiragino Sans W3", size: size) ?? self.systemFont(ofSize: size.autoScale());
    }
    
    static func appFontW4Size(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Hiragino Sans W4", size: size) ?? self.systemFont(ofSize: size.autoScale());
    }
    
    static func appFontW6Size(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Hiragino Sans W6", size: size) ?? self.systemFont(ofSize: size.autoScale());
    }
    
    static func appFontW7Size(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Hiragino Sans W7", size: size) ?? self.systemFont(ofSize: size.autoScale());
    }
    
    static func appFontNumberSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size) ?? self.systemFont(ofSize: size.autoScale());
    }
    
    static func appFontNumberBoldSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica Bold", size: size) ?? self.systemFont(ofSize: size.autoScale());
    }
}
