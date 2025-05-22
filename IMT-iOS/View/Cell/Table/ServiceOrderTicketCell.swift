//
//  ServiceOrderTicketCell.swift
//  IMT-iOS
//
//  Created by dev on 14/03/2023.
//

import UIKit

protocol ServiceOrderTicketCellDelegate {
    func serviceOrderTicketFromQRCode(_ cell: ServiceOrderTicketCell)
    func serviceOrderTicketOnline(_ cell: ServiceOrderTicketCell)
}

class ServiceOrderTicketCell: UITableViewCell {

    public var delegate: ServiceOrderTicketCellDelegate?
    
    static let identifier = "ServiceOrderTicketCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //MARK: Action
    @IBAction func actionOrderQRCode(_ sender: Any) {
        delegate?.serviceOrderTicketFromQRCode(self)
    }
    
    
    @IBAction func actionOrderOnline(_ sender: Any) {
        delegate?.serviceOrderTicketOnline(self)
    }
}
