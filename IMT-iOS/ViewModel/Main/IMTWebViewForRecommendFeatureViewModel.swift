//
//  IMTWebViewForFavoriteFeatureViewModelProtocol.swift
//  IMT-iOS
//
//  Created on 20/03/2024.
//


import Foundation
import WebKit
import SwiftyJSON
import Firebase

class IMTWebViewForRecommendFeatureViewModel: BaseViewModel, IMTWebViewForPreferenceFeatureViewModelProtocol, SubscribePreferenceTopic {
    typealias T = OshiUma
    
    var items: [OshiUma] = []
    
    var maximum: Int?
    
    var pushListRaceHorseAndJockey: JVoid?
    
    var onState: ObservableObject<(isIntial: Bool?, favorite: FavoritePageState)> = ObservableObject<(isIntial: Bool?, favorite: FavoritePageState)>((nil, .none))
    
    var cname: String? = nil
    
    func getCName(_ webView: WKWebView?) -> String? {
        return self.cname
    }
    
    func getName(_ webView: WKWebView?, completionHandler: @escaping ((String) -> Void)) {
        webView?.evaluateJavaScript("document.getElementsByClassName('bameiSection')[0].innerText.split('\\n')[0];", completionHandler: { rs, err in
            if let name = rs as? String {
                completionHandler(name)
            }
        })
    }
    
    func action(_ controller: IMTWebVC) {
        guard let cname = getCName(controller.webView) else { return }
        self.getName(controller.webView) { name in
            caseByCase(name)
        }
        
        /*--------------------------------------------------------------------------------------------------------------------------------------------------------*/
        func caseByCase(_ name: String) {
            if let value = self.getItem(cname) {
                if(value.getFavorite()) {
                    unrecommended(value, name)
                } else {
                    addRecommened(value, name: name)
                }
            } else {
                addRecommened(name: name)
            }
        }
        
        func addRecommened(_ value: OshiUma? = nil, name: String) {
            self.addPreference {
                controller.showWarningLimitListRecommendedHorses(self.getMaximum())
            } add: {
                controller.showWarningAddRecommendedHorse(horse: name) { action, warningVC in
                    if(action == .ok) {
                        Utils.showProgress()
                        if let cname = self.cname {
                            self.addItem(cname, completion: { success in
                                if success {
                                    self.subcribeTopic { successTopic in
                                        Utils.mainAsyncAfter { [weak self] in
                                            self?.onState.value = (false, .favorite)
                                            controller.showWarningListOfRecommendedHorses(horse: name) { tag, warningV2VC in
                                                if(tag == 0) {
                                                    self?.pushListRaceHorseAndJockey?()
                                                }
                                            }
                                            Utils.hideProgress()
                                        }
                                    }
                                } else {
                                    Utils.hideProgress()
                                }
                            })
                        }
                    }
                }
            }
        }
        
        func unrecommended(_ value: OshiUma, _ name: String) {
            controller.showWarningRemoveRecommendHorse(horse: name) { action, controler in
                if(action == .ok) {
                    Utils.showProgress()
                    if let cname = self.cname {
                        self.deleteItem(cname) { success in
                            if success {
                                self.subcribeTopic(unsubcribe: true) { successTopic in
                                    Utils.mainAsyncAfter { [weak self] in
                                        self?.onState.value = (false, .unfavorite)
                                        controller.showWarningPushHorseReleased(horseName: name)
                                        Utils.hideProgress()
                                    }
                                }
                            } else {
                                Utils.hideProgress()
                            }
                        }
                    }
                }
            }
        }
        /*--------------------------------------------------------------------------------------------------------------------------------------------------------*/
        
    }
    
    func setCName(_ message: String?) {
        if let strURL = message,
           let currentURL = URL(string: strURL) {
            if let cname = currentURL.queryStringParameter(param: "CNAME"), cname.starts(with: "sj01ude") {
                self.cname = getIdentifier(cname)
            } else if let cname = currentURL.queryStringParameter(param: "cname"), cname.starts(with: "sj01ude") {
                self.cname = getIdentifier(cname)
            } else {
                self.cname = nil
            }
        } else {
            self.cname = nil
        }
    }
    
    func updateState(_ webView: WKWebView?, completion: @escaping (() -> Void)) {
        changeState(webView, completion: completion)
    }
    
    func getSysEnvMaximumCode() -> SysEnvCode {
        return .maximumNumberOfHorsesToBeGuessed
    }
    
    func getMaximum() -> Int {
        return maximum ?? 0
    }
    
    func setMaximum(_ value: Int) {
        self.maximum = value
    }
    
    func callAPI(_ completion: @escaping ((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .getOshiUmaList, showLoading: false, completion: responseOshiUma)
        
        func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
            if let items = response?.items {
                self.items = items
            }
            completion(success)
        }
    }
    
    func getItems() -> [OshiUma] {
        self.items
    }
    
    func addItem(_ cname: String, completion: @escaping ((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .registOshiUma(cname), showLoading: false, completion: responseOshiUma)
        
        func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
            if let items = response?.items {
                self.items = items
                
            }
            
            completion(success)
        }
    }
    
    func deleteItem(_ cname: String, completion: @escaping ((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .deleteOshiUma(cname), showLoading: false, completion: responseOshiUma)
        
        func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
            if let items = response?.items {
                self.items = items
            }
            completion(success)
        }
    }
    
    func getButtonTitle() -> String {
        return "Favorite Horse"
    }
    
    func getIdentifier(_ cname: String) -> String {
        return String(cname.dropLast(3).suffix(10))
    }
    
    func subcribeTopic(unsubcribe: Bool = false, completion: @escaping(Bool) -> Void) {
        if(unsubcribe) {
            unsubscribeBy(getTopic(SettingsNotificationItem.specialRaceRegistrationInformation.sendkbn()))
            unsubscribeBy(getTopic(SettingsNotificationItem.confirmedRaceInformation.sendkbn()))
            unsubscribeBy(getTopic(SettingsNotificationItem.raceResultInformation.sendkbn()))
            completion(true)
        } else {
            self.manager.call(endpoint: .setting, showLoading: false, completion: responseNotificationsSetting)
            
            Task { @MainActor in
                do {
                    let data = try await getNotificationSetting()
                    //TODO: 61
                    if let favTokubetsu = data.favTokubetsu, favTokubetsu == "1" {
                        subscribeBy(getTopic(SettingsNotificationItem.specialRaceRegistrationInformation.sendkbn()))
                    }
                    //TODO: 62
                    if let favYokuden = data.favYokuden, favYokuden == "1" {
                        subscribeBy(getTopic(SettingsNotificationItem.confirmedRaceInformation.sendkbn()))
                    }
                    //TODO: 63
                    if let favHarai = data.favTokubetsu, favHarai == "1" {
                        subscribeBy(getTopic(SettingsNotificationItem.raceResultInformation.sendkbn()))
                    }
                    completion(true)
                } catch _ {
                    completion(false)
                }
            }
            
            func responseNotificationsSetting(_ responseSettings: ResponseNotificationsSetting?, success: Bool) {
              
            }
        }
    }
}
