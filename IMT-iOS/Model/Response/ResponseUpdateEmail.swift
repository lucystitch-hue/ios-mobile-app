//
//  ResponseUpdateEmail.swift
//  IMT-iOS
//
//  Created by dev on 31/08/2023.
//

import Foundation

struct UpdateMailDataModel: DataModel {
    
}

struct ResponseUpdateMail: BaseResponse {
    typealias R = ResponseDeleteUser
    var success: Bool
    var message: String?
    var data: UpdateMailDataModel?
}
