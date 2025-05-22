//
//  IMTWebViewForFavoriteFeatureViewModel.swift
//  IMT-iOS
//
//  Created on 20/03/2024.
//


import Foundation
import WebKit
import SwiftyJSON
import Firebase

class IMTWebViewForFavoriteFeatureViewModel: BaseViewModel, IMTWebViewForPreferenceFeatureViewModelProtocol, SubscribePreferenceTopic {
    typealias T = OshiKishu
    
    var items: [OshiKishu] = []
    
    var maxinum: Int?
    
    var pushListRaceHorseAndJockey: JVoid?
    
    var queue: [String : String?] = [:]
    
    var cname: String? = nil
    
    var onState: ObservableObject<(isIntial: Bool?, favorite: FavoritePageState)> = ObservableObject<(isIntial: Bool?, favorite: FavoritePageState)>((nil, .none))
    
    func getCName(_ webView: WKWebView?) -> String? {
        return cname
    }
    
    func getName(_ webView: WKWebView?, completionHandler: @escaping ((String) -> Void)) {
        webView?.evaluateJavaScript("document.getElementsByClassName('subTitle')[0].textContent.split('(')[0].trim();", completionHandler: { rs, err in
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
        
        /*---------------------------------------------------------------------------------------------------------------------------------*/
        func caseByCase(_ name: String) {
            if let value = self.getItem(cname) {
                if(value.getFavorite()) {
                    unfavorite(value, name: name)
                } else {
                    addFavorite(value, name: name)
                }
            } else {
                addFavorite(name: name)
            }
        }
        
        func addFavorite(_ value: OshiKishu? = nil, name: String) {
            self.addPreference {
                controller.showWarningLimitOfFavoriteJockeys(self.getMaximum())
            } add: {
                controller.showWarningAddFavoritePerson(person: name, {actionType, warningVC in
                    if(actionType == .ok) {
                        Utils.showProgress()
                        if let cname = self.cname {
                            self.addItem(cname, completion: { [weak self] success in
                                if success {
                                    self?.subcribeTopic(completion: { successTopic in
                                        Utils.mainAsyncAfter { [weak self] in
                                            self?.onState.value = (false, .favorite)
                                            controller.showWarningListOfFavoriteJockeys(person: name) { tag, warningV2VC in
                                                if(tag == 0) {
                                                    self?.pushListRaceHorseAndJockey?()
                                                }
                                            }
                                            Utils.hideProgress()
                                        }
                                    })
                                } else {
                                    Utils.hideProgress()
                                }
                            })
                        }
                    }
                })
            }
        }
        
        func unfavorite(_ value: OshiKishu, name: String) {
            controller.showWarningRemoveFavoritePerson(person: name) { [weak self] action, controler in
                if(action == .ok) {
                    Utils.showProgress()
                    if let cname = self?.cname {
                        self?.deleteItem(cname) { success in
                            if success {
                                self?.subcribeTopic(unsubcribe: true, completion: { successTopic in
                                    Utils.mainAsyncAfter { [weak self] in
                                        self?.onState.value = (false, .unfavorite)
                                        controller.showWarningFavoriteJockeyReleased(jockeyName: name)
                                        Utils.hideProgress()
                                    }
                                })
                            } else {
                                Utils.hideProgress()
                            }
                        }
                    }
                }
            }
        }
        /*---------------------------------------------------------------------------------------------------------------------------------*/
    }
    
    func setCName(_ message: String?) {
        if let value = message {
            self.cname = getIdentifier(value)
        } else {
            self.cname = nil
        }
    }
    
    func updateState(_ webView: WKWebView?, completion: @escaping (() -> Void)) {
        //TODO: Update state on UI
        changeState(webView, completion: completion)
    }
    
    func getSysEnvMaximumCode() -> SysEnvCode {
        return .maximumNumberOfGuessedRiders
    }
    
    func getMaximum() -> Int {
        return maxinum ?? 0
    }
    
    func setMaximum(_ value: Int) {
        self.maxinum = value
    }
    
    func callAPI(_ completion: @escaping((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .getOshiKishuList, showLoading: false, completion: responseOshiKishu)
        
        func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
            if let items = response?.items {
                self.items = items
            }
            completion(success)
        }
    }
    
    func getItems() -> [OshiKishu] {
        return items
    }
    
    func addItem(_ cname: String, completion: @escaping((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .registOshiKishu(cname), showLoading: false, completion: responseOshiKishu)
        
        func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
            if let items = response?.items {
                self.items = items
            }
            completion(success)
        }
    }
    
    func deleteItem(_ cname: String, completion: @escaping((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .deleteOshiKishu(cname), showLoading: false, completion: responseOshiKishu)
        
        func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
            if let items = response?.items {
                self.items = items
            }
            completion(success)
        }
    }
    
    func getButtonTitle() -> String {
        return "Favorite Jockey"
    }
    
    func getIdentifier(_ cname: String) -> String {
        return String(cname.dropLast(3).suffix(4))
    }
    
    func subcribeTopic(unsubcribe: Bool = false, completion: @escaping(Bool) -> Void) {
        if(unsubcribe) {
            unsubscribeBy(getTopic(SettingsNotificationItem.thisWeeksHorseRiding.sendkbn()))
            completion(true)
        } else {
            Task { @MainActor in
                do {
                    let data = try await getNotificationSetting()
                    if let favJoc = data.favJoc, favJoc == "1" {
                        subscribeBy(getTopic(SettingsNotificationItem.thisWeeksHorseRiding.sendkbn()))
                    }
                    completion(true)
                } catch _ {
                    completion(false)
                }
            }
        }
    }
}
