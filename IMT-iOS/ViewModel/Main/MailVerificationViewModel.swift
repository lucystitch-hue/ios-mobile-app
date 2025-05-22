//
//  SignUpAndVerificationEmailViewModel.swift
//  IMT-iOS
//
//  Created by dev on 02/06/2023.
//

import Foundation
import UIKit
import SwiftyJSON

protocol MailVerificationViewModelProtocol: IMTForceUpdateProtocol {
    var form: FormRegistrationEmail { get set }
    var onVerifySuccessful: (([ConfirmOTPBundleKey: Any]?) -> Void) { get set }
    var onUpdateEmail: (([ResultChangeEmailBundleKey: Any?]) -> Void) { get set }
    
    func back(_ controller: MailVerificationVC)
    func hideButtonBack() -> Bool
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func onChangeInput(_ textField: UITextField)
    func send(_ controller: MailVerificationVC)
    func gotoConfirmCode(_ controller: MailVerificationVC?, bundle: [ConfirmOTPBundleKey: Any]?)
}

class MailVerificationViewModel: BaseViewModel {
    var form: FormRegistrationEmail = FormRegistrationEmail()
    var onUpdateEmail: (([ResultChangeEmailBundleKey: Any?]) -> Void) = { _ in }
    var onVerifySuccessful: (([ConfirmOTPBundleKey : Any]?) -> Void) = { _ in }
    var bundle: [ConfirmOTPBundleKey: Any]?
    var onDidResultCheckVerion: ((AppVersionUpdateState) -> Void) = { _ in }
    
    private var style: MailVerificationStyle!
    private var oldEmail: String?
    private var password: String?
    
    init(style: MailVerificationStyle, oldEmail: String?, password: String?) {
        self.style = style
        self.oldEmail = oldEmail
        self.password = password
    }
}

extension MailVerificationViewModel: MailVerificationViewModelProtocol {
    
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString = currentString.replacingCharacters(in: range, with: string)
        form.email = newString
        return true
    }
    
    func onChangeInput(_ textField: UITextField) {
        form.email = textField.text
    }
    
    func back(_ controller: MailVerificationVC) {
        if(controller.isModal) {
            controller.dismiss(animated: true)
        } else {
            controller.pop()
        }
    }
    
    func hideButtonBack() -> Bool {
        switch style {
        case .changeEmail:
            return false
        default:
            return true
        }
    }
    
    func send(_ controller: MailVerificationVC) {
        switch style {
        case .signup:
            self.signup(controller)
            break
        case .changeEmail:
            changeMail(controller)
            break
        case .sendCodeChangePassword, .sendCodeForgotPassword:
            sendOpt(controller)
        default:
            break
        }
    }
    
    func gotoConfirmCode(_ controller: MailVerificationVC?, bundle: [ConfirmOTPBundleKey: Any]?) {
        guard let controller = controller else { return }
        if (style == .sendCodeChangePassword) {
            controller.onGotoConfirmOtp?(bundle, .changePassword)
        } else if(style == .sendCodeForgotPassword) {
            controller.onGotoConfirmOtp?(bundle, .resetPassword)
        } else {
            let confirmCodeVC = ConfirmOTPVC(style: style.confirmOTPStyle(), bundle: bundle)
            controller.push(confirmCodeVC)
        }
    }
    
    func continueWhenCancelUpgrade(_ controller: BaseViewController?) {
        guard let controller = controller as? MailVerificationVC else { return }
        signup(controller, didCheckVersion: true)
    }
}

//MARK: API
extension MailVerificationViewModel {
    
    //TODO: Call
    private func signup(_ controller: MailVerificationVC, didCheckVersion: Bool = false) {
        let email = form.email ?? ""
        let validate = form.validate()
        
        if(validate.valid) {
            if(didCheckVersion) {
                manager.call(endpoint: .checkMail(email), completion: responseCheckMail)
            } else {
                Utils.showProgress()
                checkVersion {
                    self.manager.call(endpoint: .checkMail(email), showLoading: false, completion: self.responseCheckMail)
                }
            }
        } else {
            guard let message = validate.message else { return }
            controller.showToastBottom(message.rawValue)
        }
    }
    
    private func changeMail(_ controller: MailVerificationVC) {
        let email = form.email ?? ""
        guard let password = password else { return }
        let validate = form.validate()
        
        if(validate.valid) {
            manager.call(endpoint: .requestChangeEmail(newEmail:email, password: password), completion: responseChangeEmail)
        } else {
            guard let message = validate.message else { return }
            controller.showToastBottom(message.rawValue)
        }
        
    }
    
    private func sendOpt(_ controller: MailVerificationVC) {
        manager.call(endpoint: .sendOTP(email: self.oldEmail ?? ""), completion: responseSendOTP)
    }
    
    //TODO: Response
    private func handleResponse<R: BaseResponse>(_ response: R?, successHandler:@escaping(JVoid) = {} ) {
        guard let response = response else { return }
        if(response.success) {
            successHandler()
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
    
    private func responseChangeEmail(_ response: ResponseChangeMail?, success: Bool) {
        if let response = response {
            if(response.success) {
                let newEmail = form.email ?? ""
                let password = password ?? ""
                
                let bundle: [ResultChangeEmailBundleKey: Any?] = [.result: true,
                                                                  .email: newEmail,
                                                                  .password: password,
                                                                  .errorMessage: nil]
                
                    self.onUpdateEmail(bundle)
            } else {
                let bundle: [ResultChangeEmailBundleKey: Any?] = [.result: false,
                                                                  .errorMessage: response.message]
                
                self.onUpdateEmail(bundle)
            }
        }
    }
    
    private func responseCheckMail(_ response: ResponseCheckMail?, success: Bool) {
        Utils.hideProgress()
        handleResponse(response) { [weak self] in
        
            if let email = self?.form.email,
               let data = response?.data {
                self?.bundle = [.email: email,
                          .checkMailData: data]
            }
            
            self?.onVerifySuccessful(self?.bundle)
        }
    }
    
    private func responseSendOTP(_ response: ResponseSendOTP?, success: Bool) {
        handleResponse(response) { [weak self] in
            if let data = response?.data {
                
                self?.bundle = [.email: self?.oldEmail ?? "",
                          .sendOTPData: data]
            }
            
            self?.onVerifySuccessful(self?.bundle)
        }
    }
}
