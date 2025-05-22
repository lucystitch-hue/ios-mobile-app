//
//  ResponseRegistQR.swift
//  IMT-iOS
//
//  Created by dev on 27/04/2023.
//

import UIKit
import SwiftyJSON

struct RegisterQRModel: JSONModel {
    
    var memorialId: String!
    var image: String!
    
    init(json: JSON) {
        self.memorialId = json["memorialId"].string
        self.image = json["image"].string
    }
    
    
}

struct ResponseRegistQR: BaseResponse {
    typealias R = ResponseRegistQR
    
    var success: Bool
    var message: String?
}
