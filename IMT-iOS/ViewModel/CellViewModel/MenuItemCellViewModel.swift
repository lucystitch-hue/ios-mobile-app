//
//  MenuItemCellViewModel.swift
//  IMT-iOS
//
//  Created on 26/01/2024.
//
    

import Foundation
import SwiftUI

struct MenuActionKey {
    static let destinationPage: String = "destinationPage"
    static let nestedObject: String = "nestedObject"
    static let dismissHandler: String = "dismissHandler"
}

class MenuAction: IMTAction {
    var sender: Any?
    var userInfo: [String: Any]
    var completionHandler: (() -> Void)? = nil

    init(_ sender: Any? = nil, _ userInfo: [String: Any] = [String: Any]()) {
        self.sender = sender
        self.userInfo = userInfo
    }
}

extension MenuAction: Equatable {
    static func ==(lhs: MenuAction, rhs: MenuAction) -> Bool {
        let equalSender = lhs.sender as AnyObject === rhs.sender as AnyObject
        let equalUserInfo = isEqualIfUserInfoIsDAPageType(lhs: lhs, rhs: rhs)
        return equalSender && equalUserInfo
    }
    
    private static func isEqualIfUserInfoIsDAPageType(lhs: MenuAction, rhs: MenuAction) -> Bool {
        guard let lhsUserInfo = lhs.userInfo as? [String: MenuItemType], let rhsUserInfo = rhs.userInfo as? [String: MenuItemType] else {
            return true
        }
        return lhsUserInfo == rhsUserInfo
    }
}

class MenuItemCellViewModel: IMTActionResponder {
    weak var nextActionResponder: IMTActionResponder?
    
    let cellIdentifier: String = MenuItemCell.nameOfClass
    let nibName: String = MenuItemCell.nameOfClass
    
    var items: [MenuItemType] = [MenuItemType]()
    
    init(_ items: [MenuItemType]) {
        self.items = items
    }
    
    func handleMenuItemTapped(_ type: MenuItemType) {
        let action  = MenuAction(self, [MenuActionKey.destinationPage: type])
        nextActionResponder?.handleAction(action)
    }
}
