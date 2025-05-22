//
//  FormEnterChangeEmail.swift
//  IMT-iOS
//
//  Created by dev on 15/06/2023.
//

import Foundation

class FormEnterChangeEmail: FormData {
    var password: String?
    
    var onFilled: JBool?
    
    func requiredFieldIsFilled() -> Bool {
        if let password = password, !password.isEmpty == true {
            return true
        } else {
            return false
        }
    }
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?
        
        if (password == nil || password!.isEmpty)  {
            message = .passwordEmpty
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
    }
    
}
