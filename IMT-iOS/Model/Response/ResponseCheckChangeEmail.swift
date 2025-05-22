//
//  ResponseCheckChangeEmail.swift
//  IMT-iOS
//
//  Created by dev on 27/09/2023.
//

struct ResponseCheckChangeEmail: BaseResponse {
    typealias R = ResponseCheckChangePass
    var success: Bool
    var message: String?
}
