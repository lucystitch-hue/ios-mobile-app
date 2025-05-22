//
//  ResponseListQR.swift
//  IMT-iOS
//
//  Created by dev on 27/04/2023.
//

import UIKit
import SwiftyJSON

class IListQRModel: JSONModel, Codable {
    var date: String!
    var place: String!
    var raceNo: String!
    var name: String!
    var grade: String!
    var memorialId: String!
    var userId: String!
    
    //Handle logic
    var rawIndex: Int!
    var choice: Bool = false
    
    required init(json: JSON) {
        self.date = json["date"].string
        self.place = json["place"].string
        self.raceNo = json["raceNo"].string
        self.grade = json["grade"].stringValue
        self.memorialId = json["memorialId"].string
        self.name = json["name"].string
        self.userId = json["userId"].string
    }
    
    func dateToString() -> String {
        let strPrefix = String(date)
        let valueDate = strPrefix.toDate(IMTDateFormatter.IMTMMdd.rawValue)
        
        let year = valueDate?.getYear() ?? 0
        let month = valueDate?.getMonth() ?? 0
        let day = valueDate?.getDay() ?? 0
        
        return "\(year)\(String.placeholder.year)\(month)\(String.placeholder.month)\(day)\(String.placeholder.day)"

    }
    
    func raceNoToString() -> String {
        let value = Int(raceNo) ?? 0
        return "\(value)R"
    }
    
    func placeToString() -> String {
        return place ?? ""
    }
}

struct ListQRModel: JSONModel {

    var memorialList: [IListQRModel]!
    
    init(json: JSON) {
        self.memorialList = json["MemorialList"].arrayValue.map({ return IListQRModel(json: $0) })
    }
}

struct ResponseListQR: BaseResponse {

    typealias R = ResponseListQR
    var success: Bool
    var message: String?
    var MemorialList: [IListQRModel]!
}
