//
//  ISearchRecommendedCell.swift
//  IMT-iOS
//
//  Created on 14/03/2024.
//
    

import UIKit

class ISearchRecommendedCell: UITableViewCell {
    
    @IBOutlet weak var imvStar: UIImageView!
    @IBOutlet weak var lblObject: UILabel!
    @IBOutlet weak var lblSex: UILabel!
    
    static let identifier: String = "ISearchRecommendedCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    public func setup(_ item: OshiUma?) {
        guard let item = item else { return }
        lblObject.text = item.bna
        imvStar.image = getStarImage(item.getFavorite())
        lblSex.text = item.getGenderToString()
    }
}

//MARK: Private
extension ISearchRecommendedCell {
    private func getStarImage(_ favorite: Bool) -> UIImage? {
        return favorite ? .icStar : nil
    }
}
