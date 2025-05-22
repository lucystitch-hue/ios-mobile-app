//
//  NotificationSettingsCell.swift
//  IMT-iOS
//
//  Created by dev on 24/03/2023.
//

import UIKit

class NotificationSettingsCell: UITableViewCell {
    
    @IBOutlet weak var lbTitle: IMTLabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    static let identifier = "NotificationSettingsCell"
    
    private var item: ISettingNotificationModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setup(_ item: ISettingNotificationModel?, atIndexPath indexPath: IndexPath) {
        guard let item = item else { return }
        self.item = item
        lbTitle.text = item.setting.title()
        btnSwitch.isOn = item.checked
    }
    
    @IBAction func actionSwitchSelection(_ sender: UISwitch) {
        item.checked = !item.checked
    }
    
}

//MARK: Private
extension NotificationSettingsCell {
    
}
