//
//  HorseAndJockeyCell.swift
//  IMT-iOS
//
//  Created on 15/03/2024.
//
    

import UIKit

class HorseAndJockeyCell: UITableViewCell {
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var imgRadioButton: UIImageView!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbSex: UILabel!
    @IBOutlet weak var cstLeft: NSLayoutConstraint!
    
    var viewModel: HorseAndJockeyCellViewModel! {
        didSet {
            bind()
        }
    }
    
    var showRadioButton: Bool = false {
        didSet {
            imgRadioButton.isHidden = !showRadioButton
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func bind() {
        lbTitle.text = viewModel.title
        lbSex.isHidden = viewModel.sex == nil
        lbSex.text = viewModel.sex
        cstLeft.constant = CGFloat(viewModel.leftPadding)
        imgRadioButton.image = (viewModel.selected ?? false) ? .icSelectRadioButton : .icUnselectRadioButton
        stackView.removeAllSubviews()
        let badgeReversed = viewModel.badge.reversed().map { $0 }
        for i in (0...(viewModel.maximumBadge - 1)).reversed() {
            if let (text, color) = badgeReversed.safeObjectForIndex(index: i) {
                let view = BadgeView(frame: .zero)
                view.textLabel.text = text
                view.textLabel.textColor = .white
                view.backgroundColor = color
                view.textLabel.font = UIFont.appFontW6Size(10)
                view.textInsets = UIEdgeInsets.init(top: 3, left: 8, bottom: 3, right: 8)
                view.setContentHuggingPriority(.required, for: .horizontal)
                view.setContentCompressionResistancePriority(.required, for: .horizontal)
                stackView.addArrangedSubview(view)
            } else {
                let view = BadgeView(frame: .zero)
                view.textLabel.text = "Entered"
                view.textLabel.font = UIFont.appFontW6Size(10)
                view.makeEmpty()
                view.textInsets = UIEdgeInsets.init(top: 3, left: 8, bottom: 3, right: 8)
                view.setContentHuggingPriority(.required, for: .horizontal)
                view.setContentCompressionResistancePriority(.required, for: .horizontal)
                stackView.addArrangedSubview(view)
            }
        }
    }
}
