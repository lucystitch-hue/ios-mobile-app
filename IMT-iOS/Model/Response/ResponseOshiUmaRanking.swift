//
//  ResponseOshiUmaRanking.swift
//  IMT-iOS
//
//  Created on 02/04/2024.
//


import Foundation
import SwiftyJSON

struct ResponseOshiUmaRanking: JSONModel {
    var items: [OshiUmaRanking] = []
    
    init(json: JSON) {
        json.arrayObject?.forEach({ object in
            let item = OshiUmaRanking(json: JSON(object))
            self.items.append(item)
        })
    }
}

class OshiUmaRanking: JSONModel {
    
    var rnknum: String
    var bna: String
    var blr: String
    var count: String
    
    //MARK: Logic
    var favorite: Bool = false
    
    required init(json: JSON) {
        self.rnknum = json["rnknum"].stringValue
        self.bna = json["bna"].stringValue
        self.blr = json["blr"].stringValue
        self.count = json["count"].stringValue
    }
}

extension OshiUmaRanking {
    public func getCrownImage() -> UIImage? {
        guard let top = Int(rnknum),
                let object = TopFavorite(rawValue: top) else { return nil }
        return object.crownImage()
    }
    
    public func getCrownToString() -> String {
        return "\(rnknum)"
    }
    
    public func getStarImage() -> UIImage? {
        return favorite ? .icStar : nil
    }
    
    public func getScoreToString() -> String {
        guard let count = Int(count) else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: count )
        guard let scoreValue = formatter.string(from: number) else { return "" }
        return scoreValue
    }
}
