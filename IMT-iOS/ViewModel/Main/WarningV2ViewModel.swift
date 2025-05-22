//
//  WarningV2ViewModel.swift
//  IMT-iOS
//
//  Created on 19/03/2024.
//
    

import Foundation
import UIKit

protocol WarningV2ViewModelProtocol {
    
    var onAction: ObservableObject<(isIntial: Bool?,tag: Int)> { get set }
    
    func generateButtons(_ stackView: UIStackView)
}

class WarningV2ViewModel: WarningV2ViewModelProtocol {
    private var type: WarningTypeV2!
    var onAction: ObservableObject<(isIntial: Bool?, tag: Int)> = ObservableObject<(isIntial: Bool?, tag: Int)>((true, -1))
    
    init(type: WarningTypeV2) {
        self.type = type
    }
}

//MARK: WarningV2ViewModelProtocol
extension WarningV2ViewModel {
    func generateButtons(_ stackView: UIStackView) {
        let titles = type.titleButtons()
        let borderColors = type.borderColorButtons()
        let backgroundColors = type.backgroundColorButtons()
        let buttonHeight = 40.0
        
        titles.enumerated().forEach { (index, title) in
            let borderColor = borderColors[index]
            let backgroundColor = backgroundColors[index]
            var button: UIButton!
            
            //TODO: Style
            if let borderColor = borderColor {
                button = IMTBorderButton(borderColor: borderColor)
                button.setAttributedTitle(title, for: .normal)
                button.backgroundColor = .clear
                button.layer.borderWidth = Constants.System.borderWidthOfIMTBorderButton
            } else if let backgroundColor = backgroundColor {
                button = IMTButton()
                button.setAttributedTitle(title, for: .normal)
                button.backgroundColor = backgroundColor
            }
            
            //TODO: Event
            button.tag = index
            button.addTarget(self, action: #selector(onTouchUpInSide), for: .touchUpInside)
            
            //TODO: Add to stack
            stackView.addArrangedSubview(button)
            
            //TODO: Setup height
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
            button.setAutoRadius()
        }
    }
    
    @objc func onTouchUpInSide(_ sender: UIButton) {
        let tag = sender.tag
        self.onAction.value = (false, tag)
    }
}
