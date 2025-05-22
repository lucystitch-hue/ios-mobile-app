//
//  RacePlaceCell.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import UIKit

class RacePlaceCell: UICollectionViewCell {

    @IBOutlet weak var vBackground: UIView!
    @IBOutlet weak var lbPlace: UILabel!
    @IBOutlet weak var cstTopBackground: NSLayoutConstraint!
    
    static let identifier: String = "RacePlaceCell"
    static let space = Utils.scaleWithHeight(13.0)
    static let borderWidth = 3.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow()
        vBackground.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: Constants.RadiusConfigure.medium)
    }
    
    public func setup(place: String?, isFocus: Bool, selectedColor: UIColor?, borderColor: UIColor?) {
        guard let place = place else { return }
        guard let selectedColor = selectedColor else { return }
        guard let borderColor = borderColor else { return }
        
        self.vBackground.layer.borderColor = borderColor.cgColor
        self.vBackground.layer.borderWidth = RacePlaceCell.borderWidth
        
        lbPlace.text = place
        updateUIWhenFocus(isFocus, selectedColor: selectedColor, textColor: borderColor)
    }
}

extension RacePlaceCell {
    private func updateUIWhenFocus(_ isFocus: Bool, selectedColor: UIColor, textColor: UIColor) {
        if(isFocus) {
            self.vBackground.backgroundColor = selectedColor
            self.lbPlace.textColor = .white
            self.cstTopBackground.constant = 0.0
        } else {
            self.vBackground.backgroundColor = .white
            self.lbPlace.textColor = textColor
            self.cstTopBackground.constant = 8.0
        }
    }
}
