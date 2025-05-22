//
//  Endpoint.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation
import Alamofire

enum EndPoint {
    case topics(_ currentDate: String = Date.sysdate().toServer())
    case oversea(_ currentDate: String = Date.sysdate().toServer())
    case currentRace(_ currrentDate: String = Date.sysdate().toServer())
    case news
    case login(_ form: FormLoginEmail? = nil)
    case registQR(bakenId: String = "")
    case deleteQR(bakenId: String = "")
    case multipleDeleteQR(bakenIds: String = "") //concat multiple IDs with “_” ex) 00012345_00034567_0016789
    case viewQR(bakenId: String = "")
    case listQR
    case holiday
    case registFCMToken
    case dropFCMToken(_ fcmToken: String = "")
    case updateUser(_ form: FormUpdatePersonalInfo = FormUpdatePersonalInfo())
    case checkMail(_ email: String = "")
    case signup(form: FormUpdatePersonalInfo = FormUpdatePersonalInfo())
    case verifyMFACode(code: String, factorId:String, ociUserId:String, requestState:String)
    case changePassword( currentPassword: String = "", newPassword: String = "")
    case resetPassword(userId:String = "", newPassword:String = "")
    case sendOTP(email: String = "", happyDay:String? = nil)
    case checkOTP(otpCode: String = "",
                  userId: String? = nil,
                  factorId: String? = nil,
                  requestId: String? = nil,
                  requestState: String = "")
    case checkOTPUser(otpCode: String = "",
                      userId: String? = nil,
                      factorId: String? = nil,
                      requestId: String? = nil,
                      requestState: String = "")
    case requestChangeEmail(newEmail: String = "", password: String = "")
    case updateEmail(userId:String = "",
                     newEmail:String = "")
    case deleteUser
    case createAndUpdateUserIPat(_ form: FormVotingOnline)
    case ipatList
    case notificationsCount
    case notificationList
    case notificationRead
    case notificationDetail(messageCode:String = "" )
    case setting
    case updateSetting(_ param: [String: Any])
    case urgentNotice
    case sysEnv
    case getUser
    case postCode(_ code: String)
    case logout(_ uToken: String)
    case checkLogin(_ email: String)
    case checkChangeEmail
    case checkChangePass
    case getLatestEventDate
    case updateUmacaFlag(_ umacaFlg: String)
    case checkLoginWithPassword(email: String, password: String)
    case registOshiKishu(_ joccode: String)
    case deleteOshiKishu(_ joccode: String)
    case getOshiKishuList
    case getOshiUmaList
    case registOshiUma(_ blr: String)
    case deleteOshiUma(_ blr: String)
    case getOshiUmaRankList
    case getOshiUmaWeeklyRankList
    case multiDeleteOshiUma(_ blr: String)
    case multiDeleteOshiKishi(_ joccode: String)
    case searchOshiKishu(param: String)
    case searchOshiUma(bna: String, opt: String, ewtkbc: String, sex: String, del: String)
    case latestLogin(userId: String)
    case getRegistDate
    
    func method() -> HTTPMethod {
        switch self {
        case .topics,
                .oversea,
                .currentRace,
                .news,
                .registQR,
                .deleteQR,
                .multipleDeleteQR,
                .viewQR,
                .listQR,
                .holiday,
                .ipatList,
                .notificationsCount,
                .notificationList,
                .notificationDetail,
                .setting,
                .urgentNotice,
                .sysEnv,
                .getUser,
                .postCode,
                .checkChangeEmail,
                .checkChangePass,
                .getLatestEventDate,
                .registOshiKishu,
                .deleteOshiKishu,
                .getOshiKishuList,
                .registOshiUma,
                .deleteOshiUma,
                .getOshiUmaList,
                .getOshiUmaRankList,
                .getOshiUmaWeeklyRankList,
                .multiDeleteOshiUma,
                .multiDeleteOshiKishi,
                .searchOshiKishu,
                .searchOshiUma,
                .getRegistDate:
            return .get
        case .registFCMToken,
                .changePassword,
                .resetPassword,
                .sendOTP,
                .checkOTP,
                .checkOTPUser,
                .requestChangeEmail,
                .updateEmail,
                .login,
                .checkMail,
                .signup,
                .createAndUpdateUserIPat,
                .notificationRead,
                .updateSetting,
                .logout,
                .checkLogin,
                .updateUmacaFlag,
                .checkLoginWithPassword,
                .latestLogin:
            return .post
        case .dropFCMToken,
                .deleteUser:
            return .delete
        case .verifyMFACode,
                .updateUser:
            return .patch
        }
    }
    
