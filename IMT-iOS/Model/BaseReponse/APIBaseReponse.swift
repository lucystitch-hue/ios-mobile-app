//
//  APIBaseReponse.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import UIKit

struct APIBaseReponse: BaseResponse {
    typealias R = APIBaseReponse
    
    var success: Bool
    var message: String?
}
