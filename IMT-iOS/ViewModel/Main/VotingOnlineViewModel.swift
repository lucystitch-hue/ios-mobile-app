//
//  VotingOnlineViewModel.swift
//  IMT-iOS
//
//  Created by dev on 28/03/2023.
//

import Foundation
import UIKit

protocol VotingOnlineViewModelProtocol {
    var onRegisterSuccessfully: JVoid { get set }
    var onDeleteSuccessfully: JVoid { get set }
    var onInvalidMessage: JString { get set }
    var onShowButtonDelete: ObservableObject<Bool> { get set }
    var form: FormVotingOnline { get set }
    
    func gotoListVote(_ controller: VotingOnlineVC?)
    func gotoResult(_ controller: VotingOnlineVC?)
    func gotoRegisterSuccess(_ controller: VotingOnlineVC?)
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool
    func onChangeInput(_ textField: UITextField)
    func register(_ controller: VotingOnlineVC?)
    func delete(_ controller: VotingOnlineVC?)
    func getStyle() -> VotingOnlineStyle;
    func back(_ controller: VotingOnlineVC?)
    func getPlaceholderIPatId() -> String
    func getPlaceholderIPatPars() -> String
    func getPlaceholderIPatPass() -> String
    func getTitleButton() -> String
    func getEdit() -> Bool
    func getTitle() -> String
}

class VotingOnlineViewModel: BaseViewModel {
    
    var onInvalidMessage: JString = { _ in }
    var onRegisterSuccessfully: JVoid = { }
    var onDeleteSuccessfully: JVoid = { }
    var exist: Bool = false
    var editScreen: Bool = false
    var original: Bool = true //Root screen
    var onShowButtonDelete: ObservableObject<Bool> = ObservableObject<Bool>(true)
    
    var form: FormVotingOnline
    private var type: VotingOnlineType
    private var inputScreen: VotingOnlineFromScreen
    
    init(type: VotingOnlineType, original: Bool, isEdit editSreen: Bool, inputScreen: VotingOnlineFromScreen) {
        self.type = type
        self.original = original
        self.editScreen = editSreen
        self.inputScreen = inputScreen
        self.form = FormVotingOnline(type: type)
        super.init()
        
        getFormEdit()
        showButtonDelete()
    }
}

extension VotingOnlineViewModel: VotingOnlineViewModelProtocol {
    func allowInput(_ textField: UITextField, range: NSRange, string: String) -> Bool {
        if textField.tag == 0 {
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= FormVotingOnline.maxLengthIPatId && string.allowedCharacterSet()
        } else if textField.tag == 1  {
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= FormVotingOnline.maxLengthIPatPass && string.allowedCharacterSet()
        } else if textField.tag == 2 {
            let currentString: NSString = textField.text as NSString? ?? ""
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= FormVotingOnline.maxLengthIPars && string.allowedCharacterSet()
        }
        return true
    }
    
    func onChangeInput(_ textField: UITextField) {
        let tag = textField.tag
        let value = textField.text
        
        switch tag {
        case 0:
            form.iPatId = value
            break
        case 1:
            form.iPatPass = value
            break
        case 2:
            form.iPatPars = value
            break
        default:
            break
        }
        
        form.emit()
    }
    
    func gotoListVote(_ controller: VotingOnlineVC?) {
        guard let controller = controller else { return }
        let vc = ListVotingOnlineVC()
        controller.push(vc)
    }
    
