//
//  ReponseSettingsNotification.swift
//  IMT-iOS
//
//  Created by dev on 15/06/2023.
//

import Foundation

struct ReponseSettingsNotification: BaseResponse {
    typealias R = ReponseSettingsNotification
    var success: Bool
    var message: String?
}
