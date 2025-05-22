//
//  ResponseChangeMail.swift
//  IMT-iOS
//
//  Created by dev on 09/06/2023.
//

import UIKit

struct ChangeMailDataModel: Codable {
    var newEmail: String?
    var userId: String?
}

struct ResponseChangeMail: BaseResponse {
    typealias R = ResponseChangeMail
    
    var success: Bool
    var message: String?
    var data: ChangeMailDataModel?
}
