//
//  EnterChangeEmailViewModel.swift
//  IMT-iOS
//
//  Created by dev on 28/05/2023.
//

import Foundation
import UIKit

protocol EnterChangeEmailViewModelProtocol {
    var form: FormEnterChangeEmail { get set }
    var checkLoginSuccessfully: JBundle { get set }
    
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func allowInputBegin(_ textField: UITextField)
    func gotoRegisterAndVerfiCode(_ controller: EnterChangeEmailVC?)
    func getEmail() -> String
}

class EnterChangeEmailViewModel: BaseViewModel {
    var form: FormEnterChangeEmail = FormEnterChangeEmail()
    var checkLoginSuccessfully: JBundle = { _ in }
    private var email: String?
    
    init(email: String?) {
        self.email = email
    }
}

extension EnterChangeEmailViewModel: EnterChangeEmailViewModelProtocol {
    
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString = currentString.replacingCharacters(in: range, with: string)
        let tag = textField.tag
        
        switch tag {
        case 1:
            form.password = newString
            break
        default:
            break
        }
        
        form.emit()
        
        return true
    }
    
    func allowInputBegin(_ textField: UITextField)  {
        let currentString: String = textField.text ?? ""
        let tag = textField.tag
        
        switch tag {
        case 1:
            form.password = currentString
            break
        default:
            break
        }
        
        form.emit()
    }
    
    func gotoRegisterAndVerfiCode(_ controller: EnterChangeEmailVC?) {
        guard let controller = controller else { return }
        let validate = form.validate()
        
        if(validate.valid) {
            guard let email = email, let password = form.password else { return }
            manager.call(endpoint: .checkLoginWithPassword(email: email, password: password), completion: responseCheckLogin)
        } else {
            guard let message = validate.message else { return }
            controller.showToastBottom(message.rawValue)
        }
    }
    
    func getEmail() -> String {
        return email ?? ""
    }
}

extension EnterChangeEmailViewModel {
    private func response<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void)) {
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
    
    private func responseCheckLogin(_ response: ResponseCheckLoginWithPassword?, success: Bool) {
        self.response(response) { [weak self] res in
            guard let password = self?.form.password, let bundle = self?.getBundle() else { return }
            Utils.setUserDefault(value: password, forKey: .password)
            self?.checkLoginSuccessfully(bundle)
        }
    }
}

extension EnterChangeEmailViewModel {
    //MARK: Bundle
    private func getBundle() -> [String: Any]? {
        guard let email = email else { return nil }
        guard let password = form.password else { return nil }
        
        return ["email": email,
                "password": password]
    }
}

