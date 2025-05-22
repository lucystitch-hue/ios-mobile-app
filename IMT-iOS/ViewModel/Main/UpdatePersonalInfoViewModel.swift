//
//  MenuRegisterInforViewModel.swift
//  IMT-iOS
//
//  Created by dev on 14/03/2023.
//
import Foundation
import UIKit

protocol UpdatePersonInfoViewModelProtocol {
    
    var indexYear: Int { get set }
    var indexMonth: Int { get set }
    var indexDay: Int { get set }
    var indexGender: Int { get set }
    var indexProfession: Int { get set }
    var indexHorceRaceYear: Int { get set }
    
    var years: ObservableObject<[IDateModel]> { get set }
    var months: ObservableObject<[IDateModel]> { get set }
    var days: ObservableObject<[IDateModel]> { get set }
    var horseRaceYears: ObservableObject<[IDateModel]> { get set }
    var genders: ObservableObject<[String]> { get set }
    var professions: ObservableObject<[String]> { get set }
    var onLoadEmail: ObservableObject<String> { get set }
    var onUpdateSuccessfully: JVoid { get set }
    var onCheckPostCodeSuccessfully: JVoid { get set }
    var onLoadUserInfo: ObservableObject<(form: FormUpdatePersonalInfo?,isIntital: Bool)> { get set }
    var form: FormUpdatePersonalInfo { get set }
    
    var onChangeDay: ((_ strDay: String, _ index: Int) -> Void) { get set }
    
    func gotoNextStep(_ controller: UpdatePersonalInfoVC)
    func back(_ controller: UpdatePersonalInfoVC?)
    func validate() -> UpdatePersonInfoError
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func onChoiceCombobox(_ combobox: DropDown, atIndex index: Int, value: String?)
    func onInputChange(_ textField: UITextField, text: String?)
    func getTitle() -> String
    func executeStep(_ controller: UpdatePersonalInfoVC?)
    func executeUpdateSuccess(_ controller: UpdatePersonalInfoVC?)
    func getBlackListYear() -> [Int]
    func getBlackListMonth() -> [Int]
    func getBlackListDay() -> [Int]
    func formatDropdown(_ label: UILabel, value: String, indexAt index: Int, action selectionAction: @escaping(_ index: Int) -> Void)
    func getIndexOfDefaultYear() -> Int
    func getIndexYear(year: Int) -> Int
    func getIndexHorseRaceYear(year: Int) -> Int
}

class UpdatePersonalInfoViewModel: BaseViewModel {
    
    var indexYear: Int = -1 {
        didSet {
            updateDays()
        }
    }
    var indexMonth: Int = -1 {
        didSet {
            updateDays()
        }
    }
    var indexDay: Int = -1
    var indexGender: Int = -1
    var indexProfession: Int = -1
    var indexHorceRaceYear: Int = -1
    var years: ObservableObject<[IDateModel]> = ObservableObject<[IDateModel]>([])
    var months: ObservableObject<[IDateModel]> = ObservableObject<[IDateModel]>([])
    var days: ObservableObject<[IDateModel]> = ObservableObject<[IDateModel]>([])
    var horseRaceYears: ObservableObject<[IDateModel]> = ObservableObject<[IDateModel]>([])
    var genders: ObservableObject<[String]> = ObservableObject<[String]>([])
    var professions: ObservableObject<[String]> = ObservableObject<[String]>([])
    var onLoadEmail: ObservableObject<String> = ObservableObject<String>("")
    var form: FormUpdatePersonalInfo = FormUpdatePersonalInfo()
    var onChangeDay: ((String, Int) -> Void) = { _,_ in }
    var onUpdateSuccessfully: JVoid = {}
    var onCheckPostCodeSuccessfully: JVoid = {}
    var onLoadUserInfo: ObservableObject<(form: FormUpdatePersonalInfo?, isIntital: Bool)> = ObservableObject<(form: FormUpdatePersonalInfo?, isIntital: Bool)>((nil, true))
    let birthYearFrom = 1900
    let birthYearDefault = 1990
    let horseRaceYearsFrom = 1945
    let dataOfStep: [RegisterStepType: [InputStepRegisterModel]] = [.service: RegisterStepType.service.items(),
                                                              .question: RegisterStepType.question.items()
    ]
    
    var bundle: [String: Any]!
    var style: ConfirmUpdateUserStyle!
    var inputScreen: UpdatePersonalFromScreen?

    init(bundle: [String: Any]?, style: ConfirmUpdateUserStyle, inputScreen: UpdatePersonalFromScreen) {
        super.init()
        self.style = style
        self.bundle = bundle
        self.inputScreen = inputScreen
        self.form = getForm(style: style)
        
        form.userId = getUserId()
        form.email = getEmail()
        onLoadEmail.value = getEmail()
        onLoadUserInfo.value = (style == .update ? form : nil, false)
        
        let currentYear = Date().getYear()
        let currentMonth = Date().getMonth()
        years.value = getYears()
        months.value = getMonths()
        days.value = getDays(year: currentYear, month: currentMonth)
        
        genders.value = getGenders()
        professions.value = getProfessions()
        horseRaceYears.value = getHorseRaceYears()
    }
}

