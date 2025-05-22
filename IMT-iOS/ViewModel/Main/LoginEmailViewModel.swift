//
//  LoginEmailViewModel.swift
//  IMT-iOS
//
//  Created by dev on 24/04/2023.
//

import Foundation
import UIKit
import SwiftyJSON

enum LoginEmailValidate: String {
    case none = ""
    case success = "success"
    case failure = "failure"
}

protocol LoginEmailViewModelProtocol: BaseLoginViewModel, IMTForceUpdateProtocol{
    var onReminderAccount: ObservableObject<(form: FormLoginEmail?, isIntital: Bool)> { get set }
    var onBiometricAuthen: ObservableObject<(show: Bool, isIntital: Bool)> { get set }
    var form: FormLoginEmail { get set }
    
    func gotoForgotPassword(_ controller: LoginEmailVC?)
    func gotoSignUp(_ controller: LoginEmailVC?)
    func login()
    func scanToLogin(_ controller: LoginEmailVC?, checkVersion: Bool)
    
    func gotoHome(_ controller: LoginEmailVC?)
    func gotoBiometricAuth(_ controller: LoginEmailVC?)
    
    func onBiometricAuthenticationIfNeed(_ controller: LoginEmailVC?)
    func onChangeInput(_ textField: UITextField)
    func biometricAuthen(_ controller: LoginEmailVC?, checkVersion: Bool)
    func getVersionApp() -> String
}

class LoginEmailViewModel: BaseViewModel {
    
    var onReminderAccount: ObservableObject<(form: FormLoginEmail?, isIntital: Bool)> = ObservableObject<(form: FormLoginEmail?, isIntital: Bool)>((nil, true))
    var onBiometricAuthen: ObservableObject<(show: Bool, isIntital: Bool)> = ObservableObject<(show: Bool, isIntital: Bool)>((false, true))
    var onLoginSuccessfully: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var onDidResultCheckVerion: ((AppVersionUpdateState) -> Void) = { _ in }
    
    var form: FormLoginEmail = FormLoginEmail()
    var needScanBiometric = true
    var cancelBiometric = false

    init(controller: LoginEmailVC) {
        super.init()
        //        configReminderAccount()
        self.checkBiometric()
    }
}

//MARK: Private
extension LoginEmailViewModel {
    
    private func checkBiometric() {
        let allow = allowBitometricAuthentication()
        onBiometricAuthen.value = (show: allow, isIntital: false)
    }
    
    private func checkShowTerm() -> Bool {
        return true
    }
    
    private func configReminderAccount() {
        let env = Utils.getEnviroment()
        reminderAccountIfNeed(env)
    }
    
    private func reminderAccountIfNeed(_ env: Enviroment) {
        if(env == .develop) {
            let email = Utils.getUserDefault(key: .email)
            let password = Utils.getUserDefault(key: .password)
            
            form = FormLoginEmail(email: email, password: password)
            self.onReminderAccount.value = ((form, false))
        } else {
            form = FormLoginEmail()
        }
    }
    
    private func allowBitometricAuthentication() -> Bool {
        let useBiometricInSetting = UserManager.share().useBiometricAuthenticationInSetting()
        let needBiometricAuthen = UserManager.share().didUseBiomatricAuthentication()
        let biometricInNativeSetting = IMTBiometricAuthentication.getStyle() != .none
        let allow = useBiometricInSetting && needBiometricAuthen && biometricInNativeSetting
        
        return allow
    }
    
    private func loginAfterCheckVersion(_ needCheckVersion: Bool = true) {
        let validate = form.validate()
        
        if(validate.valid == true) {
            if(needCheckVersion) {
                Utils.showProgress()
                checkVersion {
                    self.loginWithUserName(self.form, needValidate: false)
                }
            } else {
                self.loginWithUserName(self.form, needValidate: false)
            }
        } else {
            guard let message = validate.message?.rawValue else { return }
            showMessageError(message: message)
        }
    }
    
    private func scanningOfBiometric(_ checkVersion: Bool = true) {
        let faceIDAuthen = IMTBiometricAuthentication()
        faceIDAuthen.scan { [weak self] in
            self?.needScanBiometric = false
            if let email = Utils.getUserDefault(key: .email),
               let password = Utils.getUserDefault(key: .password) {
                self?.form.email = email
                self?.form.password = password
                self?.loginAfterCheckVersion(checkVersion)
            } else {
                self?.showMessageError(message: "Error local data")
                Utils.deleteUserDefault(key: .didUseBiomatricAuthentication)
            }
        } failureCompletion: { [weak self] message in
            self?.cancelBiometric = true
            return
        }
    }
    
}

