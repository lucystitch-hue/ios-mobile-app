//
//  ResponseOshiKishu.swift
//  IMT-iOS
//
//  Created on 02/04/2024.
//
    

import Foundation
import SwiftyJSON

protocol PreferenceFeature: JSONModel {
    func getCName() -> String
    func getName() -> String
    func getFavorite() -> Bool
    func getUrlString() -> String
    func getTopic(_ sendkbn: String) -> String
}

extension PreferenceFeature {
    func getTopic(_ sendkbn: String) -> String {
        return Utils.getTopic(sendkbn, cname: getCName())
    }
}

struct ResponseOshiKishu: JSONModel {
    var items: [OshiKishu] = []
    
    init(json: JSON) {
        json.arrayObject?.forEach({ object in
            let item = OshiKishu(json: JSON(object))
            items.append(item)
        })
    }
}

class OshiKishu: PreferenceFeature {
    var joccode: String
    var jon: String
    var initial: String?
    var masflg: String
    var joewkb: String
    var url: String
    var param: String
    var torokuzumi: String
    
    required init(json: JSON) {
        self.joccode = json["joccode"].stringValue
        self.jon = json["jon"].stringValue
        self.initial = json["initial"].stringValue
        self.masflg = json["masflg"].stringValue
        self.joewkb = json["joewkb"].stringValue
        self.url = json["url"].stringValue
        self.param = json["param"].stringValue
        self.torokuzumi = json["torokuzumi"].stringValue
    }
    
    init(joccode: String,
         jon: String,
         initial: String,
         masflg: String,
         joewkb: String,
         url: String,
         param: String,
         torokuzumi: String) {
        self.joccode = joccode
        self.jon = jon
        self.initial = initial
        self.masflg = masflg
        self.joewkb = joewkb
        self.url = url
        self.param = param
        self.torokuzumi = torokuzumi
    }
    
    func getCName() -> String {
        return joccode
    }
    
    func getFavorite() -> Bool {
        guard let favorite = Bool(torokuzumi.lowercased()) else { return false }
        return favorite
    }
    
    func getName() -> String {
        return jon
    }
    
    func getUrlString() -> String {
        return "\(url)?cname=\(param)"
    }
}
