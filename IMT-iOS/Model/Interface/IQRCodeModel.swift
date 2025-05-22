//
//  IQRCodeModel.swift
//  IMT-iOS
//
//  Created by dev on 20/04/2023.
//

import Foundation

struct IQRCodeBetting {
    var ordinal: Int
    var betting: String
}

struct IQRCodeModel {
    var code: String
    var reward: String
    var bettings: [IQRCodeBetting]
}
