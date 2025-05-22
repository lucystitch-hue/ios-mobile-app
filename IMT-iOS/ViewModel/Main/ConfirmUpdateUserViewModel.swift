//
//  ConfirmUpdateUserViewModel.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import Foundation
import UIKit

protocol ComfirmUpdateUserViewModelProtocol: BaseLoginViewModel {
    
    var onLoginSuccess: ObservableObject<LoginEmailValidate> { get set }
    var onLoadUserInfo: ObservableObject<(form: FormUpdatePersonalInfo?,isIntital: Bool)> { get set }

    func back(_ controller: ConfirmUpdateUserVC)
    func confirm(_ controller: ConfirmUpdateUserVC?)
    func gotoBiometricAuthentication( _ controller: ConfirmUpdateUserVC?)
}

class ConfirmUpdateUserViewModel: BaseViewModel {
    var onLoginSuccess:ObservableObject<LoginEmailValidate> = ObservableObject<LoginEmailValidate>(LoginEmailValidate.none)
    var onLoadUserInfo: ObservableObject<(form: FormUpdatePersonalInfo?, isIntital: Bool)> = ObservableObject<(form: FormUpdatePersonalInfo?, isIntital: Bool)>((nil, true))
    var onLoginSuccessfully: ObservableObject<Bool> = ObservableObject<Bool>(false)
    
    private var style: ConfirmUpdateUserStyle!
    private var form: FormUpdatePersonalInfo?
    private var firstLoad: Bool = true
    
    init(style: ConfirmUpdateUserStyle, form: FormUpdatePersonalInfo?) {
        super.init()
        self.style = style
        self.form = form
        onLoadUserInfo.value = (form, false)
    }
    
    override func removeObserver() {
        super.removeObserver()
        Utils.removeObserver(self, name: .reloadMe)
    }
    
    override func refreshData() {
        
        Utils.onObserver(self, selector: #selector(reloadData), name: .reloadMe)

        if(style == .update ) {
            getMe() //True: back to "UpdatePersonalInfoVC" screen and "MenuVC enters the screen"
        } else {
            super.refreshData()
        }
    }
}

extension ConfirmUpdateUserViewModel: ComfirmUpdateUserViewModelProtocol  {
    func back(_ controller: ConfirmUpdateUserVC) {
        if(controller.isModal) {
            controller.dismiss(animated: true)
        } else {
            controller.pop()
        }
    }
    
    func confirm(_ controller: ConfirmUpdateUserVC?){
        if(style == .update){
            self.gotoUpdatePersonInfo(controller)
        } else if (style == .new) {
            self.signup(controller)
        }
    }
    
    func gotoBiometricAuthentication(_ controller: ConfirmUpdateUserVC?) {
        guard let controller = controller else { return }
        let vc = BiometricAuthenticationVC()
        controller.push(vc)
    }
}

//MARK: API
extension ConfirmUpdateUserViewModel {
    //TODO: Call
    private func signup(_ controller: ConfirmUpdateUserVC?) {
        guard let form = self.form else { return }
        Utils.showProgress()
        manager.call(endpoint: .signup(form: form), showLoading: false, completion: responseSignup)
    }
    
    private func login() {
        guard let email = form?.email else { return }
        guard let password = form?.password else { return }
        
        let form = FormLoginEmail(email: email, password: password)
        self.loginWithUserName(form, showLoading: false, needDelay: true)
    }
    
    //TODO: Response
    private func handleResponse<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void)) {
        guard let response = response else { return }
        if response.getSuccess() {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            if (message == .registerScreen.passwordError) {
                successCompletion(response)
            } else {
                Utils.hideProgress()
                showMessageError(message: message)
            }
        }
    }
    
    private func responseSignup(_ response: ResponseSignup?, success: Bool) {
        handleResponse(response) { [weak self] res in
            Constants.firstLogin = true
            self?.login()
        }
    }
}

//MARK: Private
extension ConfirmUpdateUserViewModel {
    func gotoUpdatePersonInfo(_ controller: ConfirmUpdateUserVC?) {
        self.firstLoad = false
        guard let controller = controller else { return }
        guard let bundle = form?.getBundleUpdateUser(form: form) else { return }
        controller.onGotoUpdatePersonInfo?(bundle)
    }
    
    func getMe() {
        Utils.showProgress()
        Utils.postObserver(.callAPIMe, object: true)
    }
    
    @objc func reloadData(_ notification: Notification) {
        Utils.hideProgress()
        guard let meDataModel = notification.object as? MeDataModel else { return }
        self.form = meDataModel.toForm()
        
        self.onLoadUserInfo.value = (form, false)
    }
}
