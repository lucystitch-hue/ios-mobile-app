//
//  ServiceImageCell.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import UIKit

class ServiceImageCell: UITableViewCell {

    @IBOutlet weak var imvBackgound: UIImageView!
    
    static let identifier = "ServiceImageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    //MARK: Public
    public func setup(image: UIImage?) {
        self.imvBackgound.image = image
    }
}
