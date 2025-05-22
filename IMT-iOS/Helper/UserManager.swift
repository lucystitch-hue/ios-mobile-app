//
//  UserManager.swift
//  IMT-iOS
//
//  Created by dev on 12/04/2023.
//

import Foundation

class UserManager {
    static private var instance: UserManager!
    public var user: UserDataModel?
    public var reLogin: Bool! = false
    
    static public func share() -> UserManager {
        if(self.instance == nil) {
            instance = UserManager()
        }
        
        return instance
    }
    
    public func expired() -> Bool {
        let loginDate = Utils.getUserDefault(key: .loginDate) ?? ""
        let expiredAt = Utils.getUserDefault(key: .expiredAt) ?? ""
        
        guard let _ = Utils.getUserDefault(key: .userId) else { return true }
        guard let vLoginDate = Double(loginDate) else { return true }
        guard let vExpiredAt = Double(expiredAt) else { return true }
        let expireTime = vLoginDate + vExpiredAt
        let currentTime = Date().timeIntervalSince1970
        
        if(currentTime < expireTime) {
            return false
        }
        
        return true
    }
    
    public func removeUser() {
        removeCacheUser()
    }
    
    public func updateIPat(_ data: IPatDataModel) {
        //MARK: iPat1
        user?.iPatId1 = data.iPatId1
        user?.iPatPass1 = data.iPatPass1
        user?.iPatPars1 = data.iPatPars1
        user?.ysnFlg1 = data.ysnFlg1
        
        //MARK: iPat2
        user?.iPatId2 = data.iPatId2
        user?.iPatPass2 = data.iPatPass2
        user?.iPatPars2 = data.iPatPars2
        user?.ysnFlg2 = data.ysnFlg2
    }
    
