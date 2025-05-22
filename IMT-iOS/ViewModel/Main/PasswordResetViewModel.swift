//
//  PasswordResetViewModel.swift
//  IMT-iOS
//
//  Created by dev on 04/05/2023.
//

import Foundation
import UIKit
import SwiftyJSON

protocol PasswordResetViewModelProtocol {
    var form: FormResetPassword { get set }
    var onResetPasswordSuccessfull:JBool { get set }
    
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func onChangeValue(_ textField: UITextField)
    func resetPassword(_ controller: PasswordResetVC)
}

class PasswordResetViewModel: BaseViewModel {
    var form: FormResetPassword = FormResetPassword()
    var onResetPasswordSuccessfull:JBool = { _ in }
    var bundle: [String: Any]?
    
    init(bundle: [String: Any]?) {
        self.bundle = bundle
    }
}

extension PasswordResetViewModel: PasswordResetViewModelProtocol {
    
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString = currentString.replacingCharacters(in: range, with: string)
        let tag = textField.tag
        
        switch tag {
        case 0:
            form.newPassword = newString
            break
        case 1:
            form.confirmNewPassword = newString
            break
            
        default:
            break
        }
        
        form.emit()
        
        return true
    }
    
    func onChangeValue(_ textField: UITextField) {
        let currentString = textField.text ?? ""
        let tag = textField.tag
        
        switch tag {
        case 0:
            form.newPassword = currentString
            break
        case 1:
            form.confirmNewPassword = currentString
            break
            
        default:
            break
        }
        
        form.emit()
    }
    
    func resetPassword(_ controller: PasswordResetVC) {
        guard let userId = bundle?["userId"] as? String else { return  }
        let validate = form.validate()
        
        if(validate.valid) {
            manager.call(endpoint: .resetPassword(userId: userId , newPassword: form.newPassword ?? ""), completion: responsePasswordReset)
        } else {
            guard let message = validate.message else { return }
            controller.showToastBottom(message.rawValue)
        }
    }
}


//MARK: Response
extension PasswordResetViewModel {
    private func responsePasswordReset(_ response: ResponseResetPassword?, success: Bool) {
        self.handleResponse(response) {  res in
            self.onResetPasswordSuccessfull(true)
            
            let newPassword = self.form.newPassword ?? ""
            Utils.setUserDefault(value: newPassword, forKey: .password)
        }
    }
    
    //TODO: Response
    private func handleResponse<R: BaseResponse>(_ response: R?, successHandler: @escaping((R) -> Void)) {
        guard let response = response else { return }
        if(response.success ) {
            guard let message = response.message else { return }
            showMessageError(message: message)
            successHandler(response)
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }}
