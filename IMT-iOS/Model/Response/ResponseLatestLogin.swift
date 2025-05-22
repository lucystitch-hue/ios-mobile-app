//
//  ResponseLatestLogin.swift
//  IMT-iOS
//
//  Created on 17/04/2024.
//
    

import Foundation

struct ResponseLatestLogin: BaseResponse {
    typealias R = ResponseLatestLogin
    var success: Bool
    var message: String?
    var data: String?
}
