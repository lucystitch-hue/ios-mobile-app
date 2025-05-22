//
//  FormRaceHorseSearch.swift
//  IMT-iOS
//
//  Created on 20/03/2024.
//
    

import Foundation

struct FormRaceHorseSearch: FormData {
    var onFilled: JBool?
    
    var bna: String?
    var opt: String = "0"
    var ewtkbc: String = "1_2"
    var sex: String = "1_2_3"
    var del: String = "0"
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?

        if bna == nil || (bna?.count ?? 0) < 2 {
            message = .singleCharacterHorseSearch
        } else if (!validateText()) {
            message = .anythingOtherThanFullWidthKatakanaOrHiragana
        } else if (!validateCheckBox()) {
            message = .thereWasNoCorrespondingData
        } else {
            message = nil
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
        
        /*------------------------------------------------------------------------------------------------------------*/
        func validateText() -> Bool {
            let validCharacter = !(bna?.isNonKatakanaOrNonHiragana() ?? true)
            return validCharacter
        }
        
        func validateCheckBox() -> Bool {
            let validEwtkbc = ewtkbc.split(separator: "_").count > 0
            let validSex = sex.split(separator: "_").count > 0
            let validDel = del.split(separator: "_").count > 0
            return validEwtkbc || validSex || validDel
        }
    }
}
