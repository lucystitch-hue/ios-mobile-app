//
//  LabelExtension.swift
//  IMT-iOS
//
//  Created by dev on 11/03/2023.
//

import Foundation
import UIKit

extension UILabel {
    
    @IBInspectable var fontAutoScale: Bool {
        get {
            return self.font.pointSize == Utils.scaleWithHeight(self.font.pointSize)
        }
        
        set {
            
        }
    }
    
    var isTruncated: Bool {
        guard let text = text, self.countLabelLines(text) > self.numberOfLines else { return false }
        return true
    }
    
    var contentSize: CGSize {
        guard let text = text as? NSString else { return CGSize.zero }
        let attributes = [NSAttributedString.Key.font : self.font]

        let labelSize = text.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        return labelSize.size
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
//        setMultipleFontSize()
    }
    
    func getSize(constrainedWidth: CGFloat) -> CGSize {
        return systemLayoutSizeFitting(CGSize(width: constrainedWidth, height: UIView.layoutFittingCompressedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func IMTAttributeTitle(_ value: String) {
        let attributedString = NSMutableAttributedString(string: value)
        
        let digitFont = UIFont.appFontNumberBoldSize(14)
        let textFont = UIFont.appFontW4Size(14)
        
        if let digitRange = value.range(of: "\\d+", options: .regularExpression),
            let textRange = value.range(of: "\\D+", options: .regularExpression) {

            attributedString.addAttribute(.font, value: digitFont, range: NSRange(digitRange, in: value))
            attributedString.addAttribute(.font, value: textFont, range: NSRange(textRange, in: value))
        }

        self.attributedText = attributedString
    }
    
    fileprivate func countLabelLines(_ text: String) -> Int {
        let myText = text as NSString
        let attributes = [NSAttributedString.Key.font : self.font]

        let labelSize = myText.boundingRect(with: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
    
    fileprivate func setMultipleFontSize() {
        if let attributedText = attributedText, attributedText.attributeCount(key: .font) > 1 {
            let newAttributeText = NSMutableAttributedString(attributedString: attributedText)
            attributedText.enumerateAttribute(.font, in: NSMakeRange(0, attributedText.length)) { value, range, _ in
                if let value = value as? UIFont {
                    newAttributeText.addAttribute(.font, value: value.withSize(value.pointSize.autoScale()), range: range)
                }
            }
            self.attributedText = newAttributeText
        } else {
            self.font = self.font.withSize(self.font.pointSize.autoScale())
        }
        
//        if (isTruncated) {
//            adjustsFontSizeToFitWidth = true
//            minimumScaleFactor = 0.9
//        }
    }
}
