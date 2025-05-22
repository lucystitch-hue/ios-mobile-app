//
//  ResponseSignup.swift
//  IMT-iOS
//
//  Created by dev on 27/06/2023.
//

import UIKit

struct SignupDataModel: PersonDataModel {
    var userId: String
    var birthday: String
    var sex: String
    var job: String
    var postCode: String
    var racingStartYear: String
    var serviceType: String?
    var dayOff: String?
    var regisReason: String?
}

struct ResponseSignup: BaseResponse {
    typealias R = ResponseSignup
    
    var success: Bool
    var message: String?
    var data: SignupDataModel?
}
