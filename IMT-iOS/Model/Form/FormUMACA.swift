//
//  FormUMACA.swift
//  IMT-iOS
//
//  Created by dev on 05/10/2023.
//


import Foundation

class FormUMACA: FormData {
    var onFilled: JBool?
    
    var cardNumber: String?
    var birthday: String?
    var pinCode: String?
    var umacaFlg: String?
    
    static let maxLengthCardNumber: Int = 12
    static let maxLengthBirthday: Int = 8
    static let maxLengthPinCode: Int = 4
    
    init(intitalFromUserManager: Bool = false) {
        if(intitalFromUserManager) {
            let userId = Utils.getUserDefault(key: .userId) ?? ""
            if let umacaTickets = Utils.getDictUserDefault(key: .umacaTickets), let umaca = umacaTickets[userId] as? [String: String] {
                cardNumber = umaca["cardNumber"]
                birthday = umaca["birthday"]
                pinCode = umaca["pinCode"]
                umacaFlg = umaca["umacaFlg"]
            }
        }
    }
    
    func clearData() {
        cardNumber = ""
        birthday = ""
        pinCode = ""
        umacaFlg = ""
    }
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?

        if(cardNumber == nil || birthday == nil || pinCode == nil || cardNumber?.count == 0 || birthday?.count == 0 || pinCode?.count == 0) {
            message = .emptyNumber
        } else if (validateCardNumber() && validatePinCode() && validateBirthday()) {
            message = nil
        } else {
            message = .missingNumber
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
        
        /*------------------------------------------------------------------------------------------------------------*/
        func validateCardNumber() -> Bool {
            let validLength = cardNumber?.count == FormUMACA.maxLengthCardNumber
            let validCharacter = cardNumber?.isASCII ?? false && cardNumber?.isNumbers ?? false
            return validLength && validCharacter
        }
        
        func validateBirthday() -> Bool {
            guard let date = birthday?.toDate(IMTDateFormatter.IMTYYYYMMDD.rawValue, checkFull: false) else { return false }
            let year = date.getYear()
            
            let validLength = birthday?.count == FormUMACA.maxLengthBirthday
            let validLimit = year >= Constants.System.fromYear && year <= Constants.System.toYear
            let validCharacter = birthday?.isASCII ?? false && birthday?.isNumbers ?? false
            return validLength && validLimit && validCharacter
        }
        
        func validatePinCode() -> Bool {
            let validLength = pinCode?.count == FormUMACA.maxLengthPinCode
            let validCharacter = pinCode?.isASCII ?? false && pinCode?.isNumbers ?? false
            return validLength && validCharacter
        }
        /*------------------------------------------------------------------------------------------------------------*/

        
        
    }
    
    func toParam() -> [String : Any] {
        guard let cardNumber = cardNumber,
              let birthday = birthday,
              let pinCode = pinCode,
              let umacaFlg = umacaFlg
        else { return [:] }

        return ["cardNumber": cardNumber,
                "birthday": birthday,
                "pinCode": pinCode,
                "umacaFlg": umacaFlg]
    }
}
