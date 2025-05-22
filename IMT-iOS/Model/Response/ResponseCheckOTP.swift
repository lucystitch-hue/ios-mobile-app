//
//  ResponseCheckOTP.swift
//  IMT-iOS
//
//  Created by dev on 09/06/2023.
//

import UIKit

struct CheckOTPDataModel: DataModel {
    var userId: String?
}

struct ResponseCheckOTP: BaseResponse {
    typealias R = ResponseCheckOTP
    
    var success: Bool
    var message: String?
    var data: CheckOTPDataModel?
}
