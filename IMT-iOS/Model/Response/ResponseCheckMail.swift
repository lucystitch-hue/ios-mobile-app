//
//  ResonseCheckMail.swift
//  IMT-iOS
//
//  Created by dev on 01/06/2023.
//

import Foundation

struct CheckMailDataModel: OTPDataModel {
    var userId: String!
    var factorId: String?
    var requestId: String?
    var requestState:String!
}

struct ResponseCheckMail: BaseResponse {
    typealias R = ResponseCheckMail
    var success: Bool
    var message: String?
    var data: CheckMailDataModel?
}
