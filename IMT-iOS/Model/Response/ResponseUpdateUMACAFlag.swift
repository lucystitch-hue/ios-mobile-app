//
//  ResponseUpdateUMACAFlag.swift
//  IMT-iOS
//
//  Created by dev on 13/10/2023.
//

struct UpdateUMACAFlag: DataModel {
    var userId: String?
    var umacaFlg: String?
    var email: String?
}

struct ResponseUpdateUMACAFlag: BaseResponse {
    typealias R = ResponseUpdateUMACAFlag
    
    var success: Bool
    var message: String?
    var data: UpdateUMACAFlag?

}
