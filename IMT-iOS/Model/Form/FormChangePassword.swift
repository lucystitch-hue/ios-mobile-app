//
//  FormChangePassword.swift
//  IMT-iOS
//
//  Created by dev on 06/06/2023.
//

import Foundation

class FormChangePassword: FormData {
    
    var currentPassword: String?
    var newPassword: String?
    var confirmNewPassword: String?
    var onFilled: JBool?
    
    func requiredFieldIsFilled() -> Bool {
        guard let newPassword = newPassword, !newPassword.isEmpty,
              let confirmNewPassword = confirmNewPassword, !confirmNewPassword.isEmpty
        else { return false }
        return true
    }
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?
        if (newPassword == nil || confirmNewPassword == nil || newPassword!.isEmpty || confirmNewPassword!.isEmpty) {
            message = .passwordEmpty
        } else if (newPassword?.isValidPassword() == false) {
            message = .passwordIncorrect
        } else if(newPassword != confirmNewPassword) {
            message = .passwordDifferent
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
    }
    
}
