//
//  IMTLabel.swift
//  IMT-iOS
//
//  Created by dev on 11/03/2023.
//

import UIKit

@IBDesignable
class IMTLabel: UILabel {
    
    //MARK: Properties
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
    private var flagRequire: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: Interface Builder
    @IBInspectable
    var redText: String? {
        didSet {
            if let text = redText {
                setRedLabel(text, self)
            }
        }
    }
    
    @IBInspectable
    var require: Bool {
        get {
            return flagRequire
        }
        
        set {
            flagRequire = newValue
            setAttributRequire(show: flagRequire)
        }
    }
    
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
    
    @IBInspectable
    var isAutoScaleOnSmallDevice: Bool = false {
        didSet {
            if(isAutoScaleOnSmallDevice) {
                self.font = UIFont(name: self.font.fontName, size: self.font.pointSize.autoScale())
            }
        }
    }
}

//MARK: Private
extension IMTLabel {
    
    private func commonInit() {
        self.fontAutoScale = true
    }
    
    private func setRedLabel(_ text : String , _ label : UILabel! ){
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: text.count - 1, length: 1))
        label.attributedText = attributedString
        
    }
    
    private func setAttributRequire(_ symbol: String = "*", show: Bool = true) {
        let texts = text?.components(separatedBy: symbol)
        guard let text = texts?.first else { return }
        
        var attrs = NSMutableAttributedString(string: text)
        
        if(show) {
            let attrSymbol = NSAttributedString(string: symbol, attributes:[NSAttributedString.Key.foregroundColor: UIColor.red])
            attrs.append(attrSymbol)
        } else {
            attrs = NSMutableAttributedString(string: text)
        }
        
        self.attributedText = attrs
    }
    
    private func setupFont(size: IMTFontStyleSize?, weight: IMTFontWeight?) {
        guard let fontSize = size?.rawValue,
              let fontFamily = weight?.rawValue else { return }
        
        self.font = UIFont(name: fontFamily, size: CGFloat(fontSize))
    }
}
