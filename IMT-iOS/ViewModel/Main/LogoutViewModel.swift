//
//  LogoutViewModel.swift
//  IMT-iOS
//
//  Created by dev on 28/04/2023.
//

import Foundation
import SwiftyJSON

protocol LogoutViewModelProtocol {
    func logout()
    func close(_ controller: LogoutVC)
}

class LogoutViewModel: BaseViewModel {
    
}

extension LogoutViewModel: LogoutViewModelProtocol {
    func logout() {
        Utils.logActionClick(.logout)
        Utils.postLogout()
    }
    
    func close(_ controller: LogoutVC) {
        controller.dismiss(animated: false)
    }
}

extension LogoutViewModel {
    
    private func responseLogout(_ response: ResponseLogOut?, success: Bool) {
        self.handleResponse(response) {  res in
        }
    }
    
    //TODO: Response
    private func handleResponse<R: BaseResponse>(_ response: R?, successHandler: @escaping((R) -> Void)) {
        guard let response = response else { return }
        if(response.success ) {
            successHandler(response)
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
}