    func gotoResult(_ controller: VotingOnlineVC?) {
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
    
    func gotoRegisterSuccess(_ controller: VotingOnlineVC?) {
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
    
    func back(_ controller: VotingOnlineVC?) {
        if(original) {
            controller?.dismiss(animated: true)
        } else {
            controller?.pop()
        }
    }
    
    func register(_ controller: VotingOnlineVC?) {
        let validate = form.validate()
        
        if(validate.valid) {
            Utils.showProgress(false)
            
            if (!editScreen) {
                call(15)
            } else {
                call()
            }
        } else {
            guard let message = validate.message?.rawValue else { return }
            onInvalidMessage(message)
        }
        
        func call(_ delay: CGFloat = Constants.System.delayAPI) {
            Utils.mainAsyncAfter(delay) { [weak self] in
                guard let sself = self else { return }
                sself.manager.call(endpoint: .createAndUpdateUserIPat(sself.form), showLoading: false, completion: sself.responseCreateAndUpdateUserIPat)
            }
        }
    }
    
    func delete(_ controller: VotingOnlineVC?) {
        form.clearData()
        manager.call(endpoint: .createAndUpdateUserIPat(form), completion: responseDeleteIpat)
    }
    
    func getEdit() -> Bool {
        if(!editScreen) {
            return  false
        } else {
            return true
        }
    }
    
    func getStyle() -> VotingOnlineStyle {
        switch type {
        case .ipatOne:
            guard let _ = UserManager.share().user?.iPatId1?.decrypt() else {
                return .update
            }
            break
        case .ipatTwo:
            guard let _ = UserManager.share().user?.iPatId1?.decrypt() else {
                return .update
            }
            break
        }
        
        return .new
    }
    
    func getPlaceholderIPatId() -> String {
        return String.myPersonal.placeholderIPatIdRegister
    }
    
    func getTitleButton() -> String {
        if(!editScreen) {
            return String.myPersonal.titleBtnNew
        } else {
            return String.myPersonal.titleBtnEdit
        }
    }
    
    func getPlaceholderIPatPass() -> String {
        return String.myPersonal.placeholderIPatPassRegister
    }
    
    func getPlaceholderIPatPars() -> String {
        return String.myPersonal.placeholderIPatParRegister
    }
    
    func showButtonDelete() {
        if(editScreen) {
            onShowButtonDelete.value = false
        }
    }
    
    func getValueForm() {
        form.iPatId = getIpatId()
        form.iPatPars = getIPatPars()
        form.iPatPass = getIPatPass()
    }
    
    func getFormEdit() {
        if(editScreen) {
            getValueForm()
        }
    }
    
    func getTitle() -> String {
        if(editScreen) {
            return String.TitleScreen.voteEdit
        }
        
        return String.TitleScreen.voteRegister
    }
}

//MARK: Private
extension VotingOnlineViewModel {
    private func getIpatId() -> String {
        let user = UserManager.share().user
        if let ipatId1 = user?.iPatId1?.decrypt(), type == .ipatOne {
            return ipatId1
        } else if let ipatId2 = user?.iPatId2?.decrypt(), type == .ipatTwo {
            return ipatId2
        } else {
            return ""
        }
    }
    
    private func getIPatPass() -> String {
        let user = UserManager.share().user
        if let ipatPass1 = user?.iPatPass1?.decrypt(), type == .ipatOne {
            return ipatPass1
        } else if let ipatPass2 = user?.iPatPass2?.decrypt(), type == .ipatTwo {
            return ipatPass2
        } else {
            return ""
        }
    }
    
    private func getIPatPars() -> String {
        let user = UserManager.share().user
        if let ipatPars1 = user?.iPatPars1?.decrypt(), type == .ipatOne {
            return ipatPars1
        } else if let ipatPars2 = user?.iPatPars2?.decrypt(), type == .ipatTwo {
            return ipatPars2
        } else {
            return ""
        }
    }
}

//MARK: API
extension VotingOnlineViewModel {
    //TODO: Response
    private func response<R: BaseResponse>(_ response: R?, successCompletion:@escaping(R) -> Void, failureCompletion:@escaping() -> Void = {}) {
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
    
    private func responseIpat(_ response: ResponseVotingOnline?, successCompletion:@escaping() -> Void) {
        Utils.hideProgress()
        self.response(response) { res in
            if let data = res.data {
                UserManager.share().updateIPat(data)
            }
            
            successCompletion()
        }
    }
    
    private func responseCreateAndUpdateUserIPat(_ response: ResponseVotingOnline?, success: Bool) {
        responseIpat(response) { [weak self] in
            self?.onRegisterSuccessfully()
        }
    }
    
    private func responseDeleteIpat(_ response: ResponseVotingOnline?, success: Bool) {
        responseIpat(response) { [weak self] in
            self?.onDeleteSuccessfully()
        }
    }
}