extension LoginEmailViewModel: LoginEmailViewModelProtocol {
    
    func gotoForgotPassword(_ controller: LoginEmailVC?) {
        guard let controller = controller else { return }
        let vc = UINavigationController(rootViewController: ConfirmForgotPasswordInformationVC())
        vc.navigationBar.isHidden = false
        controller.presentOverFullScreen(vc, animate: false)
    }
    
    func gotoSignUp(_ controller: LoginEmailVC?) {
        guard let controller = controller else { return }
        let mailVC = MailVerificationVC(style: .signup)
        let vc = UINavigationController(rootViewController: mailVC)
        
        vc.navigationBar.isHidden = false
        controller.presentOverFullScreen(vc)
    }
    
    func gotoHome(_ controller: LoginEmailVC?) {
        Utils.gotoHome()
    }
    
    func gotoBiometricAuth(_ controller: LoginEmailVC?) {
        guard let controller = controller else { return }
        let vc = BiometricAuthenticationVC()
        controller.push(vc)
    }
    
    func login() {
        loginAfterCheckVersion()
    }
    
    func scanToLogin(_ controller: LoginEmailVC?, checkVersion: Bool) {
        let didUseBiomatricAuthentication = UserManager.share().didUseBiomatricAuthentication()
        if(didUseBiomatricAuthentication) {
            if (checkVersion) {
                self.checkVersion(continue: {
                    self.scanningOfBiometric(false)
                })
            } else {
                self.scanningOfBiometric(!checkVersion)
            }
        } else {
            showMessageError(message: "Biometric authentication is not available.")

        }
    }

    func onChangeInput(_ textField: UITextField) {
        let tag = textField.tag
        let value = textField.text ?? ""
        
        switch tag {
        case 0:
            form.email = value
            break
        case 1:
            form.password = value
        default:
            break
        }
        
        form.emit()
    }
    
    func onBiometricAuthenticationIfNeed(_ controller: LoginEmailVC?) {
        let didUseBiometricAuthen = UserManager.share().didUseBiomatricAuthentication()
        let style = IMTBiometricAuthentication.getStyle()
        
        if(!didUseBiometricAuthen && style != .none) {
            Utils.hideProgress()
            gotoBiometricAuth(controller)
        } else {
            gotoHome(controller)
        }
        
        self.cancelBiometric = false
    }
    
    func biometricAuthen(_ controller: LoginEmailVC?, checkVersion: Bool) {
        UserManager.share().checkLoginWhenChangeEmail { [weak self] (change, data) in
            if let change = change, !change {
                let allow = self?.allowBitometricAuthentication() ?? false
                
                if(allow) {
                    self?.scanToLogin(controller, checkVersion: checkVersion)
                } else {
                    UserManager.share().disableBiometricAuthenticationFromSetting()
                    UserManager.share().disableEnhanceSecuritySetting()
                }
            }
        }
    }
    
    func getVersionApp() -> String {
        return "現在のアプリバージョン \(Bundle.main.releaseVersionNumberPretty)   "
    }
    
    func continueWhenCancelUpgrade(_ controller: BaseViewController?) {
        execute()
        
        /*-----------------------------------------------------------------------------------------*/
        func execute() {
            let access = accessBiometric()
            if(access) {
                scanningOfBiometric(false)
            } else {
                self.loginWithUserName(self.form, needValidate: false)
            }
        }
        
        func isLastAccountLogin() -> Bool {
            var asAccount = true
            
            if let email = form.email, !email.isEmpty {
                asAccount = UserManager.share().asAccount(email: email)
            }
            
            return asAccount
        }
        
        func accessBiometric() -> Bool {
            let allowBiometric = self.allowBitometricAuthentication()
            let didUseBiometricAuthen = UserManager.share().didUseBiomatricAuthentication()
            let asAccount = isLastAccountLogin()
            
            if(asAccount && cancelBiometric) {
                needScanBiometric = false
            }
            
            return allowBiometric && didUseBiometricAuthen && asAccount && needScanBiometric
        }
        /*-----------------------------------------------------------------------------------------*/
        
    }
}
