//
//  ResultUpdateEmailSuccessViewModel.swift
//  IMT-iOS
//
//  Created by dev on 31/08/2023.
//

import Foundation

protocol ResultUpdateEmailSuccessProtocol {
    var onDidResend: JVoid { get set }
    func resend()
}

class ResultUpdateEmailSuccessViewModel: BaseViewModel {
    var onDidResend: JVoid = { }
    
    private var newEmail: String!
    private var password: String!
    
    init(newEmail: String, password: String) {
        super.init()
        self.newEmail = newEmail
        self.password = password
    }
}

extension ResultUpdateEmailSuccessViewModel: ResultUpdateEmailSuccessProtocol {
    func resend() {
        manager.call(endpoint: .requestChangeEmail(newEmail: newEmail, password: password), completion: responseChangeEmail)
    }
}

extension ResultUpdateEmailSuccessViewModel {
    private func responseChangeEmail(_ response: ResponseChangeMail?, success: Bool) {
        if let response = response {
            let message = response.message ?? ""
            showMessageError(message: message)
        }
    }
}
