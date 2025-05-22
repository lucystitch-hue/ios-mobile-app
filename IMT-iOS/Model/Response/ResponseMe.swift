//
//  ResponseMe.swift
//  IMT-iOS
//
//  Created by dev on 12/06/2023.
//

import UIKit

struct MeDataModel: UserDataModel {
    var userKbn: String?
    var userId: String
    var birthday: String
    var sex: String
    var job: String
    var postCode: String
    var racingStartYear: String
    var serviceType: String?
    var dayOff: String?
    var regisReason: String?
    var email: String
    var iPatId1: String?
    var iPatId2: String?
    var iPatPass2: String?
    var iPatPass1: String?
    var iPatPars2: String?
    var iPatPars1: String?
    var ysnFlg1: String?
    var ysnFlg2: String?
    
    public func toForm() -> FormUpdatePersonalInfo {
        var form = FormUpdatePersonalInfo()
        form.userId = userId
        form.birthday = birthday.decrypt()
        form.sex = sex
        form.job = job
        form.postCode = postCode.decrypt()
        form.racingStartYear = racingStartYear
        form.serviceType = serviceType
        form.regisReason = regisReason
        form.dayOff = dayOff
        form.email = email.decrypt()
        
        return form
    }
}

class ResponseMe: BaseResponse {
    typealias R = ResponseMe
    
    var success: Bool
    var message: String?
    var data: MeDataModel?
}
