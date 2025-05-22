//
//  FormUpdatePersonalInfo.swift
//  IMT-iOS
//
//  Created by dev on 01/06/2023.
//

import Foundation

struct FormUpdatePersonalInfo: FormData {
    var onFilled: JBool?
    var onPassword: JBool = { _ in }
    var onPostCode: JBool = { _ in } //
    var onBirthday: JBool = { _ in }
    var onGender: JBool = { _ in }
    var onJob: JBool = { _ in }
    var onHorseRacingYear: JBool = { _ in }
    
    //MARK: Param
    var password: String? {
        didSet {
            let fill = !(password?.isEmpty ?? true)
            onPassword(fill)
        }
    }
    var birthday: String! {
        didSet {
            let fill = fillOfBirthday()
            onBirthday(fill)
        }
    }
    var sex: String?{
        didSet {
            let fill = (!(sex?.isEmpty ?? true) && sex != .placeholder.selectGender)
            onGender(fill)
        }
    }
    var job: String? {
        didSet {
            let fill = (!(job?.isEmpty ?? true) && job != .placeholder.selectProfession)
            onJob(fill)
        }
    }
    var postCode: String? {
        didSet {
            let fill = !(postCode?.isEmpty ?? true)
            onPostCode(fill)
        }
    }
    var racingStartYear: String?{
        didSet {
            let fill = (!(racingStartYear?.isEmpty ?? true) && racingStartYear != .placeholder.selectHorseRacingYear)
            onHorseRacingYear(fill)
        }
    }
    var serviceType: String?
    var regisReason: String?
    var dayOff: String?
    
    static let maxLengthPostCode: Int = 7
    
    //MARK: Logic
    var confirmPassword: String?
    var yearOfBirthday: String? {
        didSet {
            self.birthday = "\(getYear())\(getMonth())\(getDay())"
        }
    }
    var monthOfBirthday: String? {
        didSet {
            self.birthday = "\(getYear())\(getMonth())\(getDay())"
        }
    }
    var dayOfBirthday: String? {
        didSet {
            self.birthday = "\(getYear())\(getMonth())\(getDay())"
        }
    }
    var userId: String?
    var email: String!
    
    public var style: ConfirmUpdateUserStyle!
    
    init(style: ConfirmUpdateUserStyle = .new) {
        self.style = style
        self.serviceType = RegisterStepType.service.rawValue()
        self.regisReason = RegisterStepType.question.rawValue()
        self.dayOff = RegisterStepType.service.rawValue(true)
    }
    
    func toParam() -> [String : Any] {
        var blackList = ["confirmPassword",
                         "yearOfBirthday",
                         "monthOfBirthday",
                         "dayOfBirthday",
                         "userId",
                         "style",
                         "onPassword",
                         "onPostCode",
                         "onBirthday",
                         "onGender",
                         "onJob",
                         "onHorseRacingYear"]
        
        if(style == .update) {
            blackList += ["password", "email", "dayOff", "serviceType", "regisReason"]
        }
        
        //TODO: Encrypt
        var paramCustom = toParam(blackListParam: blackList)
        if(style != .update) {
            paramCustom["password"] = self.password?.encrypt()
        }
        
        paramCustom["birthday"] = self.birthday.encrypt()
        paramCustom["email"] = self.email.encrypt()
        paramCustom["postCode"] = self.postCode?.encrypt()
        
        return paramCustom
    }
    
    func requiredFieldIsFilled() -> Bool {
        
        if(self.style == .new) {
            guard let password = password, !password.isEmpty,
                  let confirmPassword = confirmPassword, !confirmPassword.isEmpty
            else { return false }
        } else {
            let user = UserManager.share().user
            let userBirthday = user?.birthday.decrypt()
            let userSex = user?.sex
            let userJob = user?.job
            let userPostCode = user?.postCode.decrypt()
            let userRacingStartYear = user?.racingStartYear
            
            let birthday = birthday ?? ""
            let sex = sex ?? ""
            let job = job ?? ""
            let postcode = postCode ?? ""
            let racingStartYear = racingStartYear ?? ""
            
            return !(empty() || exist() || placeholder())
            
            func empty() -> Bool {
                
                return birthday.isEmpty
                || birth()
                || sex.isEmpty
                || job.isEmpty
                || postcode.isEmpty
                || racingStartYear.isEmpty
            }
            
            func exist() -> Bool {
                return birthday == userBirthday && sex == userSex && job == userJob && racingStartYear == userRacingStartYear && postcode == userPostCode
            }
            
            func placeholder() -> Bool {
                return sex == String.placeholder.selectGender || job == String.placeholder.selectProfession || racingStartYear == String.placeholder.selectHorseRacingYear
            }
            
            func birth() -> Bool {
                guard let _ = birthday.toDate(IMTDateFormatter.IMTYYYYMMDD.rawValue),
                        birthday.count == IMTDateFormatter.IMTYYYYMMDD.rawValue.count else { return true }
                return false
            }
        }
        
        return true
    }
    
