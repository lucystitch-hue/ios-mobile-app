//
//  ResponseCheckLoginWithPassword.swift
//  IMT-iOS
//
//  Created on 19/01/2024.
//

import Foundation

struct ResponseCheckLoginWithPassword: BaseResponse {
    typealias R = ResponseCheckLoginWithPassword
    var success: Bool
    var message: String?
    var data: String?
}
