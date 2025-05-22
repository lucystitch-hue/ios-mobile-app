//
//  TextViewExtension.swift
//  IMT-iOS
//
//  Created on 08/07/2024.
//
    

import Foundation
import UIKit

extension UITextView {
    var textSize: CGSize {
        guard let text = text as? NSString, let font = self.font else { return CGSize.zero }
        let attributes = [NSAttributedString.Key.font : font]

        let labelSize = text.size(withAttributes: attributes)
        return labelSize
    }
}
