//
//  ISettingNotificationModel.swift
//  IMT-iOS
//
//  Created by dev on 24/03/2023.
//

import Foundation

class ISettingNotificationModel: CheckedModel {
    var setting: SettingsNotificationItem!
    var checked: Bool = false
    
    init(title: SettingsNotificationItem!, checked: Bool = false) {
        self.setting = title
        self.checked = checked
    }
    
    func getValue() -> String {
        return checked ? "1" : "0"
    }
}