    public func registeredIpat() -> Bool {
        if let ipatId1 = user?.iPatId1, !ipatId1.isEmpty {
            return true
        } else if let ipatId2 = user?.iPatId2, !ipatId2.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    public func getCurrentIpatSkipLogin() -> IPatModel? {
        if let ipatId1 = user?.iPatId1?.decrypt(),
           let ipatPass1 = user?.iPatPass1?.decrypt(),
           let ipatPar1 = user?.iPatPars1?.decrypt(),
           let ysnFlg1 = user?.ysnFlg1, ysnFlg1 == "1" {
            return IPatModel(siteUserId: ipatId1, parsNo: ipatPar1, pinCode: ipatPass1)
        } else if let ipatId2 = user?.iPatId2?.decrypt(),
                  let ipatPass2 = user?.iPatPass2?.decrypt(),
                  let ipatPar2 = user?.iPatPars2?.decrypt(),
                  let ysnFlg2 = user?.ysnFlg2, ysnFlg2 == "1" {
            return IPatModel(siteUserId: ipatId2, parsNo: ipatPar2, pinCode: ipatPass2)
        } else {
            return nil
        }
    }
    
    public func getCurrentUMACA() -> [String: String]? {
        guard let userId = Utils.getUserDefault(key: .userId), let umacaTickets = Utils.getDictUserDefault(key: .umacaTickets), let umaca = umacaTickets[userId] as? [String: String] else { return nil }
        return umaca
    }
    
    public func getCurrentUMACASkipLogin() -> UMACAModel? {
        if let umaca = getCurrentUMACA(), let cardNumber = umaca["cardNumber"],
           let birthday = umaca["birthday"],
           let pinCode = umaca["pinCode"],
           let umacaFlg = umaca["umacaFlg"], umacaFlg == "1" {
            return UMACAModel(cardNumber: cardNumber, birthday: birthday, pinCode: pinCode)
        } else {
            return nil
        }
    }
    
    public func showUmaca() -> Bool {
        if let _ = getCurrentUMACASkipLogin() {
            return false
        } else {
            return true
        }
    }
    
    public func checkExistIpat() -> Bool {
        if let ipatId1 = user?.iPatId1?.decrypt(), !ipatId1.isEmpty {
            return true
        } else if let ipatId2 = user?.iPatId2?.decrypt(), !ipatId2.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    public func checkExistIpat1() -> Bool {
        if let ipatId1 = user?.iPatId1?.decrypt(), !ipatId1.isEmpty {
            return true
        }
        return false
    }
    
    public func checkExistIpat2() -> Bool {
        if let ipatId2 = user?.iPatId2?.decrypt(), !ipatId2.isEmpty {
            return true
        }
        return false
    }
    
    public func showTerm() -> Bool {
        guard let showTerm = Utils.getUserDefault(key: .showTerm), showTerm == "false" else { return true }
        return false
    }
    
    public func showGuide() -> Bool {
        return Constants.showGuide
    }
    
    public func hideGuide() {
        Constants.showGuide = false
    }
    
    public func showLinkageIpat() -> Bool {
        if let _ = getCurrentIpatSkipLogin() {
            return false
        } else if let flag = Utils.getUserDefault(key: .didLinkageIpat), flag == "true" {
            return false
        } else {
            return true
        }
    }
    
    public func legalAge() -> Bool {
        guard let age = user?.birthday.decrypt().toDate(.dashDate)?.getAge(format: .dashDate) else { return false }
        return age >= Constants.System.legalAgeToJoin
    }
    
    public func resetShowTerm() {
        Utils.setUserDefault(value: "true", forKey: .showTerm)
    }
    
    public func didUseBiomatricAuthentication() -> Bool {
        guard let value = Utils.getUserDefault(key: .didUseBiomatricAuthentication), value == "true" else { return false }
        return true
    }
    
    public func clearBiomatricAuthentication() {
        Utils.deleteUserDefault(key: .didUseBiomatricAuthentication)
    }
    
    public func useBiometricAuthenticationInSetting() -> Bool {
        guard let enable = Utils.getUserDefault(key: .useBiometricAuthenticationInSetting), enable == "true" else { return false }
        return true
    }
    
    public func enableBiometricAuthenticationFromSetting() {
        Utils.setUserDefault(value: "true", forKey: .useBiometricAuthenticationInSetting)
    }
    
    public func disableBiometricAuthenticationFromSetting() {
        Utils.deleteUserDefault(key: .useBiometricAuthenticationInSetting)
    }
    
    public func didUseEnhanceSecuritySetting() -> Bool {
        let key = getKeyEnhanceSecurity()
        guard let enable = UserDefaults.standard.value(forKey: key) as? String, enable == "true" else { return false }
        return true
    }
    
    public func enableEnhanceSecuritySetting(_ value: String = "true") {
        let key = getKeyEnhanceSecurity()
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public func disableEnhanceSecuritySetting() {
        enableEnhanceSecuritySetting("false")
    }
    
    public func asAccount(email: String) -> Bool {
        let lastEmail = Constants.lastLoginEmail
        return email == lastEmail
    }
    
    public func getRoleUser() -> UserRole {
        if let user = self.user {
            return user.getUserRole()
        } else {
            let userKng = Utils.getUserDefault(key: .userKng)
            guard let userKng = userKng, !userKng.isEmpty else { return .manual }
            return UserRole(rawValue: userKng) ?? .manual
        }
    }
    
    public func checkLoginWhenChangeEmail(_ completion:@escaping((_ change: Bool?,_ data: LoginDataModel?) -> Void)) {
        let networkManager = NetworkManager.share()
        
        if let email = Utils.getUserDefault(key: .email),
           let _ = Utils.getUserDefault(key: .userId) {
            networkManager.call(endpoint: .checkLogin(email), showLoading: false, completion: responseCheckLogin)
        } else {
            completion(nil, nil)
        }
        
        func responseCheckLogin(_ response: ResponseCheckLogin?, success: Bool) {
            if let response = response {
                let change = !response.success
                let data = response.data
                completion(change, data)
            } else {
                completion(nil, nil)
            }
        }
    }
    
    public func updateUser(user: UpdateUserDataModel?) {
        guard let user = user else {
            return
        }
        
        self.user?.userId = user.userId
        self.user?.birthday = user.birthday
        self.user?.sex = user.sex
        self.user?.job = user.job
        self.user?.postCode = user.postCode
        if let racingStartYear = user.racingStartYear {
            self.user?.racingStartYear = racingStartYear
        }
        self.user?.serviceType = user.serviceType
        self.user?.regisReason = user.regisReason
        self.user?.dayOff = user.dayOff
    }
    
    public func updateEmail(_ email: String) {
        Utils.setUserDefault(value: email.decrypt(), forKey: .email)
        Constants.lastLoginEmail = email
    }
    
    public func showGuideQRCode() -> Bool {
        guard let show =  Utils.getUserDefault(key: .showGuideQR) else { return true }
        return show != "true"
    }
    
    public func hideGuideQRCode() {
        Utils.setUserDefault(value: "true", forKey: .showGuideQR)
    }
    
    public func resetShowGuideQRCode() {
        Utils.deleteUserDefault(key: .showGuideQR)
    }
    
    public func checkExistUMACA() -> Bool {
        let userId = Utils.getUserDefault(key: .userId) ?? ""
        if let umacaTickets = Utils.getDictUserDefault(key: .umacaTickets), let _ = umacaTickets[userId] {
            return true
        } else {
            return false
        }
    }
    
    public func getToken() -> (isUserLogin: Bool, token: String?) {
        if let value = Utils.getUserDefault(key: .uToken),
           let userId = Utils.getUserDefault(key: .userId) {
            let values = value.components(separatedBy: "/")
            let vUserId = values[0]
            let vUtoken = values[1]
            
            if vUserId == userId {
                return (true, vUtoken)
            } else {
                return (false, vUtoken)
            }
        }
        
        return (false, nil)
    }
    
    public func saveUtoken() {
        let utoken = Constants.System.fcmToken
        if let userId = Utils.getUserDefault(key: .userId) {
            let value = "\(userId)/\(utoken)"
            return Utils.setUserDefault(value: value, forKey: .uToken)
        }
    }
    
    public func deleteUtoken() {
        Utils.deleteUserDefault(key: .uToken)
    }
    
    public func updateLastLoginDateIfNeed() {
        execute()
        
        /*-------------------------------------------------------------------------------------------------*/
        func execute() {
            let isLogin = !UserManager.share().expired()
            if(isLogin) {
                guard let userId = Utils.getUserDefault(key: .userId) else { return }
                
                if(exist()) {
                    if(need()) {
                        update(userId)
                    }
                } else {
                    update(userId)
                }
            }
        }
        
        func exist() -> Bool {
            guard let _ = Utils.getUserDefault(key: .cacheAccessDate) else { return false }
            return true
        }
        
        func need() -> Bool {
            if let cacheAccessDate = Utils.getUserDefault(key: .cacheAccessDate) {
                if let accessDate = cacheAccessDate.toDate(.dashDate) {
                    let currentDate = Date.japanDate.beginningOfDay()
                    if (currentDate.compare(accessDate) == .orderedDescending) {
                        return true
                    }
                }
            }
            return false
        }
        
        func update(_ userId: String) {
            NetworkManager.share().call(endpoint: .latestLogin(userId: userId), completion: responseLatestLogin)
            
            func responseLatestLogin(_ response: ResponseLatestLogin?, success: Bool) {
                guard let response = response else { return }
                if response.success {
                    self.updateAccessDate()
                } else {
                    Utils.postObserver(.showErrorSystem, object: response.message ?? "")
                }
            }
        }
        /*-------------------------------------------------------------------------------------------------*/
        
    }
    
    public func multipleLogin() -> Bool {
        return Constants.lastLoginEmail != nil
    }
    
    public func updateAccessDate() {
        Utils.setUserDefault(value: Date.japanDate.beginningOfDay().toString(format: .dashDate), forKey: .cacheAccessDate)

    }
    
    public func clearAccessDate() {
        Utils.deleteUserDefault(key: .cacheAccessDate)
    }
}

//MARK: Private
extension UserManager {
    private func removeCacheUser() {
//        Utils.deleteUserDefault(key: .userId)
        Utils.deleteUserDefault(key: .expiredAt)
        Utils.deleteUserDefault(key: .access_token)
        Utils.deleteUserDefault(key: .refresh_token)
        Utils.deleteUserDefault(key: .loginDate)
        Utils.deleteUserDefault(key: .didLinkageIpat)
        Utils.deleteUserDefault(key: .userKng)
        
        Utils.setUserDefault(value: UserManager.share().user?.email.decrypt() ?? "", forKey: .cacheOldEmail)
    }
    
    private func getKeyEnhanceSecurity() -> String {
        guard let email = Utils.getUserDefault(key: .email) else { return "" }
        return "\(KeyUserDefaults.enhanceSecuritySetting.rawValue)_\(email)"
    }
}
