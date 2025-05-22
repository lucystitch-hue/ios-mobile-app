//
//  IRaceByDateModel.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import Foundation
import UIKit

struct IRaceByDateModel {
    var date: String
    var info: IRaceInfo
    
}

struct IRaceInfo {
    var tabDateColor: UIColor
    var tabPlaceColor: UIColor
    var backgroundColor: UIColor
    var places: [IRaceByPlaceModel]
}

struct IRaceByPlaceModel {
    var place: String
    var races:[RaceModel]
    var coller: String
    
    func getBackgroundColor() -> UIColor? {
        guard let coller = RaceColler(rawValue: coller) else { return nil }
        return coller.backgroundColor()
    }
    
        func getTabPlaceColor() -> UIColor? {
        guard let coller = RaceColler(rawValue: coller) else { return nil }
        return coller.tabPlaceColor()
    }
    
    func getRankColor() -> UIColor? {
        guard let coller = RaceColler(rawValue: coller) else { return nil }
        return coller.rankColor()
    }
}

