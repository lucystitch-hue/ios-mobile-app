//
//  FilterCellViewModel.swift
//  IMT-iOS
//
//  Created on 18/03/2024.
//
    

import Foundation

struct FilterActionKey {
    static let destinationPage: String = "destinationPage"
    static let nestedObject: String = "nestedObject"
    static let dismissHandler: String = "dismissHandler"
}

class FilterAction: IMTAction {
    var sender: Any?
    var userInfo: [String: Any]
    var completionHandler: (() -> Void)? = nil

    init(_ sender: Any? = nil, _ userInfo: [String: Any] = [String: Any]()) {
        self.sender = sender
        self.userInfo = userInfo
    }
}

extension FilterAction: Equatable {
    static func ==(lhs: FilterAction, rhs: FilterAction) -> Bool {
        let equalSender = lhs.sender as AnyObject === rhs.sender as AnyObject
        let equalUserInfo = isEqualIfUserInfoIsDAPageType(lhs: lhs, rhs: rhs)
        return equalSender && equalUserInfo
    }
    
    private static func isEqualIfUserInfoIsDAPageType(lhs: FilterAction, rhs: FilterAction) -> Bool {
        if let lhsUserInfo = lhs.userInfo as? [String: String], let rhsUserInfo = rhs.userInfo as? [String: String] {
            return lhsUserInfo == rhsUserInfo
        }
        return true
    }
}

class FilterCellViewModel: BaseCellViewModel {
    override var nibName: String {
        return FilterCell.nameOfClass
    }
    
    override var cellIdentifier: String {
        return FilterCell.nameOfClass
    }
    
    let items: [FilterItemType]
    var selectedItems: [FilterItemType]
    
    init(items: [FilterItemType] = []) {
        self.items = items
        self.selectedItems = items.filter{$0.defaultValue()}
        super.init()
    }
    
    func handleChecked(type: FilterItemType, selected: Bool) {
        if selected {
            selectedItems.append(type)
        } else {
            selectedItems.removeObject(type)
        }
        
        let value = selectedItems.isEmpty ? "_" : selectedItems.map {$0.value()}.joined(separator: "_")
        
        let action = FilterAction(self, [FilterActionKey.destinationPage: value])
        nextActionResponder?.handleAction(action)
    }
}
