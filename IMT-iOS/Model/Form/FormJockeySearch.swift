//
//  FormJockeySearch.swift
//  IMT-iOS
//
//  Created on 20/03/2024.
//
    

import Foundation

struct FormJockeySearch: FormData {
    var onFilled: JBool?
    
    var text: String?
    var opt: String = "0"
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?

        if text == nil || (text?.count ?? 0) < 2 {
            message = .singleCharacterJockeySearch
        } else if (validateText()) {
            message = nil
        } else {
            message = .anythingOtherThanFullWidthKatakanaOrHiragana
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
        
        /*------------------------------------------------------------------------------------------------------------*/
        func validateText() -> Bool {
            let validCharacter = !(text?.isNonKatakanaOrNonHiragana() ?? true)
            return validCharacter
        }
    }
}
