//
//  FootterLine.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import Foundation
import UIKit

class FooterLine: UIView {
    
    var paddingLeft: CGFloat = 10
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
extension FooterLine {
    func commonInit(paddingLeft: CGFloat, heightLine: CGFloat) {
        let vLine = UIView();
        vLine.translatesAutoresizingMaskIntoConstraints = false
        vLine.backgroundColor = .quickSilver
        self.addSubview(vLine);
        
        NSLayoutConstraint.activate([
            vLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: paddingLeft),
            vLine.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            vLine.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            vLine.heightAnchor.constraint(equalToConstant: heightLine)
        ])
    }
}
