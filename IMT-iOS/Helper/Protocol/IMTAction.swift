//
//  IMTAction.swift
//  IMT-iOS
//
//  Created on 27/01/2024.
//
    

import Foundation

protocol IMTAction {
    var sender: Any? {get}
    var userInfo: [String: Any] {get}
}

protocol IMTActionResponder: AnyObject {
    var nextActionResponder: IMTActionResponder? {get set}
    func handleAction(_ action: IMTAction)
}

extension IMTActionResponder {
    func handleAction(_ action: IMTAction) {
        nextActionResponder?.handleAction(action)
    }
}
