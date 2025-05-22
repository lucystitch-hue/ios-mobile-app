//
//  ResponseLogin.swift
//  IMT-iOS
//
//  Created by dev on 12/04/2023.
//

import Foundation
import SwiftyJSON

protocol IPatDataModel: DataModel {
    var iPatId1: String? { get set }
    var iPatId2: String? { get set }
    var iPatPass1: String? { get set }
    var iPatPass2: String? { get set }
    var iPatPars1: String? { get set }
    var iPatPars2: String? { get set }
    var ysnFlg1: String? { get set }
    var ysnFlg2: String? { get set }
}

protocol PersonDataModel: DataModel {
    var userId: String { get set }
    var birthday: String { get set }
    var sex: String { get set }
    var job: String { get set }
    var postCode: String { get set }
    var racingStartYear: String { get set }
    var serviceType: String? { get set }
    var dayOff: String? { get set }
    var regisReason: String? { get set }
}

protocol UserDataModel: PersonDataModel, IPatDataModel {
    var email: String { get set }
    var userKbn: String? { get set }
    
    func getUserRole() -> UserRole
}

extension UserDataModel {
    func getUserRole() -> UserRole {
        guard let userKbn = userKbn else { return .manual }
        return UserRole(rawValue: userKbn) ?? .manual
    }
}

struct LoginDataModel: UserDataModel {
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
}

struct ResponseLogin: BaseResponse {
    
    typealias R = ResponseLogin
    
    var success: Bool
    var message: String?
    
    var siteUserId: String?
    var parsNo: String?
    var pinCode: String?
    
    var expiredAt: String?
    var data: LoginDataModel?
}
