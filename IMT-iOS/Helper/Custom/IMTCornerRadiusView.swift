//
//  IMTCornerRadiusView.swift
//  IMT-iOS
//
//  Created on 16/02/2024.
//
    

import Foundation

class IMTCornerRadiusView: IMTView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupRadiusIfNeed()
    }
    
    private func setupRadiusIfNeed() {
        if(autoRadius) {
            let radius = self.bounds.size.height * 0.5
            self.cornerRadius(radius: radius)
        }
    }
}
