//
//  TrainingRaceCell.swift
//  IMT-iOS
//
//  Created by dev on 27/04/2023.
//

import UIKit

class TrainingRaceCell: UITableViewCell {
    
    @IBOutlet weak var imvTrainingRace: UIImageView!
    
    static let identifier = "TrainingRaceCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setup(image:UIImage!) {
        imvTrainingRace.image = image
    }
    
}
