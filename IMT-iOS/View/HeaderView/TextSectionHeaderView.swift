//
//  TextSectionHeaderView.swift
//  IMT-iOS
//
//  Created on 26/01/2024.
//
    

import UIKit

class TextSectionHeaderView: UITableViewHeaderFooterView {

    var sectionTitle: String? {
        set {
            titleLabel.text = newValue
            layoutIfNeeded()
        }
        get {
            return titleLabel.text
        }
    }
    
    var sectionTitleColor: UIColor? {
        set {
            titleLabel.textColor = newValue
            layoutIfNeeded()
        }
        get {
            return titleLabel.textColor
        }
    }
    
    var sectionTitleFont: UIFont? {
        set {
            titleLabel.font = newValue
            layoutIfNeeded()
        }
        get {
            return titleLabel.font
        }
    }
    
    var sectionTitleLeadingGap: CGFloat {
        set {
            cstLeading.constant = newValue
        }
        get {
            return cstLeading.constant
        }
    }
    
    var sectionTitleAligment: NSTextAlignment {
        set {
            titleLabel.textAlignment = newValue
        }
        get {
            return titleLabel.textAlignment
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var cstLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
