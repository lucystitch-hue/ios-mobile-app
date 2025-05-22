//
//  ResponseDeleteUser.swift
//  IMT-iOS
//
//  Created by dev on 13/06/2023.
//

import UIKit

struct ResponseDeleteUser: BaseResponse {
    typealias R = ResponseDeleteUser
    var success: Bool
    var message: String?
}
