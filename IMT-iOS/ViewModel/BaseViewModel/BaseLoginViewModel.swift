//
//  BaseLoginViewModel.swift
//  IMT-iOS
//
//  Created by dev on 01/06/2023.
//

import Foundation
import UIKit
import SwiftyJSON
import Firebase

protocol BaseLoginViewModel: BaseViewModel {
    var onLoginSuccessfully: ObservableObject<Bool> { get set }
    
    func loginWithUserName(_ form: FormLoginEmail, showLoading: Bool, needDelay: Bool, needValidate: Bool)
    func gotoHome(_ controller: UIViewController?)
}

extension BaseLoginViewModel {
    
    func loginWithUserName(_ form: FormLoginEmail, showLoading: Bool = false, needDelay: Bool = false, needValidate: Bool = true) {
        
        if(needValidate) {
            let validate = form.validate()
            
            if(validate.valid == true) {
                startLogin()
            } else {
                guard let message = validate.message?.rawValue else { return }
                showMessageError(message: message)
            }
        } else {
            startLogin()
        }
        
        func startLogin() {
            Utils.showProgress()
            manager.call(endpoint: .login(form), showLoading: showLoading, showError: false) { response, sucess in
                self.responseLogin(response, form: form, needDelay: needDelay)
            }
        }
    }
    
    func gotoHome(_ controller: UIViewController?) {
        Utils.gotoHome()
    }
}

//MARK: Private
extension BaseLoginViewModel {
    private func updateFCMToken() {
        let nFCMToken = Constants.System.fcmToken
        let exist = Utils.existUserDefault(key: .registFCMToken)
        
        if !exist {
            manager.call(endpoint: .registFCMToken, showLoading: false, completion: responseRegistFCM) //No wait response
        } else {
            let isChangeToken = Utils.getUserDefault(key: .registFCMToken) != nFCMToken
            if(isChangeToken) {
                if let oFCMToken = Utils.getKeyChain(key: .registFCMToken) {
                    self.manager.call(endpoint: .dropFCMToken(oFCMToken), showLoading: false, completion: responseDropFCM)
                }
                
                manager.call(endpoint: .registFCMToken, showLoading: false, completion: responseRegistFCM) //No wait response
            }
        }
    }
    
    private func responseRegistFCM(_ response: JSON?, success: Bool) {
        if let success = response?["success"].boolValue {
            if(!success) {
                if let message = response?["message"].stringValue {
                    print("ERROR API REGISTER FCM: \(message)")
                }
            } else {
                let nFCMToken = Constants.System.fcmToken
                Utils.setUserDefault(value: nFCMToken, forKey: .registFCMToken)
            }
            return
        }
        
        print("ERROR API REGISTER FCM")
    }
    
    private func responseDropFCM(_ response: JSON?, success: Bool) {
        if let success = response?["success"].boolValue {
            if(!success) {
                if let message = response?["message"].stringValue {
                    print("ERROR API DROP FCM: \(message)")
                }
            }
            return
        }
        
        print("ERROR API DROP FCM")
    }
    
    private func responseLogin(_ response: ResponseLogin?, form: FormLoginEmail, needDelay: Bool) {
        guard let response = response else { return }
        if(response.getSuccess()) {
            cacheUserLogin(form, info: response)
            clearLocalDataIfNeed(response.data?.email)
            Constants.isLoginScreen = false
            postLoginSuccess()
        } else {
            Utils.hideProgress()
            postLoginFailed()
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
        
        func postLoginSuccess() {
            if (needDelay) {
                Utils.mainAsyncAfter {
                    self.onLoginSuccessfully.value = true
                }
            } else {
                self.onLoginSuccessfully.value = true
            }
        }
        
        func postLoginFailed() {
            self.onLoginSuccessfully.value = false
        }
    }
    
    private func cacheUserLogin(_ form: FormLoginEmail, info response: ResponseLogin?) {
        guard let _ = form.email?.decrypt() else { return }
        guard let password = form.password?.decrypt() else { return }
        guard let response = response else { return }
        guard let data = response.data else { return }
        let userId = data.userId
        let expiredAt = response.expiredAt ?? ""
        let userKbn = response.data?.userKbn ?? ""
        
        var userIds = Utils.getDictUserDefault(key: .userIdsDidLogin) ?? [String: String]()
        Constants.showGuide = userIds[userId] == nil
        userIds[userId] = data.email
        
        Constants.lastLoginEmail = Utils.getUserDefault(key: .email)
        UserManager.share().updateAccessDate()
        UserManager.share().reLogin = true
        UserManager.share().user = data
        Utils.setUserDefault(value: userId, forKey: .userId)
        Utils.setUserDefault(value: data.email, forKey: .email)
        Utils.setUserDefault(value: password, forKey: .password)
        
        Utils.setUserDefault(value: expiredAt, forKey: .expiredAt)
        Utils.setUserDefault(value: userKbn, forKey: .userKng)
        Utils.setUserDefault(value: Date().timeIntervalSince1970.description, forKey: .loginDate)
        Utils.setDictUserDefault(value: userIds, forKey: .userIdsDidLogin)
    }
    
    private func clearLocalDataIfNeed(_ email: String?) {
        guard let email = email else { return }
        
        //Clear biometric
        let asAccount = UserManager.share().asAccount(email: email)
        if(!asAccount) {
            UserManager.share().clearBiomatricAuthentication()
            UserManager.share().disableBiometricAuthenticationFromSetting()
            UserManager.share().resetShowGuideQRCode()
        }
    }
}
