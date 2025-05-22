//
//  ISettingNotificationSectionModel.swift
//  IMT-iOS
//
//  Created by dev on 18/06/2023.
//

import Foundation

class ISettingNotificationSectionModel {
    let section: SettingsNotificationSection!
    let settings: [ISettingNotificationModel]!
    
    init(section: SettingsNotificationSection, settings: [ISettingNotificationModel]) {
        self.section = section
        self.settings = settings
    }
}
