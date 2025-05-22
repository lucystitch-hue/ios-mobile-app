//
//  ConfirmOTPViewModel.swift
//  IMT-iOS
//
//  Created by dev on 28/05/2023.
//

import Foundation
import UIKit
import SwiftyJSON

protocol ConfirmOTPViewModelProtocol {
    var form: FormEnterConfirmationCode { get set }
    var onVerfiySuccessful: JBundle { get set }
    var onChangEmailSuccessfully: JVoid { get set }
    var onSendSuccessfully: JVoid { get set }
    var onEmail: ObservableObject<String> { get }
    var shouldHideLbSend: ObservableObject<Bool> { get }
    
    func back(_ controller: ConfirmOTPVC)
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func send(_ controller: ConfirmOTPVC?)
    func resend(_ controller: ConfirmOTPVC?)
    func hideButtonBack() -> Bool
    func onChangeInput(_ textField: UITextField)
    func gotoScreen(_ controller: ConfirmOTPVC?, bundle: [String: Any]?)
    func gotoMenu(_ controller: ConfirmOTPVC?)
}

class ConfirmOTPViewModel: BaseViewModel {
    
    //TODO: Conform protocol
    var form: FormEnterConfirmationCode = FormEnterConfirmationCode()
    var onVerfiySuccessful: JBundle = { _ in }
    var onChangEmailSuccessfully: JVoid = { }
    var onSendSuccessfully: JVoid = { }
    var shouldHideLbSend: ObservableObject<Bool> = ObservableObject(true)
    var onEmail: ObservableObject<String> = ObservableObject<String>("")
    
    static let maxLengthCode = 6
    
    var style: ConfirmOTPStyle!
    var bundle: [ConfirmOTPBundleKey: Any]?
    var sendOTPData: OTPDataModel?
    var inputScreen: ConfirmOTPFromScreen!
    
    init(style: ConfirmOTPStyle, bundle: [ConfirmOTPBundleKey: Any]?, inputScreen: ConfirmOTPFromScreen) {
        super.init()
        self.style = style
        self.bundle = bundle
        self.inputScreen = inputScreen
        self.onEmail.value = getEmail()
    }
}

//MARK: Private
extension ConfirmOTPViewModel {
    private func gotoUpdateUserInfo(_ controller: ConfirmOTPVC, bundle: [String: Any]?) {
        guard let bundle = bundle else { return }
        let vc = UpdatePersonalInfoVC(bundle: bundle)
        controller.push(vc)
    }
    
    private func gotoPasswordReset(_ controller: ConfirmOTPVC, bundle: [String: Any]?) {
        guard let bundle = bundle else { return }
        let vc = PasswordResetVC(bundle: bundle)
        controller.push(vc)
    }
    
    private func getCheckMailData() -> CheckMailDataModel? {
        guard let data = bundle?[.checkMailData] as? CheckMailDataModel else { return nil }
        return data
    }
    
    private func getEmail() -> String? {
        guard let email = bundle?[.email] as? String else { return nil }
        return email
    }
    
    private func getNewEmail() -> String? {
        guard let email = bundle?[.newEmail] as? String else { return nil }
        return email
    }
    
    private func getSendData() -> SendOTPDataModel? {
        guard let data = bundle?[.sendOTPData] as? SendOTPDataModel else { return nil }
        return data
    }
    
    private func getChangeEmailData() -> ChangeMailDataModel? {
        guard let data = bundle?[.changeEmailData] as? ChangeMailDataModel else { return nil }
        return data
    }
}

extension ConfirmOTPViewModel: ConfirmOTPViewModelProtocol {
    
    func back(_ controller: ConfirmOTPVC) {
        if(controller.isModal) {
            controller.dismiss(animated: true)
        } else {
            controller.pop()
        }
    }
    
    func gotoMenu(_ controller: ConfirmOTPVC?) {
        guard let rootVC = controller?.navigationController?.viewControllers.first else { return }
        rootVC.dismiss(animated: true)
    }
    
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        if textField.tag == 0 {
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= ConfirmOTPViewModel.maxLengthCode
        }
        
        return true
    }
    
    func onChangeInput(_ textField: UITextField) {
        let tag = textField.tag
        let value = textField.text ?? ""
        
        switch tag {
        case 0:
            form.code = value
            break
        default:
            break
        }
        
        form.emit()
    }
    
    func send(_ controller: ConfirmOTPVC?) {
        switch style {
        case .signup:
            self.verifyOTPWhenSignUp()
            break
        case .updateUserInfo:
            self.verifyOTPWhenUpdateUser()
            break
        case .resetPassword,.changePassword:
            self.verifyOTPWhenResetPassword()
            break
        case .verifyChangeEmail:
            self.verifyOTPWhenChangeEmail()
            break
        default:
            break
        }
    }
    
    func resend(_ controller: ConfirmOTPVC?) {
        guard let email = getEmail() else { return }

        switch style {
        case .signup:
            manager.call(endpoint: .checkMail(email), completion: responseCheckMail)
        default:
            manager.call(endpoint: .sendOTP(email: email), completion: responseSendOTP)
        }
    }
    
    func hideButtonBack() -> Bool {
        switch style {
        case .updateUserInfo:
            return true
        default:
            return false
        }
    }
    
    func gotoScreen(_ controller: ConfirmOTPVC?, bundle: [String: Any]?) {
        guard let controller = controller else { return }
        
        switch style {
        case .signup:
            gotoUpdateUserInfo(controller, bundle: bundle)
            break
        case .changePassword:
            controller.onSuccess?()
            break
        case .updateUserInfo:
            gotoUpdateUserInfo(controller, bundle: bundle)
            break
        case .resetPassword:
            if inputScreen == .other {
                gotoPasswordReset(controller, bundle: bundle)
            } else {
                guard let bundle = bundle else { return }
                controller.onGotoResetPassword?(bundle)
            }
            
            break
        case .verifyChangeEmail:
            break
        case .none:
            break
        }
    }
}

