//
//  FIRNotificationModel.swift
//  IMT-iOS
//
//  Created by dev on 26/07/2023.
//

import Foundation
import SwiftyJSON

struct FIRNotificationModel: JSONModel {
    var type: Int!
    var category: Int
    var url: String?
    var messageCode: String
    var filter: Int
    
    init(json: JSON) {
        self.type = json["TYPE"].intValue
        self.category = json["CATEGORY"].intValue
        self.url = json["URL"].string
        self.messageCode = json["MESSAGECODE"].stringValue
        self.filter = json["FILTER"].intValue
    }
    
    init(dict: [String: Any]) {
        self.init(json: JSON(rawValue: dict)!)
    }
    
    func getCategory() -> IMTNotificationCategory? {
        guard let category = IMTNotificationCategory(rawValue: category) else { return nil }
        return category
    }
    
    func getType() -> IMTNotificationType? {
        return IMTNotificationType(rawValue: type)
    }
}
