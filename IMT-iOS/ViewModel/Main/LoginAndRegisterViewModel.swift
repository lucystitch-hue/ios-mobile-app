//
//  LoginAndRegisterViewModel.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import Foundation

enum LoginAndRegisterMode {
    case login
    case register
    
    func title() -> String {
        switch self {
        case .login:
            return .TitleScreen.login
        case .register:
            return .TitleScreen.register
        }
    }
    
    func titleLoginWithMail() -> String {
        switch self {
        case .login:
            return .loginScreen.titleLoginWithEmail
        case .register:
            return .registerScreen.titleLoginWithEmail
        }
    }
}

enum LoginAndRegisterValidate: String {
    case success = "success"
    case failure = "failure"
}

class LoginAndRegisterViewModel: BaseViewModel {
    public var onLoginSuccess:((LoginAndRegisterValidate) -> Void) = { _ in }
    
    func gotoHome(_ controller: LoginAndRegisterVC?) {
        Utils.postObserver(.didLoginSuccessfully, object: true)
    }
    
    func loginWithUserName(_ username: String) {
//        manager.call(endpoint: .login(username), completion: responseLogin)
    }
}

