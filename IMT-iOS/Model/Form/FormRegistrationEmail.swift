//
//  FormRegistrationEmail.swift
//  IMT-iOS
//
//  Created by dev on 01/06/2023.
//

import Foundation

class FormRegistrationEmail: FormData {
    var email: String?
    var onFilled: JBool?
    
    func requiredFieldIsFilled() -> Bool {
        if let email = email, !email.isEmpty, email.isValidEmail {
            return true
        } else {
            return false
        }
    }
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?
        
        if(email == nil || email!.isEmpty ) {
            message = .mailEmpty
        } else if (email != nil && (email!.contains(" ") || email!.contains("　"))) {
            message = .mailContainsSpace
        } else if (email != nil && !email!.isASCII) {
            message = .mailIsNotASCII
        } else if (email != nil && !email!.isValidEmail) {
            message = .mailInvalid
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
    }
}
