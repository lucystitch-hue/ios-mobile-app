//
//  NewsCell.swift
//  IMT-iOS
//
//  Created by dev on 14/03/2023.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRemark: UILabel!
    @IBOutlet weak var vBackground: UIView!
    
    static let identifier = "NewsCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    public func setup(item: NewModel?) {
        guard let item = item else { return }
        self.lblDate.text = item.dateToString()
        self.lblTitle.text = item.title
        self.lblRemark.text = ""
        self.vBackground.isHidden = true
    }
}