//MARK: Private
extension UpdatePersonalInfoViewModel {
    
    private func getForm(style: ConfirmUpdateUserStyle) -> FormUpdatePersonalInfo {
        if(style == .update) {
            if var form = getInforPerson() {
                form.style = style
                return form
            }
        }
        
        return FormUpdatePersonalInfo(style: style)
    }
    
    private func getYears() -> [IDateModel] {
        
        let fromYear = birthYearFrom
        let toYear = Date().getYear()
        
        let years = Array(fromYear...toYear)
        var mYears: [IDateModel] = []
        
        years.enumerated().forEach({(index, value) in
            if(index == 0) {
                mYears.append(IDateModel(title: "\(value)\(String.placeholder.year)", value: value))
            } else {
                mYears.append(IDateModel(title: "\(value)\(String.placeholder.year)", value: value))
            }
        })

        mYears.insert(IDateModel(title: "\(String.placeholder.year)", value: -1), at: 0)
        
        return mYears
    }
    
    private func getMonths() -> [IDateModel]{
        let months = Array(0...12)
        return months.map({
            let title = $0 == months.first ? "\(String.placeholder.month)" : "\($0)\(String.placeholder.month)"
            return IDateModel(title: title, value: $0)
        })
    }
    
    private func getDays(year: Int, month: Int) -> [IDateModel]{
        let numDay = Date.days(year: year, month: month)
        let days = Array(0...numDay)
        return days.map({
            let title = $0 == days.first ? "\(String.placeholder.day)" : "\($0)\(String.placeholder.day)"
            return IDateModel(title: title, value: $0)
            
        })
    }
    
    private func getGenders() -> [String] {
        var genders = Gender.allCases.map({ $0.rawValue })
        genders.insert(.placeholder.select, at: 0)
        
        return genders
    }
    
    private func getProfessions() -> [String] {
        var professions = Progression.allCases.map({ $0.rawValue })
        professions.insert(.placeholder.select, at: 0)
        
        return professions
    }
    
    private func getHorseRaceYears() -> [IDateModel]{
        let fromYear = horseRaceYearsFrom
        let toYear = Date().getYear()
        
        let years = Array(fromYear...toYear)
        var mYears: [IDateModel] = years.map({ return IDateModel(title: "\($0)", value: $0)})

        mYears.insert(IDateModel(title: .placeholder.select, value: -1), at: 0)
        
        return mYears
    }
    
    private func updateDays() {
    
        guard let years = years.value else { return }
        guard let months = months.value else { return }
        
        var year = Date().getYear()
        var month = Date().getMonth()
        
        if(indexYear != -1 && indexYear != 0) {
            year = (years[indexYear].value)
        }
        
        if(indexMonth != -1 && indexMonth != 0) {
            month = Int(exactly: months[indexMonth].value)!
        }
        
        days.value = getDays(year: year, month: month)
        guard let days = days.value else { return }
        
        if(indexDay > days.count - 1) {
            indexDay = days.count - 1
            let day = days[indexDay]
            onChangeDay(day.title, indexDay)
            form.dayOfBirthday = day.title
        }
    }

    private func getUserId() -> String {
        guard let userId = bundle["userId"] as? String else { return "" }
        return userId
    }
    
    private func getEmail() -> String {
        guard let email = bundle["email"] as? String else { return "" }
        return email
    }
    
    private func getSexValue(_ value: String?) -> String {
        guard let value = value,
              let genderValue = Gender(rawValue: value)?.value() else { return "" }
        
        return genderValue
    }
    
    private func getJobValue(_ value: String?) -> String {
        guard let value = value,
              let jobValue = Progression(rawValue: value)?.value() else { return "" }
        
        return jobValue
    }
    
    private func getRacingStartYear(_ value: String?) -> String {
        guard let value = value else { return "" }
        let year = String(value.prefix(4))
        
        return year
    }
    
    private func getInforPerson() -> FormUpdatePersonalInfo?  {
        guard var form = bundle["data"] as? FormUpdatePersonalInfo else { return nil }
       
        let year = "\(String(form.birthday.prefix(4)))\(String.placeholder.year)"
        let month = "\(String(form.birthday.dropFirst(4).prefix(2)))\(String.placeholder.year)"
        let day = "\(String(form.birthday.suffix(2)))\(String.placeholder.day)"
        
        form.yearOfBirthday = year
        form.monthOfBirthday = month
        form.dayOfBirthday = day
        
        return form
    }
}

