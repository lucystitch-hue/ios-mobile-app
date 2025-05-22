//
//  ResponseUpdateUser.swift
//  IMT-iOS
//
//  Created by dev on 11/06/2023.
//

import UIKit
struct UpdateUserDataModel: DataModel {
    var userId: String!
    var birthday: String!
    var sex: String!
    var job: String!
    var postCode: String!
    var racingStartYear: String?
    var serviceType: String?
    var regisReason: String?
    var dayOff: String?
    var createDate: String!
    var updateDate: String!
}

struct ResponseUpdateUser: BaseResponse {
    typealias R = ResponseUpdateUser
    
    var success: Bool
    var message: String?
    var data: UpdateUserDataModel?

}
