//
//  ResponseNotification.swift
//  IMT-iOS
//
//  Created by dev on 24/03/2023.
//

import UIKit
import SwiftyJSON

struct NotificationModel: JSONModel {
    
    var sendDate: String?
    var messageCode: String?
    var title: String?
    var status: String?
    
    init(json: JSON) {
        self.sendDate = json["sendDate"].string
        self.messageCode = json["messageCode"].string
        self.title = json["title"].string
        self.status = json["status"].string
    }
}

struct ResponseNotification: BaseResponse {
    typealias R = ResponseNotification
    
    var success: Bool
    var message: String?
    var data: [NotificationModel]?
}
