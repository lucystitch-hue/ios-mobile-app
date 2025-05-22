//
//  FormData.swift
//  IMT-iOS
//
//  Created by dev on 29/05/2023.
//

import Foundation

protocol FormData {
    //TODO: Listen to the emit event. After handle action.
    var onFilled: JBool? { get set }
    
    //TODO: Signal when changing data input.
    func emit()
    
    //TODO: Verify the required fields. Class need to conform.
    func requiredFieldIsFilled() -> Bool
    
    //TODO: Convert object to dictionary.
    func toParam() -> [String: Any]
    
    //TODO: Convert object to dictionary. Supporting removing params isn't neccesary.
    func toParam(blackListParam: [String]) -> [String: Any]
    
    func validate() -> JValidate
}

extension FormData {
    
    func emit() {
        let filled = requiredFieldIsFilled()
        onFilled?(filled)
    }
    
    func requiredFieldIsFilled() -> Bool {
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label, key != "onFilled" {
                switch child.value {
                case Optional<Any>.none:
                    return false
                default:
                    continue
                }
            }
        }
        return true
    }
    
    func toParam() -> [String: Any] {
        return toParam(blackListParam: [])
    }
    
    func toParam(blackListParam: [String] = []) -> [String: Any] {
        var dict = [String: Any]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children {
            if let key = child.label, key != "onFilled", !blackListParam.contains(key) {
                dict[key] = child.value
            }
        }
        return dict
    }
    
    func validate() -> JValidate {
        return (nil, true)
    }
}
