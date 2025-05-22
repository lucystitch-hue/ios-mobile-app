//
//  WarningViewModel.swift
//  IMT-iOS
//
//  Created by dev on 22/09/2023.
//

import Foundation
import UIKit

class WarningViewModel: BaseViewModel {
    
    var title: NSAttributedString
    var description: NSAttributedString
    var textBorderedButton: NSAttributedString
    var textFilledButton: NSAttributedString
    var image: UIImage
    var themeColor: [UIColor]
    var imageHeight: CGFloat
    var space: CGFloat?
    
    init(_ type: WarningType) {
        self.title = type.title()
        self.description = type.attributedString()
        self.textBorderedButton = type.textBorderedButton()
        self.textFilledButton = type.textFilledButton()
        self.image = type.image()
        self.themeColor = type.theme()
        self.imageHeight = type.imageHeight()
        self.space = type.space()
        self.space = type.space()
    }
    
}
