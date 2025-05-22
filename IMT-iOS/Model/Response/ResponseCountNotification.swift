//
//  ReponseCountNotification.swift
//  IMT-iOS
//
//  Created by dev on 16/06/2023.
//

import Foundation

struct CountNotificationDataModel: DataModel {
    var count: Int?
}

struct ResponseCountNotification: BaseResponse {
    typealias R = ResponseCountNotification
    
    var success: Bool
    var message: String?
    var data: CountNotificationDataModel?

}
