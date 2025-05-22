//
//  ItemStakingTBCell.swift
//  IMT-iOS
//
//  Created by dev on 08/03/2023.
//

import UIKit

class TopicCell: UITableViewCell {
    
    @IBOutlet weak var lblPlace: IMTLabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbGrade: UILabel!
    @IBOutlet weak var vBackgroundGrade: UIView!
    @IBOutlet weak var vBackgroundPlace: UIView!
    
    static let identifier: String = "TopicCell"
    static let height: Float = Float(Utils.scaleWithHeight(32.5))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    public func setup(_ topic: TopicModel?) {
        guard let topic = topic else { return }
        self.lblPlace.text = topic.place
        self.vBackgroundPlace.backgroundColor = topic.placeColor()
        self.lbDate.attributedText = topic.dateToAttribute()
        self.lbName.text = topic.name.trimmingCharacters(in: .whitespaces)
        self.lbGrade.text = topic.gradeNameToString()
        self.vBackgroundGrade.backgroundColor = topic.gradeColor()
    }
}
