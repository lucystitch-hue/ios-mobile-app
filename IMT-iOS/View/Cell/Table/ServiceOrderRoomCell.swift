//
//  ServiceViewCell.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import UIKit

protocol ServiceOrderRoomCellDelegate {
    func didManageAccount(cell: ServiceOrderRoomCell, atIndex: Int)
    func didShowAnswer(cell: ServiceOrderRoomCell, atIndex: Int)
}

class ServiceOrderRoomCell: UITableViewCell {
    @IBOutlet weak var vBackground: UIView!
    
    var delegate: ServiceOrderRoomCellDelegate?
    var index: Int!
    
    static let identifier = "ServiceOrderRoomCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.vBackground.cornerRadius(radius: Constants.RadiusConfigure.medium)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Action
    @IBAction func actionManageAccount(_ sender: Any) {
        self.delegate?.didShowAnswer(cell: self, atIndex: index)
    }
    
    @IBAction func actionAnswer(_ sender: Any) {
        self.delegate?.didShowAnswer(cell: self, atIndex: index)
    }
    
    //MARK: Public
    public func setup(atIndex index: Int, asDelegate delegate: ServiceOrderRoomCellDelegate) {
        self.index = index
        self.delegate = delegate
        self.vBackground.setShadow()
    }
}
