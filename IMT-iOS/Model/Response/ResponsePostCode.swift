//
//  ResponsePostCode.swift
//  IMT-iOS
//
//  Created by dev on 14/07/2023.
//

import Foundation
import SwiftyJSON

struct PostCodeDataModel: JSONModel {
    var address1: String?
    
    init(json: JSON) {
        self.address1 = json["address1"].string
    }
}

struct ResponsePostCode: JSONModel {
    var message: String?
    var status: Int
    var results: Bool
    
    init(json: JSON) {
        self.message = json["message"].string
        self.status = json["status"].intValue
        self.results = json["results"].arrayValue.count != 0
    }
}
