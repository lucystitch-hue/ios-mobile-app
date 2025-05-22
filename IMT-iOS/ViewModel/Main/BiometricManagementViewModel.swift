//
//  BiometricManagementViewModel.swift
//  IMT-iOS
//
//  Created by dev on 28/08/2023.
//

import Foundation

protocol BiometricManagementProtocol {
    var onInvalid: JVoid { get set }
    var flagSwitch: ObservableObject<(isInitial: Bool , switchValue: Bool)>{ get set }
    var enhanceSecuritySwitch: ObservableObject<Bool> { get set }
    
    func switchBiometric(_ controller: BiometricManagementVC?)
    func recheckStateBiometric(_ controller: BiometricManagementVC?)
    func switchEnhanceSecurity()
}

class BiometricManagementViewModel {
    var onInvalid: JVoid = { }
    var flagSwitch: ObservableObject<(isInitial: Bool , switchValue: Bool)> = ObservableObject<(isInitial: Bool , switchValue: Bool)>((true, UserManager.share().useBiometricAuthenticationInSetting()))
    var enhanceSecuritySwitch: ObservableObject<Bool> = ObservableObject<Bool>(UserManager.share().didUseEnhanceSecuritySetting())
    
}

extension BiometricManagementViewModel: BiometricManagementProtocol {
    func switchBiometric(_ controller: BiometricManagementVC?) {
        let can = IMTBiometricAuthentication.can()
        let enable = flagSwitch.value?.switchValue ?? false
        
        if(can) {
            if(enable) {
                let faceIDAuthen = IMTBiometricAuthentication()
                faceIDAuthen.scan {
                    UserManager.share().enableBiometricAuthenticationFromSetting()
                } failureCompletion: { [weak self] message in
                    self?.flagSwitch.updateNoBind((false, false))
                    self?.onInvalid()
                }
            } else {
                UserManager.share().disableBiometricAuthenticationFromSetting()
                UserManager.share().disableEnhanceSecuritySetting()
            }
        } else {
            if(enable) {
                guard let controller = controller else { return }
                let vc = BiometricWarningVC()
                
                vc.onDismiss = { [weak self] in
                    self?.flagSwitch.updateNoBind((false, false))
                    self?.onInvalid()
                }
                
                controller.presentOverFullScreen(vc)
            } else {
                UserManager.share().disableBiometricAuthenticationFromSetting()
            }
        }
    }
    
    func recheckStateBiometric(_ controller: BiometricManagementVC?) {
        let can = IMTBiometricAuthentication.can()
        if(!can) {
            //TODO: Update local data
            UserManager.share().disableBiometricAuthenticationFromSetting()
            UserManager.share().disableEnhanceSecuritySetting()
            
            //TODO: Update on user interface
            enhanceSecuritySwitch.updateNoBind(false)
            flagSwitch.value = (true, false)
        }
    }
    
    func switchEnhanceSecurity() {
        guard let enhanceSecuritySwitch = enhanceSecuritySwitch.value else { return }
        self.enhanceSecuritySwitch.value = !enhanceSecuritySwitch
        UserManager.share().enableEnhanceSecuritySetting((!enhanceSecuritySwitch).description)
    }
}
