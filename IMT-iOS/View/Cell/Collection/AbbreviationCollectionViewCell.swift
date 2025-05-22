//
//  AbbreviationCollectionViewCell.swift
//  IMT-iOS
//
//  Created on 09/04/2024.
//
    

import UIKit

class AbbreviationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var container: UIView!
    @IBOutlet private weak var cstLeadingLabel: NSLayoutConstraint!
    @IBOutlet private weak var cstTopLabel: NSLayoutConstraint!
    
    static var identifier = "AbbreviationCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(title: String?, small: Bool, selected: Bool = false) {
        guard let title = title else { return }
        let attributedString = NSMutableAttributedString(string: "\(title)行")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        paragraphStyle.alignment = .center
        attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont.appFontW6Size(small ? 14 : 16), .foregroundColor: selected ? UIColor.white : UIColor.black], range: NSMakeRange(0, attributedString.length))
        attributedString.highlight(substring: title, with: [.foregroundColor: selected ? UIColor.white : UIColor.main, .font: UIFont.appFontW6Size(small ? 24 : 34)])
        lbTitle.attributedText = attributedString
        container.manualRadius = small ? 5 : 11
        container.shadownViewLogin = true
        container.backgroundColor = selected ? .main : .white
        cstLeadingLabel.constant = small ? 1 : 5
        cstTopLabel.constant = small ? 1 : 5
    }

}
