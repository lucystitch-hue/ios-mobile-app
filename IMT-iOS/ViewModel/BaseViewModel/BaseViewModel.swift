//
//  ViewModelProtocol.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation
import UIKit

protocol ViewModelProtocol {
    var manager: NetworkManager! { get set }
    var tabChange: Bool { get set }
    
    func refreshData()
    func removeObserver()
    func showMessageError(message: String)
}

class BaseViewModel: ViewModelProtocol, IMTActionResponder {
    var nextActionResponder: IMTActionResponder?
    
    var manager: NetworkManager!
    var tabChange: Bool = false
    var onErrorMessage: JString = { _ in }
    var onTransaction: JTrans = { _ in }
    
    init() {
        self.manager = NetworkManager();
    }
    
    func refreshData() {
        
    }
    
    func showMessageError(message: String) {
        Utils.postObserver(.showErrorSystem, object: message)
    }
    
    func removeObserver() {
        
    }
    
    func handleAction(_ action: IMTAction) {
        nextActionResponder?.handleAction(action)
    }
}
