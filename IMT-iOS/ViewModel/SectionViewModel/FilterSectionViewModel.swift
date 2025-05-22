//
//  FilterSectionViewModel.swift
//  IMT-iOS
//
//  Created on 18/03/2024.
//
    

import Foundation

class FilterSectionViewModel: IMTActionResponder {
    var nextActionResponder: IMTActionResponder?
    
    let section: FilterSectionType
    
    init(section: FilterSectionType) {
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
    
    func cellViewModels() -> [BaseCellViewModel] {
        let cellViewModel = FilterCellViewModel(items: section.filterItems())
        cellViewModel.nextActionResponder = self
        return [cellViewModel]
    }
    
    func handleAction(_ action: IMTAction) {
        guard let filterAction = action as? FilterAction else {
            return
        }
        
        guard let item = filterAction.userInfo[FilterActionKey.destinationPage] as? String else {
            return
        }
        
        filterAction.userInfo[FilterActionKey.destinationPage] = "\(section.rawValue)|\(item)"
        
        nextActionResponder?.handleAction(action)
    }
}
