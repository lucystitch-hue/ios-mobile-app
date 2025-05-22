//
//  ResponseVotingOnline.swift
//  IMT-iOS
//
//  Created by dev on 15/06/2023.
//

import UIKit
struct VotingOnlineDataModel: IPatDataModel {
    var iPatId1: String?
    var iPatPars1: String?
    var iPatPass1: String?
    var ysnFlg1: String?
    var iPatId2: String?
    var iPatPars2: String?
    var iPatPass2: String?
    var ysnFlg2: String?
}

struct ResponseVotingOnline: BaseResponse {
    typealias R = ResponseVotingOnline
    
    var success: Bool
    var message: String?
    var data: VotingOnlineDataModel?

}
