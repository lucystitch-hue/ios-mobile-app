//
//  ITopFavoriteCell.swift
//  IMT-iOS
//
//  Created on 15/03/2024.
//
    

import UIKit

class ITopFavoriteCell: UITableViewCell {

    @IBOutlet weak var imvCrown: UIImageView!
    @IBOutlet weak var lblTop: IMTLabel!
    @IBOutlet weak var imvStar: UIImageView!
    @IBOutlet weak var lblTitle: IMTLabel!
    @IBOutlet weak var lblScore: IMTLabel!
    
    static let identifier = "ITopFavoriteCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    //MARK: Public
    public func setup(_ item: OshiUmaRanking?) {
        guard let item = item else { return }
        imvCrown.image = item.getCrownImage()
        lblTop.text = item.getCrownToString()
        imvStar.image = item.getStarImage()
        lblTitle.text = item.bna
        lblScore.text = item.getScoreToString()
    }
}
