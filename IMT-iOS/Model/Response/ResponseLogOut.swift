//
//  ResponseLogOut.swift
//  IMT-iOS
//
//  Created by dev on 11/08/2023.
//

import Foundation
import SwiftyJSON

struct ResponseLogOut: BaseResponse {
    typealias R = ResponseLogOut
    
    var success: Bool
    var message: String?

}
