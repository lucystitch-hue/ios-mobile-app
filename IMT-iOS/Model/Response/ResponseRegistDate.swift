//
//  ResponseRegistDate.swift
//  IMT-iOS
//
//  Created on 04/06/2024.
//
    

import UIKit

struct RegistDate: DataModel {
    var regisDate: String?
}

struct ResponseRegistDate: BaseResponse {
    typealias R = ResponseRegistDate
    
    var success: Bool
    
    var message: String?
    var data: RegistDate?
}
