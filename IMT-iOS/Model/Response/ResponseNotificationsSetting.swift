//
//  ResponseNotificationsSetting.swift
//  IMT-iOS
//
//  Created by dev on 19/06/2023.
//

import UIKit
struct NotificationsSettingDataModel: DataModel {
    var torikeshi: String?
    var jogai:String?
    var kisyu:String?
    var jikoku:String?
    var baba:String?
    var weather:String?
    var umaWeight:String?
    var harai: String?
    var utokubetsu:String?
    var mokuden:String?
    var yokuden: String?
    var thisWeek: String?
    var news: String?
    var favTokubetsu: String?
    var favYokuden: String?
    var favHarai: String?
    var favJoc: String?
}

struct ResponseNotificationsSetting: BaseResponse {
    typealias R = ResponseNotificationsSetting
    
    var success: Bool
    var message: String?
    var data: NotificationsSettingDataModel?
}
