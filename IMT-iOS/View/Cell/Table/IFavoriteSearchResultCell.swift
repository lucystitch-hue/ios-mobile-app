//
//  IListFavoriteSearchResultCell.swift
//  IMT-iOS
//
//  Created on 15/03/2024.
//
    

import UIKit

class IFavoriteSearchResultCell: UITableViewCell {
    
    @IBOutlet weak var imvStar: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPlace: IMTButton!
    
    static let identifier = "IFavoriteSearchResultCell"
    
    var viewModel: IFavoriteSearchResultCellViewModel! {
        didSet {
            bind()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    //MARK: Public
    public func setup(_ item: OshiKishu?) {
        guard let item = item else { return }
        imvStar.image = getStarImage(item.getFavorite())
        lblTitle.text = item.jon
        
        if let place = W04JOEWKB(rawValue: item.joewkb) {
            btnPlace.setTitle(place.string, for: .normal)
            btnPlace.setTitleColor(place.color, for: .normal)
        }
    }
    
    private func bind() {
        setup(viewModel.jockey)
    }
}

//MARK: Private
extension IFavoriteSearchResultCell {
    private func getStarImage(_ favorite: Bool) -> UIImage? {
        return favorite ? .icStar : nil
    }
}
