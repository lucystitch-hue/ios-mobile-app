//
//  FooterDotLine.swift
//  IMT-iOS
//
//  Created by dev on 14/03/2023.
//

import Foundation
import UIKit

class FootterDotLine: UIView {
    
    var paddingLeft: CGFloat = 20
    var heightLine: CGFloat = Constants.HeightConfigure.smallFooterLine
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit(paddingLeft: paddingLeft, heightLine: heightLine)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit(paddingLeft: paddingLeft, heightLine: heightLine)
    }
    
    init(paddingLeft: CGFloat = 10, heightLine: CGFloat = Constants.HeightConfigure.smallFooterLine) {
        super.init(frame: .zero)
        self.paddingLeft = paddingLeft
        self.heightLine = heightLine
        
        commonInit(paddingLeft: paddingLeft, heightLine: heightLine)
    }
}

//MARK: Private
extension FootterDotLine {
    func commonInit(paddingLeft: CGFloat, heightLine: CGFloat) {
        let vLine = UIImageView(image: .bgDotLine);
        vLine.translatesAutoresizingMaskIntoConstraints = false
        vLine.backgroundColor = .clear
        self.addSubview(vLine);
        
        NSLayoutConstraint.activate([
            vLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddingLeft),
            vLine.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            vLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            vLine.heightAnchor.constraint(equalToConstant: heightLine)
        ])
    }
}
