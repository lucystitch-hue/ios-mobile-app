//
//  IReasonDeleteModel.swift
//  IMT-iOS
//
//  Created by dev on 05/05/2023.
//

import Foundation

class IReasonDelete: CheckedModel {
    var checked: Bool = false
    var title: String!
    
    init(title: String) {
        self.title = title
        self.checked = false
    }
}
