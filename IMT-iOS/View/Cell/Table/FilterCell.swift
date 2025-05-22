//
//  FilterCell.swift
//  IMT-iOS
//
//  Created on 18/03/2024.
//
    

import UIKit

class FilterCell: UITableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    
    var viewModel: FilterCellViewModel! {
        didSet {
            bind()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    private func bind() {
        stackView.removeAllSubviews()
        
        for i in 0...3 {
            guard let item = viewModel.items.safeObjectForIndex(index: i) else {
                let view = UIView()
                stackView.addArrangedSubview(view)
                
                continue
            }
            let view = CheckBoxView.instantiateView()
            view.type = item
            view.onChecked = { [weak self] type, selected in
                self?.viewModel.handleChecked(type: type, selected: selected)
            }
            stackView.addArrangedSubview(view)
        }
    }
    
}
