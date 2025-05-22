//
//  TextFieldExtension.swift
//  IMT-iOS
//
//  Created by dev on 16/06/2023.
//

import UIKit

extension UITextField {
    open override var textInputMode: UITextInputMode? {
        return UITextInputMode.activeInputModes.first(where: {
            if(self.keyboardType == .emailAddress) {
                return $0.primaryLanguage?.contains("en") ?? false
            } else {
                return $0.primaryLanguage?.contains("jp") ?? false
            }
        }) ?? super.textInputMode
    }
    
    func IMTPlaceholder(_ value: String) {
        let fontSize = getDefaultPlaceholderFontSize()
        
        let attributedString = NSAttributedString(string: value, attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.appFontW7Size(fontSize)
        ])
        
        self.attributedPlaceholder = attributedString
    }
}

extension UITextField {
    private func getDefaultPlaceholderFontSize() -> CGFloat {
        let scale = Utils.smallScreen()
        var placeholderFontSize: CGFloat = 13.0
        
        placeholderFontSize = scale ? placeholderFontSize.autoScale() : placeholderFontSize
        
        return placeholderFontSize
    }
}
