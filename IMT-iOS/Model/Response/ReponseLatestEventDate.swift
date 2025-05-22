//
//  ReponseLatestEventDate.swift
//  IMT-iOS
//
//  Created by dev on 02/10/2023.
//

import Foundation

struct LatestEventDateModel: DataModel {
    var latestEventDate: String?
}

struct ReponseLatestEventDate: BaseResponse {
    typealias R = ReponseLatestEventDate
    
    var success: Bool
    var message: String?
    var data: LatestEventDateModel?

}
