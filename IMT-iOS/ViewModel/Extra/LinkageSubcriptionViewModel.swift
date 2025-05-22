//
//  LinkageSubcriptionViewModel.swift
//  IMT-iOS
//
//  Created by dev on 11/03/2023.
//

import Foundation
import UIKit

protocol LinkageSubcriptionViewModelProtocol {
    var isConfirmNoShowPopup: ObservableObject<Bool> { get set }
    
    func enterSubscriberNumber(_ controller: LinkageSubcriptionVC)
    func pat(_ controller: LinkageSubcriptionVC)
    func ignore(_ controller: LinkageSubcriptionVC)
}

class LinkageSubcriptionViewModel {
    var isConfirmNoShowPopup: ObservableObject<Bool> = ObservableObject<Bool>(false)
}

extension LinkageSubcriptionViewModel: LinkageSubcriptionViewModelProtocol {
    func enterSubscriberNumber(_ controller: LinkageSubcriptionVC) {
//        let exist = UserManager.share().checkExistIpat()
//
//        if(!exist) {
//
//        } else {
//
//        }
        
        controller.onGotoVoteOnline?()
        cacheCheckboxWhenNoRegisterPat()
        controller.dismiss(animated: false)
    }
    
    func pat(_ controller: LinkageSubcriptionVC) {
        controller.transitionFromSafari(TransactionLink.soKanyu.rawValue)
        
        cacheCheckboxWhenNoRegisterPat()
    }
    
    func ignore(_ controller: LinkageSubcriptionVC) {
        if let onDismiss = controller.onDismiss {
            onDismiss()
        } else {
            controller.dismiss(animated: true)
        }
        
        cacheCheckboxWhenNoRegisterPat()
    }
}

//MARK: Private
extension LinkageSubcriptionViewModel {
    
    private func cacheCheckboxWhenNoRegisterPat() {
        if(isConfirmNoShowPopup.value == true) {
            Utils.setUserDefault(value: "true", forKey: .didLinkageIpat)
        }
    }
}
