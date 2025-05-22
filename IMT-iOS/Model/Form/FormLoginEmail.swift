//
//  FormLoginEmail.swift
//  IMT-iOS
//
//  Created by dev on 09/06/2023.
//

import UIKit

class FormLoginEmail: FormData {
    var onFilled: JBool?
    
    var email: String?
    var password: String?
    
    func requiredFieldIsFilled() -> Bool {
        let email = email ?? ""
        let password = password ?? ""
        
        if(email.isEmpty && password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    init(email: String? = "", password: String? = "") {
        self.email = email
        self.password = password
    }
    
    func validate() -> JValidate {
        if self.email == nil ||
            self.email?.isEmpty == true ||
            self.email?.isValidEmail == false {
            return (.emailJInvalid, false)
        } else if self.password == nil || self.password?.isEmpty == true {
            return (.passwordJInvalid, false)
        } else {
            return (nil, true)
        }
    }
    
    func toParam() -> [String : Any] {
        var paramCustom = self.toParam(blackListParam: [])
        paramCustom["email"] = email?.encrypt()
        paramCustom["password"] = password?.encrypt()
        
        return paramCustom
    }
}
