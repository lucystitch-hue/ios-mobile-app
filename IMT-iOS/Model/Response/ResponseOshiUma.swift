//
//  ResponseOshiUma.swift
//  IMT-iOS
//
//  Created on 02/04/2024.
//
    

import Foundation
import SwiftyJSON

struct ResponseOshiUma: JSONModel {
    var items: [OshiUma] = []
    
    init(json: JSON) {
        json.arrayObject?.forEach({ object in
            let item = OshiUma(json: JSON(object))
            items.append(item)
        })
    }
}

class OshiUma: PreferenceFeature {
    var selected: Bool = false
    var bna: String
    var blr: String
    var sexcod: String
    var age: String
    var delyear: String
    var tyn: String
    var wkb: String
    var rahmaskbn: String
    var shusso: String
    var hoboku: String
    var url: String
    var torokuzumi: String
    
    required init(json: JSON) {
        self.bna = json["bna"].stringValue
        self.blr = json["blr"].stringValue
        self.sexcod = json["sexcod"].stringValue
        self.age = json["age"].stringValue
        self.delyear = json["delyear"].stringValue
        self.tyn = json["tyn"].stringValue
        self.wkb = json["wkb"].stringValue
        self.rahmaskbn = json["rahmaskbn"].stringValue
        self.shusso = json["shusso"].stringValue
        self.hoboku = json["hoboku"].stringValue
        self.url = json["url"].stringValue
        self.torokuzumi = json["torokuzumi"].stringValue
    }
    
    func getCName() -> String {
        return blr
    }
    
    func getFavorite() -> Bool {
        guard let favorite = Bool(torokuzumi.lowercased()) else { return false }
        return favorite
    }
    
    func getName() -> String {
        return bna
    }
    
    func getUrlString() -> String {
        return url
    }
}

extension OshiUma {
    public func getGenderToString() -> String {
        guard let gender = J01SEXCOD(rawValue: sexcod)?.text() else { return "" }
        
        return "\(gender)\(age)"
    }
}

