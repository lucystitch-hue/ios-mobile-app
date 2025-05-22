//
//  IFavoriteSearchResultCellViewModel.swift
//  IMT-iOS
//
//  Created on 10/04/2024.
//
    

import Foundation

class IFavoriteSearchResultCellViewModel: BaseCellViewModel {
    override var nibName: String {
        return IFavoriteSearchResultCell.nameOfClass
    }
    
    override var cellIdentifier: String {
        return IFavoriteSearchResultCell.nameOfClass
    }
    
    let jockey: OshiKishu
    
    init(jockey: OshiKishu) {
        self.jockey = jockey
    }
}
