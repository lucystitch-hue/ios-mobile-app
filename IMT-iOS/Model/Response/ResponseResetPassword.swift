//
//  ResponseResetPassword.swift
//  IMT-iOS
//
//  Created by dev on 12/06/2023.
//

import Foundation
import SwiftyJSON

struct ResponseResetPassword: BaseResponse {
    typealias R = ResponseResetPassword
    
    var success: Bool
    var message: String?
}
