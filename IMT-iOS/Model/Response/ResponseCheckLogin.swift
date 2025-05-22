//
//  ResponseCheckLogin.swift
//  IMT-iOS
//
//  Created by dev on 01/09/2023.
//

import UIKit

struct ResponseCheckLogin: BaseResponse {
    typealias R = ResponseCheckLogin
    var success: Bool
    var message: String?
    var data: LoginDataModel?
}
