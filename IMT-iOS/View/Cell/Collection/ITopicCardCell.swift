//
//  ITopicCardCell.swift
//  IMT-iOS
//
//  Created by dev on 06/06/2023.
//

import UIKit

class ITopicCardCell: UICollectionViewCell {

    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    static let identifier = "ITopicCardCell"
    
    public func setup(_ iTopic: ITopicCardModel) {
        imvIcon.image = iTopic.icon
        lblTitle.text = iTopic.label
    }

}
