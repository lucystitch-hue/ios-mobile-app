//
//  ResponseSendOTP.swift
//  IMT-iOS
//
//  Created by dev on 09/06/2023.
//

import UIKit

protocol OTPDataModel: DataModel {
    var userId: String! { get set }
    var factorId: String? { get set }  //Case #1: User does not verify OTP any times
    var requestId: String? { get set }  //Case #2: User verified OTP but not complete the registration flow
    var requestState:String! { get set }
}

struct SendOTPDataModel: OTPDataModel {
    var userId: String!
    var factorId: String?
    var requestId: String?
    var requestState: String!
}

struct ResponseSendOTP: BaseResponse {
    typealias R = ResponseSendOTP
    
    var success: Bool
    var message: String?
    var data: SendOTPDataModel?
}
