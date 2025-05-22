//
//  ResponseDeleteQR.swift
//  IMT-iOS
//
//  Created by dev on 27/04/2023.
//

import UIKit
import SwiftyJSON

struct DeleteQRModel: JSONModel {
    
    let status: String?
    
    init(json: JSON) {
        self.status = json["status"].string
    }
}

struct ResponseDeleteQR: BaseResponse {
    typealias R = ResponseDeleteQR
    
    var success: Bool
    var message: String?
    
}
