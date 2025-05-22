//
//  JSONModel.swift
//  IMT-iOS
//
//  Created by dev on 03/04/2023.
//

import Foundation
import SwiftyJSON

protocol JSONModel : Codable {
    init(json: JSON);
}
