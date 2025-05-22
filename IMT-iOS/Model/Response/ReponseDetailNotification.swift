//
//  ReponseDetailNotification.swift
//  IMT-iOS
//
//  Created by dev on 20/06/2023.
//

import Foundation
import SwiftyJSON

struct DetailNotificationModel:DataModel {
    var sendDate: String?
    var message: String?
    var title: String?
    var url: String?
}

struct ReponseDetailNotification: BaseResponse {
    typealias R = ReponseDetailNotification
    
    var success: Bool
    var message: String?
    var data: [DetailNotificationModel]?
    
}
