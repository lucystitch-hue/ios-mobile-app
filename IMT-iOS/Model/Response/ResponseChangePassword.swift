//
//  ResponseChangePassword.swift
//  IMT-iOS
//
//  Created by dev on 12/06/2023.
//

import Foundation
import SwiftyJSON

struct ResponseChangePassword: BaseResponse {
    typealias R = ResponseChangePassword
    
    var success: Bool
    var message: String?
}
