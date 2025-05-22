//
//  ClubIMTNetCooperationViewModel.swift
//  IMT-iOS
//
//  Created by dev on 05/04/2023.
//


import Foundation
import UIKit

enum ClubIMTNetCooperationValidate: String {
    case none = ""
    case missingNumber = "こちらの項目は必須項目です" // requierd
    case emptyNumber = "入力された情報が正しくありません" // incorrect
}

protocol ClubIMTNetCooperationViewModelProtocol {
    var maxLengthSubcriber: Int { get }
    var maxLengthFour: Int { get }
    var maxLengthIMTClub: Int { get }
    var onValidate: ObservableObject<ClubIMTNetCooperationValidate> { get set }
    var isValidating: Bool { get set }

    func validate(subscriberValue: String, clbValue: String )
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func coloredAttributedString(withText text: String, coloredText: String) -> NSAttributedString
}

class ClubIMTNetCooperationViewModel {
    var maxLengthSubcriber: Int = 8
    var maxLengthIMTClub: Int = 8
    var maxLengthFour: Int = 4
    var isValidating: Bool = false
    var onValidate: ObservableObject<ClubIMTNetCooperationValidate> = ObservableObject<ClubIMTNetCooperationValidate>(ClubIMTNetCooperationValidate.none)
}

extension ClubIMTNetCooperationViewModel: ClubIMTNetCooperationViewModelProtocol {

    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        if(!string.isEmpty) {
            let value = "\(textField.text ?? "")\(string)"
            if textField.tag == 0 {
                return value.matches("^(^[a-z0-9]{0,\(maxLengthSubcriber)})$")
            } else if textField.tag == 1 {
                return value.matches("^(^[a-z0-9]{0,\(maxLengthIMTClub)})$")
            }
            textField.text = value
        }
        return true
    }
    
    func validate(subscriberValue: String, clbValue: String ) {
        isValidating = true
        
        if subscriberValue.count == 0 && clbValue.count == 0   {
            self.onValidate.value = ClubIMTNetCooperationValidate.missingNumber
        } else if subscriberValue.count == maxLengthSubcriber &&  clbValue.count <= maxLengthIMTClub && clbValue.count >= maxLengthFour {
            self.onValidate.value = ClubIMTNetCooperationValidate.none
        } else {
            self.onValidate.value = ClubIMTNetCooperationValidate.emptyNumber
        }
        
        isValidating = false
    }
    
    func coloredAttributedString(withText text: String, coloredText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: coloredText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.quickSilver, range: range)
        attributedString.addAttribute(.font, value: UIFont.appFontW7Size(10), range: range)
        return attributedString
    }

}
