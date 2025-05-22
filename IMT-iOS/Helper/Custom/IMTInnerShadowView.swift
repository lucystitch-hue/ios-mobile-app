//
//  IMTInnerShadowView.swift
//  IMT-iOS
//
//  Created by dev on 16/05/2023.
//

import Foundation
import UIKit

class IMTInnerShadowView: IMTView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.addInnerShadow()
    }
    
    private func addInnerShadow() {
        let innerShadow = CALayer()
        
        innerShadow.frame = self.bounds
        let radius = self.layer.cornerRadius
        let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: 1, dy:1), cornerRadius:radius)
        let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()
        
        path.append(cutout)
        innerShadow.shadowPath = path.cgPath
        innerShadow.masksToBounds = true
        
        innerShadow.shadowColor = UIColor.black.cgColor
        innerShadow.shadowOffset = CGSize(width: 0, height: 0)
        innerShadow.shadowOpacity = 0.3
        innerShadow.shadowRadius = 1
        innerShadow.cornerRadius = self.layer.cornerRadius
        layer.addSublayer(innerShadow)
    }
}
