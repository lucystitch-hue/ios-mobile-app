//
//  FormEnterConfirmationCode.swift
//  IMT-iOS
//
//  Created by dev on 01/06/2023.
//

import Foundation

class FormEnterConfirmationCode: FormData {
    var onFilled: JBool?
    var code: String?
    
    func requiredFieldIsFilled() -> Bool {
        if let code = code, !code.isEmpty, code.trim().count == ConfirmOTPViewModel.maxLengthCode {
            return true
        }
        
        return false
    }
    
}
