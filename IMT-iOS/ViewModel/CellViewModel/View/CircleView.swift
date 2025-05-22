//
//  CircleView.swift
//  IMT-iOS
//
//  Created on 26/01/2024.
//
    

import UIKit

class CircleView: UIView {

    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var image: UIImageView!
    
    var type: MenuItemType! {
        didSet {
            bind()
        }
    }
    
    var onClick: ((MenuItemType) -> Void)?
    
    
    @IBAction func actionClick(_ sender: Any) {
        onClick?(type)
    }
    
    private func bind() {
        lbTitle.text = type.rawValue
        image.image = type.image()
    }

}
