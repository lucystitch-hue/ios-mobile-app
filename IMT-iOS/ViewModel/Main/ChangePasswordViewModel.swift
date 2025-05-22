//
//  ChangePasswordViewModel.swift
//  IMT-iOS
//
//  Created by dev on 27/04/2023.
//

import Foundation
import UIKit
import SwiftyJSON

protocol ChangePasswordViewModelProtocol {
    var form: FormChangePassword { get set }
    var onChagePasswordSuccessful: JBool { get set }
    var onResetPasswordSuccessfully: JBool { get set }
    
    func back(_ controller: ChangePasswordVC)
    func changePassword(_ controller: ChangePasswordVC)
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func configAttribute( text: String)->NSAttributedString?
    func onChangeValue(_ textField: UITextField)
}

class ChangePasswordViewModel: BaseViewModel {
    var form: FormChangePassword = FormChangePassword()
    var onChagePasswordSuccessful: JBool = { _ in }
    var onResetPasswordSuccessfully: JBool = { _ in }
    private var email: String?
    private var userId: String?

    init(email: String?, userId: String?) {
        self.email = email
        self.userId = userId
        
        form.currentPassword  = Utils.getUserDefault(key: .password) ?? ""
    }
}

extension ChangePasswordViewModel: ChangePasswordViewModelProtocol {

    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString = currentString.replacingCharacters(in: range, with: string)
        let tag = textField.tag
        
        switch tag {
        case 0:
            form.currentPassword = newString
            break
        case 1:
            form.newPassword = newString
            break
        case 2:
            form.confirmNewPassword = newString
            break
            
        default:
            break
        }
        
        form.emit()
        
        return true
    }
    
    func onChangeValue(_ textField: UITextField) {
        let currentString: String = textField.text ?? ""
        let tag = textField.tag
        
        switch tag {
        case 1:
            form.newPassword = currentString
            break
        case 2:
            form.confirmNewPassword = currentString
            break
            
        default:
            break
        }
        
        form.emit()
    }

    func back(_ controller: ChangePasswordVC) {
        if(controller.isModal) {
            controller.dismiss(animated: true)
        } else {
            controller.pop()
        }
    }
    
    func configAttribute( text: String)->NSAttributedString?{
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment =  .center
        paragraphStyle.lineSpacing = 7
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    func changePassword(_ controller: ChangePasswordVC) {
        let validate = form.validate()
        
        if(validate.valid) {
            manager.call(endpoint: .changePassword( currentPassword: form.currentPassword ?? "", newPassword: form.newPassword ?? ""), completion: responseChangePassword)
        } else {
            guard let message = validate.message else { return }
            showMessageError(message: message.rawValue)
        }
    }

}

//MARK: Private 
extension ChangePasswordViewModel {
    
    private func responseChangePassword(_ response: ResponseChangePassword?, success: Bool) {
        self.handleResponse(response) { res in
            Utils.setUserDefault(value: self.form.newPassword ?? "", forKey: .password)
            self.onChagePasswordSuccessful(true)
        }
    }
    
    //TODO: Response
    private func handleResponse<R: BaseResponse>(_ response: R?, successHandler: @escaping((R) -> Void)) {
        guard let response = response else { return }
        if(response.success ) {
            guard let message = response.message else { return }
            successHandler(response)
            showMessageError(message: message)
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
}
