//
//  ResponseViewQR.swift
//  IMT-iOS
//
//  Created by dev on 27/04/2023.
//

import UIKit
import SwiftyJSON

struct ViewQRModel: JSONModel {
    var memorialId: String!
    var image: String?
    var status: Bool?
    var regDate: String?
    
    init(json: JSON) {
        self.memorialId = json["memorialId"].string
        self.image = json["image"].string
        self.status = json["status"].bool
        self.regDate = json["regDate"].string
    }
    
    func regDateToString() -> String {
        let strDate = self.regDate?.format(with: .IMTYYYYMMddhhMM, to: .IMTYYYYMdhMM)
        return strDate ?? ""
    }
}

struct ResponseViewQR: BaseResponse {
    typealias R = ResponseViewQR
    
    var success: Bool
    var message: String?
}
