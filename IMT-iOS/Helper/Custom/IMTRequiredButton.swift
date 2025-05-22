//
//  IMTRequiredButton.swift
//  IMT-iOS
//
//  Created by dev on 01/06/2023.
//

import Foundation
import UIKit

class IMTRequiredButton: IMTButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public var filled: Bool! {
        didSet {
            onChange(filled)
        }
    }
}

//MARK: Private
extension IMTRequiredButton {
    private func commonInit() {
        self.filled = false
    }
    
    private func onChange(_ filled: Bool) {
        let backgroundColor: UIColor = filled ? .spanishOrange : .americanSilver
        self.backgroundColor = backgroundColor
        self.isUserInteractionEnabled = filled
    }
}
