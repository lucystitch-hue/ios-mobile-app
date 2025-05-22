//
//  CheckBoxView.swift
//  IMT-iOS
//
//  Created on 18/03/2024.
//
    

import UIKit

class CheckBoxView: UIView {
    
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var imgCheckBox: UIImageView!
    
    var onChecked: ((FilterItemType, Bool) -> Void)?
    
    var selected: Bool = false
    
    var type: FilterItemType! {
        didSet {
            bind()
        }
    }
    
    @IBAction func actionClick(_ sender: Any) {
        selected = !selected
        imgCheckBox.image = selected ? .icChecked : .icUnchecked
        onChecked?(type, selected)
    }
    
    private func bind() {
        lbTitle.text = type.rawValue
        selected = type.defaultValue()
        imgCheckBox.image = selected ? .icChecked : .icUnchecked
    }
}
