//
//  RaceDateCLVCell.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import UIKit

class RaceDateCell: UICollectionViewCell {
    
    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var cstTopBackground: NSLayoutConstraint!
    
    static let identifier = "RaceDateCell"
    static let space = Utils.scaleWithHeight(9.0)
    static let borderWidth = 3.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow()
        vBackground.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: Constants.RadiusConfigure.medium)
    }
    
    public func setup(date: String?, isFocus: Bool, selectedColor: UIColor?, borderColor: UIColor?) {
        guard let date = date else { return }
        guard let selectedColor = selectedColor else { return }
        guard let borderColor = borderColor else { return }
        
        self.vBackground.layer.borderColor = borderColor.cgColor
        self.vBackground.layer.borderWidth = RaceDateCell.borderWidth
        
        lbDate.attributedText = date.toDate(IMTDateFormatter.IMTYYYYMMDD.rawValue)?.toAttributeIMTShort()
        updateUIWhenFocus(isFocus, selectedColor: selectedColor, textColor: borderColor)
    }
}

extension RaceDateCell {
    private func updateUIWhenFocus(_ isFocus: Bool, selectedColor: UIColor, textColor: UIColor) {
        if(isFocus) {
            self.cstTopBackground.constant = 0
            self.vBackground.backgroundColor = selectedColor
            self.lbDate.textColor = .white
        } else {
            self.cstTopBackground.constant = 4
            self.vBackground.backgroundColor = .white
            self.lbDate.textColor = textColor
        }
    }
}
