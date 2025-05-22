//
//  MenuItemCell.swift
//  IMT-iOS
//
//  Created on 26/01/2024.
//
    

import UIKit

class MenuItemCell: UITableViewCell {
    
    private struct Constants {
        static let scale: CGFloat = 0.25
    }
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var cstWidthStackView: NSLayoutConstraint!
    
    var viewModel: MenuItemCellViewModel! {
        didSet {
            bind()
        }
    }
    
    private func bind() {
        stackView.removeAllSubviews()
        
        for i in 0...3 {
            guard let item = viewModel.items.safeObjectForIndex(index: i) else {
                let view = UIView()
                stackView.addArrangedSubview(view)
                
                continue
            }
            let view = CircleView.instantiateView()
            view.type = item
            view.onClick = { [weak self] type in
                self?.viewModel.handleMenuItemTapped(type)
            }
            stackView.addArrangedSubview(view)
        }
    }
    
}