//MARK: API
extension ConfirmOTPViewModel {
    
    //TODO: Call
    private func verifyOTPWhenSignUp() {
        let code = form.code ?? ""
        if let sendOTPData = sendOTPData {
            //TODO: Case resend
            guard let factorId = sendOTPData.factorId else { return }
            manager.call(endpoint: .checkOTP(otpCode: code,
                                             userId: sendOTPData.userId,
                                             factorId: factorId,
                                             requestState: sendOTPData.requestState
                                            ),
                         completion: responseVerifyOTP)
        } else {
            //TODO: Case from email screen to otp screen
            guard let checkMailData = getCheckMailData() else { return }
            manager.call(endpoint: .checkOTP(otpCode: code,
                                             userId: checkMailData.userId,
                                             factorId: checkMailData.factorId,
                                             requestId: checkMailData.requestId,
                                             requestState: checkMailData.requestState),
                         completion: responseVerifyOTP)
        }
    }
    
    private func verifyOTPWhenUpdateUser() {
        onVerfiySuccessful(nil)
    }
    
    private func verifyOTPWhenChangeEmail() {
        guard let code = form.code else { return }
//        if let sendOTPData = sendOTPData {
//            //TODO: Case resend
//            guard let newEmail = getNewEmail() else { return }
//            guard let requestId = sendOTPData.requestId else { return }
//            manager.call(endpoint: .updateEmail(userId: sendOTPData.userId,
//                                                otpCode: code,
//                                                requestId: requestId,
//                                                requestState: sendOTPData.requestState,
//                                                newEmail: newEmail),
//                         completion: responseVerifyOTP)
//
//        } else {
//            //TODO: Case from enter email new screen to otp screen
//            guard let changeEmailData = getChangeEmailData() else { return }
//            manager.call(endpoint: .updateEmail(userId: changeEmailData.userId,
//                                                otpCode: code,
//                                                requestId: changeEmailData.requestId,
//                                                requestState: changeEmailData.requestState,
//                                                newEmail: changeEmailData.newEmail),
//                         completion: responseVerifyOTP)
//        }
    }
    
    private func verifyOTPWhenResetPassword() {
        let code = form.code ?? ""
        if let sendOTPData = sendOTPData {
            //TODO: Case resend
            manager.call(endpoint: .checkOTPUser(otpCode: code,
                                                 userId: sendOTPData.userId,
                                                 requestId: sendOTPData.requestId,
                                                 requestState: sendOTPData.requestState),
                         completion: responseVerifyOTP)
        } else {
            //TODO: Case from confirm email screen to otp screen
            guard let sendData = getSendData() else { return }
            manager.call(endpoint: .checkOTPUser(otpCode: code,
                                                 userId: sendData.userId,
                                                 requestId: sendData.requestId,
                                                 requestState: sendData.requestState),
                         completion: responseVerifyOTP)
            
        }
        
    }
    
    //TODO: Response
    private func handleResponse<R: BaseResponse>(_ response: R?, successHandler: @escaping((R) -> Void)) {
        guard let response = response else { return }
        if(response.success) {
            switch style {
            case .resetPassword, .verifyChangeEmail:
                guard let message = response.message else { return }
                showMessageError(message: message)
                break
            default:
                break
            }
            successHandler(response)
        } else {
            switch style {
            case .verifyChangeEmail:
                guard let message = response.message else { return }
                showMessageError(message: message)
                self.onChangEmailSuccessfully()
                break
            default:
                guard let message = response.message else { return }
                showMessageError(message: message)
                break
            }
            shouldHideLbSend.value = true

        }
    }
    
    private func responseVerifyOTP(_ response: ResponseCheckOTP?, success: Bool) {
        self.handleResponse(response) {  [weak self] res in
            
            switch self?.style {
            case .verifyChangeEmail:
                self?.onChangEmailSuccessfully()
                break
            default :
                guard let userId = res.data?.userId else { return }
                let email = self?.getEmail()
                
                let bundle = ["userId": userId,
                              "email": email]
                
                self?.onVerfiySuccessful(bundle as [String : Any])
                break
            }
        }
    }
    
    private func responseSendOTP(_ response: ResponseSendOTP?, success: Bool) {
        self.handleResponse(response) { [weak self] res in
            self?.sendOTPData = res.data
            self?.onSendSuccessfully()
        }
    }
    
    private func responseCheckMail(_ response: ResponseCheckMail?, success: Bool) {
        self.handleResponse(response) { [weak self] res in
            self?.sendOTPData = res.data
            self?.onSendSuccessfully()
        }
    }
}
