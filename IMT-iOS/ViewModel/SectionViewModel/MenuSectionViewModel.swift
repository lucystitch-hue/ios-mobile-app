//
//  MenuSectionViewModel.swift
//  IMT-iOS
//
//  Created on 26/01/2024.
//
    

import Foundation

class MenuSectionViewModel: IMTActionResponder {
    weak var nextActionResponder: IMTActionResponder?
    
    let section: MenuSectionType
    
    init(section: MenuSectionType) {
        self.section = section
    }
    
    func hasHeader() -> Bool {
        return !section.rawValue.isEmpty
    }
    
    func headerTitle() -> String? {
        return section.rawValue
    }
    
    func numberOfItems() -> Int {
        return cellViewModels().count
    }
    
    func cellViewModels() -> [MenuItemCellViewModel] {
        let cellViewModel = MenuItemCellViewModel(section.menuItems())
        cellViewModel.nextActionResponder = self
        return [cellViewModel]
    }
    
    func handleAction(_ action: IMTAction) {
        nextActionResponder?.handleAction(action)
    }
}
