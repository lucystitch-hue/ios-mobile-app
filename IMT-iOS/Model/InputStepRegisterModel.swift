//
//  InputStepResgisterModel.swift
//  IMT-iOS
//
//  Created by dev on 15/03/2023.
//

import Foundation

class InputStepRegisterModel {
    var title: String!
    var index: Int!
    var selected: Bool!
    
    init(title: String!, index: Int!, selected: Bool!) {
        self.title = title
        self.index = index
        self.selected = selected
    }
    
    init(title: String!, index:Int!) {
        self.title = title
        self.index = index
        self.selected = false
    }
    
    init(title: String!) {
        self.title = title
        self.index = -1
        self.selected = false
    }
    
    func getValue() -> String {
        return selected ? "1" : "0"
    }
}
