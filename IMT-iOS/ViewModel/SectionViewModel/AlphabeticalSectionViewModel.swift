//
//  AlphabeticalSectionViewModel.swift
//  IMT-iOS
//
//  Created on 10/04/2024.
//
    

import Foundation

class AlphabeticalSectionViewModel: IMTActionResponder {
    weak var nextActionResponder: IMTActionResponder?
    
    private let initialName: String
    let jockeys: [OshiKishu]
    
    init(initialName: String, jockeys: [OshiKishu]) {
        self.initialName = initialName
        self.jockeys = jockeys
    }
    
    func hasHeader() -> Bool {
        return !initialName.isEmpty
    }
    
    func headerTitle() -> String? {
        return initialName
    }
    
    func numberOfItems() -> Int {
        return jockeys.count
    }
    
    func cellViewModels() -> [BaseCellViewModel] {
        let cellViewModels = jockeys.compactMap { IFavoriteSearchResultCellViewModel(jockey: $0) }
        return cellViewModels
    }
    
    func handleAction(_ action: IMTAction) {
        nextActionResponder?.handleAction(action)
    }
}

