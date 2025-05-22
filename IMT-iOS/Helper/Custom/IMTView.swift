//
//  IMTView.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import Foundation
import UIKit

class IMTView: UIView {
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var useTransform: Bool {
        get {
            return flagTransform
        }
        set {
            if(newValue) {
                self.configTransformView( self)
            }
            
            flagTransform = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private var flagTransform: Bool = false
    
    private var flagAutoRadius: Bool = false
}

extension IMTView {
    private func commonInit() {
        self.heightConstraint?.constant = (heightConstraint?.constant.autoScale())!
        self.widthConstraint?.constant = (widthConstraint?.constant.autoScale())!
    }
    
    private func configTransformView( _ vContent : UIView){
        let degrees: CGFloat = -15.0
        let radians = degrees * CGFloat.pi / 180.0
        let transform = CGAffineTransform(rotationAngle: radians)
        vContent.transform = transform
    }
}
