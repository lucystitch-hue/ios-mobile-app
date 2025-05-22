//
//  IMTBorderButton.swift
//  IMT-iOS
//
//  Created by dev on 11/03/2023.
//

import UIKit

class IMTBorderButton: IMTButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init(frame: CGRect = .zero, 
         borderColor: UIColor,
         borderWidth: CGFloat = 2,
         autoRadius: Bool = true) {
        super.init(frame: frame)
        self.borderColor = borderColor
        self.borderWith = borderWidth
        self.useAutoRadius = autoRadius
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.autoRadius = self.useAutoRadius
    }
    
    @IBInspectable
    var borderWith: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    private var useAutoRadius = true
}

extension IMTBorderButton {
    private func commonInit() {
        
    }
}
