//
//  NotificationCell.swift
//  IMT-iOS
//
//  Created by dev on 24/03/2023.
//

import UIKit

class NotificationCell: UITableViewCell {

    
    @IBOutlet weak var lblContent: IMTLabel!
    @IBOutlet weak var lblRead: IMTLabel!
    @IBOutlet weak var lblDate: IMTLabel!
    @IBOutlet weak var vBackgroundRead: IMTView!
    
    @IBOutlet weak var cstWidthBackgroundRead: NSLayoutConstraint!
    
    static let identifier = "NotificationCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setHiddenRead(true)
    }
    
    public func setup(_ notification: NotificationModel?) {
        guard let notification = notification else { return }
        
        self.lblContent.text = notification.title
        self.lblDate.attributedText = notification.sendDate?.attributeNotificationDateHour()
        let isRead = notification.status == "1"
        setHiddenRead(isRead)
    }
}

//MARK: Private
extension NotificationCell {
    private func setHiddenRead(_ hidden: Bool) {
        self.vBackgroundRead.isHidden = hidden
        self.cstWidthBackgroundRead.constant = Utils.scaleWithHeight(hidden ? 0 : 50)
    }
    
    private func convertNotifyDate(_ date: String) -> String {
        return date
    }
}