    func header() -> HTTPHeaders {
        switch self {
        case .holiday,
                .registFCMToken,
                .dropFCMToken,
                .login,
                .signup,
                .sendOTP,
                .checkOTP,
                .checkOTPUser,
                .updateUser,
                .ipatList,
                .notificationsCount,
                .notificationList,
                .notificationRead,
                .notificationDetail,
                .updateSetting,
                .getUser,
                .postCode,
                .logout,
                .checkChangeEmail,
                .checkChangePass:
            return getDefaultHeader()
        case .deleteUser,
                .requestChangeEmail:
            let defaultHeader = getDefaultHeader()
            return defaultHeader
        default:
            let header: HTTPHeaders = [
                "User-agent": "IMTAPP"
            ]
            
            return header
        }
        
        func getDefaultHeader() -> HTTPHeaders {
            return ["Content-Type": "application/json",
                    "Accept": "application/json",
                    "User-agent": "IMTAPP"]
        }
    }
    
    func path() -> String {
        let userId = getUserId().encode() ?? ""
        
        switch self {
        case .topics(let currentDate):
            return "topics/\(currentDate)"
        case .oversea(let currentDate):
            return "oversea/\(currentDate)"
        case .currentRace(let currentDate):
            return "current/\(currentDate)"
        case .news:
            return "/rss/IMT-info.rdf"
        case .login:
            return "users/login"
        case .registQR(let bakenId):
            return "regist/\(userId)/\(bakenId)"
        case .deleteQR(let bakenId):
            return "delete/\(userId)/\(bakenId)"
        case .multipleDeleteQR(let bakenId):
            return "multipleDelete/\(userId)/\(bakenId)"
        case .viewQR(let bakenId):
            return "view/\(userId)/\(bakenId)"
        case .listQR:
            return "list/\(userId)"
        case .holiday:
            return "api/v1/date.json"
        case .registFCMToken:
            return "push-token"
        case .dropFCMToken:
            return "drop-token"
        case .updateUser:
            return "users/\(userId)"
        case .checkMail:
            return "users/check-email"
        case .signup:
            return "users/sign-up"
        case .verifyMFACode:
            return "imt/api/verify-MFA-Code"
        case .changePassword:
            return "users/\(userId)/change-password"
        case .resetPassword(let userId, _):
            return "users/\(userId.encode() ?? "")/update-password"
        case .sendOTP:
            return "users/send-otp"
        case .checkOTP:
            return "users/check-otp"
        case .checkOTPUser(_, let userId, _, _, _):
            return "users/\(userId?.encode() ?? "")/check-otp"
        case .requestChangeEmail:
            return "users/\(userId)/request-change-email"
        case .updateEmail:
            return "users/\(userId)/update-email"
        case .deleteUser:
            return "users/\(userId)"
        case .createAndUpdateUserIPat:
            return "users/\(userId)/update-ipat"
        case .ipatList:
            return "users/\(userId)/ipat-list"
        case .notificationsCount:
            return "users/\(userId)/notifications/count"
        case .notificationList:
            return "users/\(userId)/notifications"
        case .notificationRead:
            return "users/\(userId)/notifications/read"
        case .notificationDetail(let messageCode):
            return "users/\(userId)/notifications/\(messageCode)"
        case .setting:
            return "users/\(userId)/notifications/setting"
        case .updateSetting:
            return "users/\(userId)/notifications/update-setting"
        case .urgentNotice:
            return "urgent-notice"
        case .sysEnv:
            return "sysEnv"
        case .getUser:
            return "users/\(userId)"
        case .postCode(let code):
            return "search?zipcode=\(code)"
        case .logout:
            return "/users/logout"
        case .checkLogin:
            return "users/\(userId)/checkLogin"
        case .checkChangeEmail:
            return "users/\(userId)/checkChangeEmail"
        case .checkChangePass:
            return "users/\(userId)/checkChangePass"
        case .getLatestEventDate:
            return "get_latest_event_date"
        case .updateUmacaFlag:
            return "users/\(userId)/updateUmacaFlg"
        case .checkLoginWithPassword:
            return "users/checkLogin"
        case .registOshiKishu(let joccode):
            return "registK/\(userId)/\(joccode)"
        case .deleteOshiKishu(let joccode):
            return "deleteK/\(userId)/\(joccode)"
        case .getOshiKishuList:
            return "listK/\(userId)"
        case .registOshiUma(let blr):
            return "registU/\(userId)/\(blr)"
        case .deleteOshiUma(let blr):
            return "deleteU/\(userId)/\(blr)"
        case .getOshiUmaList:
            return "listU/\(userId)"
        case .getOshiUmaRankList:
            return "ranklistU"
        case .getOshiUmaWeeklyRankList:
            return "ranklistWeeklyU"
        case .multiDeleteOshiUma(let blr):
            return "deleteMultiU/\(userId)/\(blr)"
        case .multiDeleteOshiKishi(let joccode):
            return "deleteMultiK/\(userId)/\(joccode)"
        case .searchOshiKishu(let param):
            return "searchK/\(userId)/\(param)"
        case .searchOshiUma(let bna, let opt, let ewtkbc, let sex, let del):
            return "searchU/\(userId)/\(bna.encode() ?? "")/\(opt)/\(ewtkbc)/\(sex)/\(del)"
        case .latestLogin:
            return "users/latestLogin"
        case .getRegistDate:
            return "getRegistDate"
        }
    }
    
