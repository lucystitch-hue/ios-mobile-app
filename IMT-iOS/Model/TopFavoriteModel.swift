//
//  TopFavoriteModel.swift
//  IMT-iOS
//
//  Created on 19/03/2024.
//
    

import Foundation
import SwiftyJSON

struct TopFavoriteModel: JSONModel {
    
    var cname: String!
    var top: Int!
    var favorite: Bool!
    var title: String!
    var score: Int!
    
    init(json: JSON) {
        
    }
    
    init(cname: String, top: Int, favorite: Bool, title: String, score: Int) {
        self.cname = cname
        self.top = top
        self.favorite = favorite
        self.title = title
        self.score = score
    }
}

//MARK: Public
extension TopFavoriteModel {
    public func getCrownImage() -> UIImage? {
        guard let object = TopFavorite(rawValue: top) else { return nil }
        return object.crownImage()
    }
    
    public func getCrownToString() -> String {
        guard let top = top else { return  "" }
        return "\(top)"
    }
    
    public func getStarImage() -> UIImage? {
        return favorite ? .icStar : nil
    }
    
    public func getScoreToString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: score)
        guard let scoreValue = formatter.string(from: number) else { return "" }
        return scoreValue
    }
}
