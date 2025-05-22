//
//  ReponseReadNotification.swift
//  IMT-iOS
//
//  Created by dev on 19/06/2023.
//

import Foundation
import SwiftyJSON

struct ReponseReadNotification: BaseResponse {
    typealias R = ReponseReadNotification
    
    var success: Bool
    var message: String?
    var data: [NotificationModel]?
}
