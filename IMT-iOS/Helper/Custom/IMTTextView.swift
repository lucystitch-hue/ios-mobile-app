//
//  IMTTextView.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import Foundation
import UIKit

@IBDesignable
class IMTTextView: UITextView {
    
    let defaultFontWeight: IMTFontWeight = .medium
    let defaultFontStyleSize: IMTFontStyleSize = .normal
    var fontWeight: IMTFontWeight! {
        didSet {
            setupFont(size: fontStyleSize, weight: fontWeight)
        }
    }
    var fontStyleSize: IMTFontStyleSize! {
        didSet {
            setupFont(size: fontStyleSize, weight: fontWeight)
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: Interface Builder
    ///Font weight
    @IBInspectable
    var boldWeight: Bool {
        get {
            return fontWeight == .bold
        }
        
        set {
            fontWeight = newValue ? .bold : defaultFontWeight
        }
    }
    
    @IBInspectable
    var semiBoldWeight: Bool {
        get {
            return fontWeight == .semiBold
        }
        
        set {
            fontWeight = newValue ? .semiBold : defaultFontWeight
        }
    }
    
    @IBInspectable
    var mediumWeight: Bool {
        get {
            return fontWeight == .medium
        }
        
        set {
            fontWeight = newValue ? .medium : defaultFontWeight
        }
    }
    
    @IBInspectable
    var normalWeight: Bool {
        get {
            return fontWeight == .normal
        }
        
        set {
            fontWeight = newValue ? .normal : defaultFontWeight
        }
    }
    
    @IBInspectable
    var lightWeight: Bool {
        get {
            return fontWeight == .light
        }
        
        set {
            fontWeight = newValue ? .light : defaultFontWeight
        }
    }
    
    @IBInspectable
    var extraLightWeight: Bool {
        get {
            return fontWeight == .extraLight
        }
        
        set {
            fontWeight = newValue ? .extraLight : defaultFontWeight
        }
    }
    
    @IBInspectable
    var thinWeight: Bool {
        get {
            return fontWeight == .thin
        }
        
        set {
            fontWeight = newValue ? .thin : defaultFontWeight
        }
    }
    
    
    ///Font style size
    @IBInspectable
    var largestSize: Bool {
        get {
            return fontStyleSize == .largest
        }
        
        set {
            fontStyleSize = newValue ? .largest : defaultFontStyleSize
        }
    }
    
    @IBInspectable
    var largerSize: Bool {
        get {
            return fontStyleSize == .larger
        }
        
        set {
            fontStyleSize = newValue ? .larger : defaultFontStyleSize
        }
    }
    
    @IBInspectable
    var largeSize: Bool {
        get {
            return fontStyleSize == .large
        }
        
        set {
            fontStyleSize = newValue ? .large : defaultFontStyleSize
        }
    }
    
    @IBInspectable
    var mediumSize: Bool {
        get {
            return fontStyleSize == .medium
        }
        
        set {
            fontStyleSize = newValue ? .medium : defaultFontStyleSize
        }
    }
    
    @IBInspectable
    var normalSize: Bool {
        get {
            return fontStyleSize == .normal
        }
        
        set {
            fontStyleSize = newValue ? .normal : defaultFontStyleSize
        }
    }
    
    @IBInspectable
    var smallSize: Bool {
        get {
            return fontStyleSize == .small
        }
        
        set {
            fontStyleSize = newValue ? .small : defaultFontStyleSize
        }
    }
    
    @IBInspectable
    var tinySize: Bool {
        get {
            return fontStyleSize == .tiny
        }
        
        set {
            fontStyleSize = newValue ? .tiny : defaultFontStyleSize
        }
    }
    
    @IBInspectable
    var fontSize: CGFloat = IMTFontStyleSize.normal.rawValue {
        didSet {
            let fontStyleSize = IMTFontStyleSize(rawValue: fontSize)
            setupFont(size: fontStyleSize, weight: fontWeight)
        }
    }
}

extension IMTTextView {
    private func commonInit() {
        guard let fontName = self.font?.fontName else { return }
        guard let size = self.font?.pointSize.autoScale() else { return }
        
        self.font = UIFont(name: fontName, size: size)
        self.heightConstraint?.constant = (self.heightConstraint?.constant.autoScale())!
        
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
    }
    
    private func setupFont(size: IMTFontStyleSize?, weight: IMTFontWeight?) {
        guard let fontSize = size?.rawValue,
              let fontFamily = weight?.rawValue else { return }
        
        self.font = UIFont(name: fontFamily, size: CGFloat(fontSize))
    }
}
