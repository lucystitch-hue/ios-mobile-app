//
//  HitBettingTicketArchiveModel.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import Foundation
import UIKit

struct HitBettingTicketArchiveModel{
    var date: String!
    var areaName: String!
    var share: String!
    var top: String!
    var rank: String!
    
    func classToString() -> String {
        return Class(rawValue: self.rank)?.string() ?? ""
    }
    
    func classColor() -> UIColor? {
        return Class(rawValue: self.rank)?.color()
    }

}