extension UpdatePersonalInfoViewModel:  UpdatePersonInfoViewModelProtocol{
    func gotoNextStep(_ controller: UpdatePersonalInfoVC) {
        let validate = form.validate()
        
        if(validate.valid) {
            if (style == .update) {
                Utils.showProgress()
                
                Utils.mainAsyncAfter {
                    call(false)
                }
            } else {
                call()
            }
        } else {
            guard let message = validate.message else { return }
            controller.showToastBottom(message.rawValue)
        }
        
        func call(_ showLoading: Bool = true) {
            guard let code = form.postCode else { return }
            if (code == PostCode.overseas.rawValue){
                onCheckPostCodeSuccessfully()
            } else {
                manager.call(endpoint: .postCode(code), showLoading: showLoading, completion: responsePostCode)
            }
        }
    }
    
    func back(_ controller: UpdatePersonalInfoVC?) {
        if(style == .new) {
            controller?.dismiss(animated: true)
        } else {
            controller?.pop()
        }
    }
    
    func validate() -> UpdatePersonInfoError {
        return .none
    }
    
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        onInputChange(textField, text: newString as String)
        
        if textField.tag == 1 {
            return newString.length <= FormUpdatePersonalInfo.maxLengthPostCode && string.allowedCharacterSet()
        }
        
        return true
    }
    
    func onInputChange(_ textField: UITextField, text: String? = nil) {
        let tag = textField.tag
        let value = text ?? textField.text
        
        switch tag {
        case 0:
//            form.email = value
            break
        case 1:
            form.postCode = value
            break
        case 2:
            form.password = value
            break
        case 3:
            form.confirmPassword = value
            break
        default:
            break
        }
        
        form.emit()
    }
    
    func onChoiceCombobox(_ combobox: DropDown, atIndex index: Int, value: String?) {
        let tag = combobox.tag
        guard let value = value else { return }
        
        if(tag == 0) {
            form.yearOfBirthday = value
        } else if(tag == 1) {
            form.monthOfBirthday = value
        } else if(tag == 2) {
            form.dayOfBirthday = value
        } else if(tag == 3) {
            form.sex = getSexValue(value)
        } else if(tag == 4) {
            form.job = getJobValue(value)
        } else if(tag == 5) {
            form.racingStartYear = value
        }
        
        form.emit()
    }
    
    func getTitle() -> String {
        if(self.style == .update) {
            return String.TitleScreen.changeRegistration
        }
        
        return String.TitleScreen.updatePerson
    }
    
    func executeStep(_ controller: UpdatePersonalInfoVC?) {
        guard let controller = controller else { return }
        if(style == .new) {
            let vc = UpdatePersonalInfoOtherVC(data: dataOfStep, type: .service, form: form)
            controller.push(vc)
        } else {
            self.updateUser(controller)
        }
    }
    
    func executeUpdateSuccess(_ controller: UpdatePersonalInfoVC?) {
        guard let controller else { return }
        if(inputScreen == .other) {
            controller.dismiss(animated: true)
        } else {
            controller.onDismiss?()
        }
    }
    
    func getBlackListYear() -> [Int] {
        return style == .new ? [0] : []
    }
    
    func getBlackListMonth() -> [Int] {
        return style == .new ? [0] : []
    }
    
    func getBlackListDay() -> [Int] {
        return style == .new ? [0] : []
    }

    func formatDropdown(_ label: UILabel, value: String, indexAt index: Int, action selectionAction: @escaping(_ index: Int) -> Void) {
        label.text = value
        label.textColor = index == 0 ? .quickSilver : .black
        if(index != 0 || style == .update) {
            selectionAction(index)
        }
    }
    
    func getIndexOfDefaultYear() -> Int {
        let range = (birthYearDefault - birthYearFrom)
        return  range + 1
    }
    
    func getIndexYear(year: Int) -> Int {
        let range = (year - birthYearFrom)
        return  range + 1
    }
    
    func getIndexHorseRaceYear(year: Int) -> Int {
        let range = (year - horseRaceYearsFrom)
        return  range + 1
    }
}

//MARK: API
extension UpdatePersonalInfoViewModel {
    //TODO: Call
    private func updateUser(_ controller: UpdatePersonalInfoVC?) {
        //Handle API
        manager.call(endpoint: .updateUser(form), showLoading: false, completion: responseUpdate)
    }
    
    //TODO: Response
    private func handleResponse<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void)) {
        guard let response = response else { return }
        if response.getSuccess() {
            successCompletion(response)
        } else {
            Utils.hideProgress()
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
    
    private func responseUpdate(_ response: ResponseUpdateUser?, success: Bool) {
        handleResponse(response) { [weak self] res in
            UserManager.share().updateUser(user: res.data)
            self?.onUpdateSuccessfully()
            Utils.hideProgress()
        }
    }
    
    private func responsePostCode(_ response: ResponsePostCode?, success: Bool) {
        guard let response = response else { return }
        if(response.status == StatusCodeNetwork.code200.rawValue && response.results) {
            onCheckPostCodeSuccessfully()
        } else {
            Utils.hideProgress()
            showMessageError(message: IMTErrorMessage.postCodeInvalid.rawValue)
        }
    }
}
