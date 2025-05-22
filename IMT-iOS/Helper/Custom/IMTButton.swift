//
//  IMTButton.swift
//  IMT-iOS
//
//  Created by dev on 11/03/2023.
//

import UIKit

@IBDesignable
class IMTButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private var flagShadow: Bool = false
    private var flagScale: Bool = false
    private var flagManualScaleImage: CGFloat = 0.75
    private var flagUseAutoRadius: Bool = false
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
    
    //MARK: Interface Builder
    @IBInspectable var useShadown: Bool {
        get {
            return flagShadow
        }
        set {
            if(newValue) {
                self.configButtonShadow(for: self, 20)
            }
            
            flagShadow = newValue
        }
    }
    
    @IBInspectable var autoScaleImage: Bool {
        get {
            return flagScale;
        }
        set {
            if(newValue) {
                configAutoScaleImage()
            }
            
            flagScale = newValue
        }
    }
    
    @IBInspectable var manualScaleImage: CGFloat {
        get {
            return self.flagManualScaleImage;
        }
        set {
            let wImage = self.bounds.size.width * newValue
            let hImage = self.bounds.size.height * newValue
            
            let imgVote = self.imageView?.image?.resizedImage(CGSize(width: wImage, height: hImage))
            self.setImage(imgVote, for: .normal)
            
            self.flagManualScaleImage = newValue
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
}

extension IMTButton {
    private func commonInit() {
//        guard let fontName = self.titleLabel?.font.fontName else { return }
//        guard let size = self.titleLabel?.font.pointSize.autoScale() else { return }
//        
//        self.titleLabel?.font = UIFont(name: fontName, size: size)
        self.heightConstraint?.constant = (self.heightConstraint?.constant.autoScale())!
    }
    
    private func configButtonShadow(for button: UIButton, _ cornerRadius:Int = 0  ) {
        button.layer.cornerRadius = CGFloat(Utils.scaleWithHeight(Double(cornerRadius)))
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOffset = CGSize(width: 0, height: Utils.scaleWithHeight(2.527))
        button.layer.shadowRadius = Utils.scaleWithHeight(3.0)
        button.layer.shadowOpacity = Float(Utils.scaleWithHeight(0.20))
    }
    
    private func configAutoScaleImage() {
        let imageResize = self.imageView?.image?.resizedImage(self.bounds.size)
        self.imageView?.image = imageResize
    }
    
    private func setupFont(size: IMTFontStyleSize?, weight: IMTFontWeight?) {
        guard let fontSize = size?.rawValue,
              let fontFamily = weight?.rawValue,
              let font = UIFont(name: fontFamily, size: CGFloat(fontSize)) else { return }
        
        self.titleLabel?.font = font
    }
}
