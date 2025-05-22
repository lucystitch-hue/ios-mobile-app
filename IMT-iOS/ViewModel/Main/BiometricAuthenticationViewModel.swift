//
//  BiometricAuthenticationViewModel.swift
//  IMT-iOS
//
//  Created by dev on 17/08/2023.
//

import Foundation

protocol BiometricAuthenticationViewModelProtocol {
    func scan()
    func close(_ controller: BiometricAuthenticationVC?)
}

class BiometricAuthenticationViewModel: BaseViewModel {
    
}

extension BiometricAuthenticationViewModel: BiometricAuthenticationViewModelProtocol {
    func scan() {
        let biometricAuthen = IMTBiometricAuthentication()
        biometricAuthen.scan { [weak self] in
            UserManager.share().enableBiometricAuthenticationFromSetting()
            self?.gotoHome()
        }
    }
    
    func close(_ controller: BiometricAuthenticationVC?) {
        UserManager.share().disableBiometricAuthenticationFromSetting()
        UserManager.share().disableEnhanceSecuritySetting()
        self.gotoHome()
    }
}

//MARK: Private
extension BiometricAuthenticationViewModel {
    private func gotoHome() {
        Utils.gotoHome()
    }
}
