//
//  DataModel.swift
//  IMT-iOS
//
//  Created by dev on 09/06/2023.
//

import Foundation

protocol DataModel: Codable {
    func toParam(blackListParam: [String]) -> [String: Any]
}

extension DataModel {
    func toParam(blackListParam: [String] = []) -> [String: Any] {
        var dict = [String: Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label, !blackListParam.contains(key) {
                dict[key] = child.value
            }
        }
        return dict
    }
}
