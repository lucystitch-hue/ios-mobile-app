
//
//  FormConfirmForgotPasswordInformation.swift
//  IMT-iOS
//
//  Created by dev on 06/06/2023.
//

import Foundation

class FormConfirmForgotPasswordInformation: FormData {
    
    var onFilled: JBool?
    
    //MARK: Param
    var email: String?
    
    //MARK: Logic
    var yearOfBirthday: String?{
        didSet {
            self.birthday = "\(getYear())\(getMonth())\(getDay())"
        }
    }
    var monthOfBirthday: String?{
        didSet {
            self.birthday = "\(getYear())\(getMonth())\(getDay())"
        }
    }
    var dayOfBirthday: String?{
        didSet {
            self.birthday = "\(getYear())\(getMonth())\(getDay())"
        }
    }
    
    var birthday: String?
    
    func toParam() -> [String : Any] {
        return toParam(blackListParam: ["yearOfBirthday",
                                        "monthOfBirthday",
                                        "dayOfBirthday"])
    }
    
    func requiredFieldIsFilled() -> Bool {
        if let yearOfBirthday = yearOfBirthday, !yearOfBirthday.isEmpty,
            let monthOfBirthday = monthOfBirthday, !monthOfBirthday.isEmpty,
            let dayOfBirthday = dayOfBirthday, !dayOfBirthday.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?
        if(yearOfBirthday == nil || yearOfBirthday!.isEmpty) {
            message = .yearOfBirthDayEmpty
        } else if(monthOfBirthday == nil || monthOfBirthday!.isEmpty) {
            message = .monthOfBirthDayEmpty
        } else if(dayOfBirthday == nil || dayOfBirthday!.isEmpty) {
            message = .dayOfBirthDayEmpty
        } else if (email != nil && (email!.contains(" ") || email!.contains("　"))) {
            message = .mailContainsSpace
        } else if (email != nil && !email!.isASCII) {
            message = .mailIsNotASCII
        } else if(email == nil || email!.isEmpty ) {
            message = .mailEmpty
        } else if (email != nil && !email!.isValidEmail) {
            message = .mailInvalid
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
    }
    
}


//MARK: Private
extension FormConfirmForgotPasswordInformation {
    private func getYear() -> String {
        guard let year = yearOfBirthday?.prefix(4) else { return "" }
        return String(year)
    }
    
    private func getMonth() -> String {
        guard let monthOfBirthday = monthOfBirthday else { return "" }
        let endIndex = monthOfBirthday.index(monthOfBirthday.startIndex, offsetBy: monthOfBirthday.count - 1)
        let month = monthOfBirthday[..<endIndex]
        guard let month  = String(month).toMonth() else { return "" }
        return String(month)
    }
    
    private func getDay() -> String {
        guard let dayOfBirthday = dayOfBirthday else { return "" }
        let endIndex = dayOfBirthday.index(dayOfBirthday.startIndex, offsetBy: dayOfBirthday.count - 1)
        let day = dayOfBirthday[..<endIndex]
        guard let day  = String(day).toDay() else { return "" }
        return String(day)
    }
    

}
