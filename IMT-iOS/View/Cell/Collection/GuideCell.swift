//
//  GuideCell.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import UIKit

class GuideCell: UICollectionViewCell {

    @IBOutlet weak var imvStep: UIImageView!
    @IBOutlet weak var lblStepDetail: UILabel!
    
    static let identifier = "GuideCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setup(guide: Guide) {
        imvStep.image = guide.image()
        lblStepDetail.text = guide.attrDetail()
    }

}
