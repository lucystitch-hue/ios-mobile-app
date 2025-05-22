//
//  UMACAViewModel.swift
//  IMT-iOS
//
//  Created by dev on 04/10/2023.
//


import Foundation
import UIKit

protocol UMACAViewModelProtocol {
    var onRegisterSuccessfully: JVoid { get set }
    var onDeleteSuccessfully: JVoid { get set }
    var onInvalidMessage: JString { get set }
    var onShowButtonDelete: ObservableObject<Bool> { get set }
    var form: FormUMACA { get set }
    
    func gotoListVote(_ controller: UMACATicketVC?)
    func gotoResult(_ controller: UMACATicketVC?)
    func gotoRegisterSuccess(_ controller: UMACATicketVC?)
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func onChangeInput(_ textField: UITextField)
    func register(_ controller: UMACATicketVC?)
    func delete(_ controller: UMACATicketVC?)
    func back(_ controller: UMACATicketVC?)
    func forgetPolicy(_ controller: UMACATicketVC?)
    func getPlaceholderCardNumber() -> String
    func getPlaceholderBirthDay() -> String
    func getPlaceholderPinCode() -> String
    func getTitleButton() -> String
    func getEdit() -> Bool
    func navigationTitle() -> String
}

class UMACAViewModel: BaseViewModel {
    
    private struct Constants {
        static let enableUMACATicket = "1"
        static let disableUMACATicket = "0"
    }
    
    var onInvalidMessage: JString = { _ in }
    var onRegisterSuccessfully: JVoid = { }
    var onDeleteSuccessfully: JVoid = { }
    var exist: Bool = false
    var editScreen: Bool = false
    var original: Bool = true //Root screen
    var onShowButtonDelete: ObservableObject<Bool> = ObservableObject<Bool>(true)
    var form: FormUMACA
    
    private var inputScreen: VotingOnlineFromScreen!
    
    init(original: Bool, isEdit editScreen: Bool, inputScreen: VotingOnlineFromScreen) {
        self.original = original
        self.editScreen = editScreen
        self.inputScreen = inputScreen
        self.form = FormUMACA()
        super.init()
        
        getFormEdit()
        showButtonDelete()
    }
}

extension UMACAViewModel: UMACAViewModelProtocol {
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        if textField.tag == 0 {
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= FormUMACA.maxLengthCardNumber && string.allowedCharacterSet()
        } else if textField.tag == 1  {
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= FormUMACA.maxLengthBirthday && string.allowedCharacterSet()
        } else if textField.tag == 2 {
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= FormUMACA.maxLengthPinCode && string.allowedCharacterSet()
        }
        return true
    }
    
    func onChangeInput(_ textField: UITextField) {
        let tag = textField.tag
        let value = textField.text
        
        switch tag {
        case 0:
            form.cardNumber = value
            break
        case 1:
            form.birthday = value
            break
        case 2:
            form.pinCode = value
            break
        default:
            break
        }
        
        form.emit()
    }
    
    func gotoListVote(_ controller: UMACATicketVC?) {
        guard let controller = controller else { return }
        let vc = ListVotingOnlineVC()
        controller.push(vc)
    }
    
    func gotoResult(_ controller: UMACATicketVC?) {
        if(inputScreen == .other) {
            if !UserManager.share().registeredIpat() {
                guard let rootVC = controller?.navigationController?.viewControllers.first else { return }
                rootVC.dismiss(animated: true)
                return
            }
            
            controller?.pop()
        } else {
            controller?.onSuccess?()
        }
    }
    
    func gotoRegisterSuccess(_ controller: UMACATicketVC?) {
        guard let controller = controller else { return }
        if(inputScreen == .other) {
            if(original == true) {
                gotoListVote(controller)
            } else {
                controller.pop()
            }
        } else {
            controller.onSuccess?()
        }
    }
    
    func back(_ controller: UMACATicketVC?) {
        if(original) {
            controller?.dismiss(animated: true)
        } else {
            controller?.pop()
        }
    }
    
    func register(_ controller: UMACATicketVC?) {
        let validate = form.validate()
        
        if(validate.valid) {
            Utils.showProgress(false)
            
            Utils.mainAsyncAfter {
                let umacaFlg = self.form.umacaFlg ?? Constants.enableUMACATicket
                self.manager.call(endpoint: .updateUmacaFlag(umacaFlg), completion: self.responseCreateAndUpdateUMACA)
            }
        } else {
            guard let message = validate.message?.rawValue else { return }
            onInvalidMessage(message)
        }
    }
    
    func delete(_ controller: UMACATicketVC?) {
        form.clearData()
        manager.call(endpoint: .updateUmacaFlag(Constants.disableUMACATicket), completion: responseDeleteUMACA)
    }
    
    func forgetPolicy(_ controller: UMACATicketVC?) {
        controller?.transitionFromSafari(TransactionLink.forgetUmacaPolicy.rawValue)
    }
    
    func getEdit() -> Bool {
        if(!editScreen) {
            return  false
        } else {
            return true
        }
    }
    
    func getPlaceholderCardNumber() -> String {
        return String.myPersonal.placeholderUMACACardNumber
    }
    
    func getTitleButton() -> String {
        if(!editScreen) {
            return String.myPersonal.titleBtnNew
        } else {
            return String.myPersonal.titleBtnEdit
        }
    }
    
    func getPlaceholderBirthDay() -> String {
        return String.myPersonal.placeholderUMACABirthday
    }
    
    func getPlaceholderPinCode() -> String {
        return String.myPersonal.placeholderUMACAPinCode
    }
    
    func showButtonDelete() {
        if(editScreen) {
            onShowButtonDelete.value = false
        }
    }
    
    func getValueForm() {
        if let umaca = UserManager.share().getCurrentUMACA() {
            form.cardNumber = umaca["cardNumber"]
            form.birthday = umaca["birthday"]
            form.pinCode = umaca["pinCode"]
            form.umacaFlg = umaca["umacaFlg"]
        }
    }
    
    func navigationTitle() -> String {
        return editScreen ? .TitleScreen.umacaTicketUpdate : .TitleScreen.umacaSmartCollaboration
    }
}

//MARK: Private
extension UMACAViewModel {
    private func getFormEdit() {
        if(editScreen) {
            getValueForm()
        }
    }
    
    private func response<R: BaseResponse>(_ response: R?, successCompletion:@escaping(R) -> Void, failureCompletion:@escaping() -> Void = {}) {
        Utils.hideProgress()
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
    
    private func responseCreateAndUpdateUMACA(_ response: ResponseUpdateUMACAFlag?, success: Bool) {
        self.response(response) { [weak self] res in
            if let data = res.data, let userId = data.userId, let umacaFlg = data.umacaFlg {
                self?.form.umacaFlg = umacaFlg
                var umacaTickets = Utils.getDictUserDefault(key: .umacaTickets) ?? [String: Any]()
                umacaTickets[userId] = self?.form.toParam()
                Utils.setDictUserDefault(value: umacaTickets, forKey: .umacaTickets)
            }
            self?.onRegisterSuccessfully()
        }
    }
    
    private func responseDeleteUMACA(_ response: ResponseUpdateUMACAFlag?, success: Bool) {
        self.response(response) { [weak self] res in
            if let userId = res.data?.userId, var umacaTickets = Utils.getDictUserDefault(key: .umacaTickets) {
                umacaTickets.removeValue(forKey: userId)
                Utils.setDictUserDefault(value: umacaTickets, forKey: .umacaTickets)
            }
            self?.onDeleteSuccessfully()
        }
    }
}
