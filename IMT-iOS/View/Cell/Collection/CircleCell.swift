//
//  CircleCell.swift
//  IMT-iOS
//
//  Created by dev on 24/04/2023.
//

import UIKit

class CircleCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    static let identifier = "CircleCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setup(_ image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
    }
    
    public func setup(_ image: UIImage?, title: String?) {
        guard let image = image else { return }
        imageView.image = image
        self.lblTitle.text = title
    }
}