    func validate() -> JValidate {
        var message: IMTErrorMessage?

        if((yearOfBirthday == nil || yearOfBirthday!.isEmpty || yearOfBirthday == String.placeholder.year) && style == .new) {
            message = .yearOfBirthDayEmpty
        } else if((monthOfBirthday == nil || monthOfBirthday!.isEmpty || monthOfBirthday == String.placeholder.month) && style == .new ) {
            message = .monthOfBirthDayEmpty
        } else if((dayOfBirthday == nil || dayOfBirthday!.isEmpty || dayOfBirthday == String.placeholder.day ) && style == .new) {
            message = .dayOfBirthDayEmpty
        } else if(sex == nil || sex!.isEmpty || sex == String.placeholder.selectGender) {
            message = .sexEmpty
        } else if(postCode == nil || postCode!.isEmpty) {
            message = .postCodeInvalid
        } else if(job == nil || job!.isEmpty || job == String.placeholder.selectProfession) {
            message = .jobEmpty
        } else if (racingStartYear == nil || racingStartYear!.isEmpty || racingStartYear == String.placeholder.selectHorseRacingYear) {
            message = .horseRacingYearEmpty
        } else if((password == nil || confirmPassword == nil || password!.isEmpty || confirmPassword!.isEmpty) && style == .new) {
            message = .passwordEmpty
        } else if(style == .new && (password?.isValidPassword() == false)) {
            message = .passwordIncorrect
        } else if(style == .new && password != confirmPassword) {
            message = .passwordDifferent
        }
        
        if let message = message {
            return (message, false)
        }
        
        return (nil, true)
    }
    
    //MARK: Utility
    public func emailToString() -> String {
        return email.mailSecurity() ?? ""
    }
    
    public func birtdayToString() -> String {
        let placeholderYear = String.placeholder.year
        let placeholderMonth = String.placeholder.month
        let placeholderDay = String.placeholder.day
        let year = String(birthday.prefix(4))
        let month = String(birthday.dropFirst(4).prefix(2))
        let day = String(birthday.suffix(2))
        let prefixMonth = firstZeroIndex(month)
        let prefixDay = firstZeroIndex(day)
        
        return "\(year)\(placeholderYear)\(prefixMonth)\(placeholderMonth)\(prefixDay)\(placeholderDay)"
    }
    
    public func yearBirtdayToString() -> String {
        let placeholderYear = String.placeholder.year
        let year = String(birthday.prefix(4))

        return "\(year)\(placeholderYear)"
    }
    
    public func yearBirtdayToInt() -> Int {
        let year = Int(birthday.prefix(4)) ?? 0

        return year
    }
    
    public func monthBirtdayToString() -> String {
        let placeholderMonth = String.placeholder.month
        let month = String(birthday.dropFirst(4).prefix(2))
        let prefixMonth = firstZeroIndex(month)

        return "\(prefixMonth)\(placeholderMonth)"
    }
    
    public func dayBirtdayToString() -> String {
        let day = String(birthday.suffix(2))
        let prefixDay = firstZeroIndex(day)

        return "\(prefixDay)\(String.placeholder.day)"
    }
    
    public func racingStartYearToString() -> String {
        guard let racingStartYear = racingStartYear else { return "" }
        return "\(racingStartYear)\(String.placeholder.year)"
    }
    
    public func racingStartYearToInt() -> Int {
        guard let racingStartYear = racingStartYear else { return 0 }
        return Int(racingStartYear) ?? 0
    }
    
    public func jobToString() -> String {
        guard let rawJob = job else { return ""}
        guard let progression = Progression.getProgession(rawJob) else { return "" }
        return progression.rawValue
    }
    
    public func genderToString() -> String {
        guard let rawSex = self.sex else { return "" }
        guard let gender = Gender.getGender(rawSex) else { return "" }
        return gender.rawValue
    }
    
    public func passwordToString() -> String {
        return password?.decrypt().security() ?? ""
    }
        
    //MARK: Bundle
    public func getBundleUpdateUser(form: FormUpdatePersonalInfo?) -> [String: Any]? {
        guard let email = email,
              let userId = userId else { return nil }
        
        return ["email": email,
                "userId": userId,
                "data": form ?? "" ]
    }
    
    public func firstZeroIndex(_ text : String) -> String {
        return String(text.drop(while: { $0 == "0" }))
    }
}

//MARK: Private
extension FormUpdatePersonalInfo {
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
    
    private func fillOfBirthday() -> Bool {
        let year = getYear()
        let fillYear = (!year.isEmpty && year != .placeholder.year)
        
        let month = getMonth()
        let fillMonth = (!month.isEmpty && month != .placeholder.month)
        
        let day = getDay()
        let fillDay = (!day.isEmpty && day != .placeholder.day)
        
        return fillYear && fillMonth && fillDay
    }
}