    func param() -> Parameters {
        
        let userId = getUserId()
        return paramFactory()
        
        ///Logic
        func paramFactory() -> [String: Any] {
            switch self {
            case .topics,
                    .oversea,
                    .currentRace,
                    .news,
                    .registQR,
                    .deleteQR,
                    .multipleDeleteQR,
                    .viewQR,
                    .listQR,
                    .holiday,
                    .deleteUser,
                    .ipatList,
                    .notificationsCount,
                    .notificationList,
                    .notificationRead,
                    .notificationDetail,
                    .setting,
                    .urgentNotice,
                    .sysEnv,
                    .getUser,
                    .postCode,
                    .checkChangeEmail,
                    .checkChangePass,
                    .getLatestEventDate,
                    .registOshiKishu,
                    .deleteOshiKishu,
                    .getOshiKishuList,
                    .registOshiUma,
                    .deleteOshiUma,
                    .getOshiUmaList,
                    .getOshiUmaRankList,
                    .getOshiUmaWeeklyRankList,
                    .multiDeleteOshiUma,
                    .multiDeleteOshiKishi,
                    .searchOshiKishu,
                    .searchOshiUma,
                    .getRegistDate:
                return [:]
            case .registFCMToken:
                return ["userId": userId,
                        "tknNum": Constants.System.tknNum,
                        "uToken": Constants.System.fcmToken]
            case .dropFCMToken(let fcmToken):
                return ["uToken": fcmToken,
                        "userId": userId]
            case .updateUser(let form):
                return form.toParam()
            case .checkMail(let email):
                return ["email": email.encrypt()]
            case .signup(let form):
                return form.toParam()
            case .verifyMFACode(let code, let factorId, let ociUserId, let requestState):
                return ["code": code,
                        "factorId": factorId,
                        "ociUserId": ociUserId,
                        "requestState": requestState]
            case .changePassword( let currentPassword, let newPassword):
                return ["currentPassword": currentPassword.encrypt(),
                        "newPassword": newPassword.encrypt()]
            case .resetPassword(_, let newPassword):
                return ["newPassword": newPassword.encrypt()]
            case .sendOTP(let email, let happyDay):
                var params  = ["email": email.encrypt()]
                
                if let happyDay = happyDay {
                    params["happyDay"] = happyDay.encrypt()
                }
                
                return params
            case .checkOTP(let otpCode,
                           let userId,
                           let factorId,
                           let requestId,
                           let requestState):
                var params = ["otpCode": otpCode,
                              "requestState": requestState]
                
                if let userId = userId {
                    params["userId"] = userId
                }
                
                if let factorId = factorId {
                    params["factorId"] = factorId
                }
                
                if let requestId = requestId {
                    params["requestId"] = requestId
                }
                
                return params
            case .checkOTPUser(let otpCode,
                               let userId,
                               let factorId,
                               let requestId,
                               let requestState):
                var params = ["otpCode": otpCode,
                              "requestState": requestState]
                
                if let userId = userId {
                    params["userId"] = userId
                }
                
                if let factorId = factorId {
                    params["factorId"] = factorId
                }
                
                if let requestId = requestId {
                    params["requestId"] = requestId
                }
                
                return params
            case .requestChangeEmail (let newEmail, let password):
                return ["newEmail": newEmail.encrypt(), "password": password.encrypt()]
            case .updateEmail(_ ,let newEmail):
                return ["newEmail": newEmail.encrypt()]
            case .login(let form):
                return form!.toParam()
            case .createAndUpdateUserIPat(let form):
                return form.toParam()
            case .updateSetting(let param):
                return param
            case .logout(let uToken):
                return ["uToken": uToken]
            case .checkLogin(let email):
                return ["email": email.encrypt()]
            case .updateUmacaFlag(let umacaFlg):
                return ["umacaFlg": Int(umacaFlg)!]
            case .checkLoginWithPassword(let email, let password):
                return ["email": email.encrypt(), "password": password.encrypt()]
            case .latestLogin(let userId):
                return ["userId": userId]
            }
        }
    }
    
    func encoding() -> ParameterEncoding {
        switch self {
        case .holiday,
                .ipatList,
                .notificationsCount,
                .notificationList,
                .notificationDetail,
                .setting,
                .urgentNotice,
                .getUser,
                .postCode,
                .checkChangePass,
                .checkChangeEmail,
                .getLatestEventDate,
                .searchOshiKishu,
                .searchOshiUma,
                .getRegistDate:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}

extension EndPoint {
    private func getUserId() -> String {
        return Utils.getUserDefault(key: .userId) ?? ""
    }
}
