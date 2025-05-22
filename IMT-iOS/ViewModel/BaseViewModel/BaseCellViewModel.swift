//
//  BaseCellViewModel.swift
//  IMT-iOS
//
//  Created on 18/03/2024.
//
    

import Foundation

class BaseCellViewModel: BaseViewModel {
    var updateLayout: ObservableObject<Bool> = ObservableObject(false)
    
    var nibName: String {
        fatalError("Variable should be overridden in child. Better by using function nameOfClass() of appropriate cell")
    }
    var cellIdentifier: String {
        fatalError("Variable should be overridden in child. Better by using function nameOfClass() of appropriate cell in case of using same cell identifier name")
    }
    
    override func handleAction(_ action: IMTAction) {
        nextActionResponder?.handleAction(action)
    }
}
