//
//  RectangleCell.swift
//  IMT-iOS
//
//  Created by dev on 24/04/2023.
//

import UIKit

class RectangleCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    
    static let identifier = "RectangleCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setup(_ image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
    }
}
