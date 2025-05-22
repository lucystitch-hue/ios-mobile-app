//
//  FavoriteModel.swift
//  IMT-iOS
//
//  Created on 15/03/2024.
//
    

import Foundation
import SwiftyJSON

struct FavoriteModel: JSONModel {
    
    var object: String!
    var favorite: Bool!
    var number: Int!
    
    init(json: JSON) {
        
    }
}
