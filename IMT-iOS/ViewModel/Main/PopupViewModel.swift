//
//  PopupViewModel.swift
//  IMT-iOS
//
//  Created by dev on 06/09/2023.
//

import Foundation
import SwiftyJSON
import Firebase

protocol PopupDeleteAccountViewModelProtocol {
    func delete()
    func close(_ controller: PopupDeleteAccountVC?)
}

class PopupDeleteAccountViewModel: BaseViewModel {
    
}

extension PopupDeleteAccountViewModel: PopupDeleteAccountViewModelProtocol {
    func delete() {
        manager.call(endpoint: .deleteUser, completion: responseDeleteUser)
        NotificationManager.share().unsubscribeTopics()
    }
    
    func close(_ controller: PopupDeleteAccountVC?) {
        controller?.dismiss(animated: true)
        
        controller?.onDismiss?()
    }
}

//MARK: API
extension PopupDeleteAccountViewModel {
    //TODO: Response
    func responseDeleteUser(_ response: ResponseDeleteUser?, success: Bool) {
        guard let response = response else { return }
        
        if(response.success) {
            UserManager.share().resetShowTerm()
            Utils.postLogout()
            UserManager.share().clearBiomatricAuthentication()
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
}

//MARK: Private
extension PopupDeleteAccountViewModel {

}
