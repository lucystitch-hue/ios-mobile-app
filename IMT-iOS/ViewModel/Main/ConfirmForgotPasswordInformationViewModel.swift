//
//  ConfirmForgotPasswordInformationViewModel.swift
//  IMT-iOS
//
//  Created by dev on 28/05/2023.
//

import Foundation
import UIKit
import SwiftyJSON

protocol ConfirmForgotPasswordInformationViewModelProtocol {
    var indexYear: Int { get set }
    var indexMonth: Int { get set }
    var indexDay: Int { get set }
    var years: ObservableObject<[IDateModel]> { get set }
    var months: ObservableObject<[IDateModel]> { get set }
    var days: ObservableObject<[IDateModel]> { get set }
    var onChangeDay: ((_ strDay: String, _ index: Int) -> Void) { get set }
    var form: FormConfirmForgotPasswordInformation { get set }
    var onForgotPasswordSuccessfull: (([ConfirmOTPBundleKey: Any]?) -> Void) { get set }
    var showWarningLimitUpdate: JVoid { get set }
    
    func gotoEnterConfirmationCode(_ controller: ConfirmForgotPasswordInformationVC?, bundle: [ConfirmOTPBundleKey: Any]?)
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func onChoiceCombobox(_ combobox: DropDown, atIndex index: Int, value: String?)
    func sendOtpForgotPassword(_ controller: ConfirmForgotPasswordInformationVC?)
    func getIndexOfDefaultYear() -> Int
    func onChangeInput(_ textField: UITextField)
}

class ConfirmForgotPasswordInformationViewModel: BaseViewModel {
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
    var years: ObservableObject<[IDateModel]> = ObservableObject<[IDateModel]>([])
    var months: ObservableObject<[IDateModel]> = ObservableObject<[IDateModel]>([])
    var days: ObservableObject<[IDateModel]> = ObservableObject<[IDateModel]>([])
    var onChangeDay: ((String, Int) -> Void) = { _,_ in }
    var onForgotPasswordSuccessfull: (([ConfirmOTPBundleKey: Any]?) -> Void) = { _ in }
    var showWarningLimitUpdate: JVoid = { }
    var form: FormConfirmForgotPasswordInformation = FormConfirmForgotPasswordInformation()
    var sendOTPData: SendOTPDataModel?
    let birthYearFrom = 1900
    let birthYearDefault = 1990
    
    override init() {
        super.init()
        let currentYear = Date().getYear()
        let currentMonth = Date().getMonth()
        self.years.value = getYears()
        self.months.value = getMonths()
        self.days.value = getDays(year: currentYear, month: currentMonth)
    }
}

extension ConfirmForgotPasswordInformationViewModel {
    
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
            form.emit()
        }
    }
    
    func getIndexOfDefaultYear() -> Int {
        let range = (birthYearDefault - birthYearFrom)
        return  range + 1
    }
}

extension ConfirmForgotPasswordInformationViewModel: ConfirmForgotPasswordInformationViewModelProtocol {
    
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString = currentString.replacingCharacters(in: range, with: string)
        form.email = newString
        return true
    }
    
    func onChangeInput(_ textField: UITextField) {
        form.email = textField.text
    }
    
    func gotoEnterConfirmationCode(_ controller: ConfirmForgotPasswordInformationVC?, bundle: [ConfirmOTPBundleKey: Any]?) {
        guard let controller = controller else { return }
        let vc = ConfirmOTPVC(style: .resetPassword, bundle: bundle)
        controller.push(vc)
    }
    
    func sendOtpForgotPassword(_ controller: ConfirmForgotPasswordInformationVC?) {
        let validate = form.validate()
        
        if(validate.valid) {
            manager.call(endpoint: .sendOTP(email: form.email ?? "", happyDay: form.birthday), completion: responseSendOTP)
        } else {
            guard let message = validate.message else { return }
            controller?.showToastBottom(message.rawValue)
        }
    }
    
    func onChoiceCombobox(_ combobox: DropDown, atIndex index: Int, value: String?) {
        let tag = combobox.tag
        
        if(tag == 0) {
            form.yearOfBirthday = value
        } else if(tag == 1) {
            form.monthOfBirthday = value
        } else if(tag == 2) {
            form.dayOfBirthday = value
        }
        
        form.emit()
    }
    
}

//MARK: Private
extension ConfirmForgotPasswordInformationViewModel {
    private func responseSendOTP(_ response: ResponseSendOTP?, success: Bool) {
        handleResponse(response) { [weak self] in
            var bundle: [ConfirmOTPBundleKey: Any]?
            
            if let email = self?.form.email,
               let data = response?.data {
                bundle = [.email: email,
                          .sendOTPData: data]
            }
            
            self?.onForgotPasswordSuccessfull(bundle)
        }
    }
    
    //TODO: Response
    private func handleResponse<R: BaseResponse>(_ response: R?, successHandler: @escaping(JVoid) = {}) {
        guard let response = response else { return }
        if(response.success) {
            successHandler()
        } else {
            guard let message = response.message else { return }
            if let _ = WarningType.compile(message) {
                showWarningLimitUpdate()
            } else {
                showMessageError(message: message)
            }
        }
    }
}
