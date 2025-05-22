//
//  ButtonExtension.swift
//  IMT-iOS
//
//  Created on 12/01/2024.
//

import Foundation
import UIKit

extension UIButton {
    
    convenience init(title: String, tag: Int) {
        self.init()
        self.setTitle(title, for: .normal)
        self.tag = tag
    }
    
    func setTitleWithoutAnimation(_ title: String?, for state: UIControl.State) {
        UIView.performWithoutAnimation {
            setTitle(title, for: state)
            layoutIfNeeded()
        }
    }
    
    func setAutoRadius() {
        self.autoRadius = true
    }
    
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        guard let font = self.titleLabel?.font else { return }
//        self.titleLabel?.font = font.withSize(font.pointSize.autoScale())
//        
//        if (titleLabel?.isTruncated ?? false) {
//            self.titleLabel?.adjustsFontSizeToFitWidth = true
//            self.titleLabel?.minimumScaleFactor = 0.9
//        }
//    }
}
