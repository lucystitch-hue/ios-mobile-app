//
//  IMTWebPreferenceFeatureViewModelProtocol.swift
//  IMT-iOS
//
//  Created on 05/04/2024.
//
    

import Foundation
import WebKit
import SwiftyJSON

protocol IMTWebViewForPreferenceFeatureViewModelProtocol: CheckMaximumPreferenceFeatureProtocol {
    associatedtype T: PreferenceFeature
    var items: [T] { get set }
    var onState: ObservableObject<(isIntial: Bool?, favorite: FavoritePageState)> { get set }
    var pushListRaceHorseAndJockey: JVoid? { get set }
    
    //MARK: Logic
    func getCName(_ webView: WKWebView?) -> String?
    func updateState(_ webView: WKWebView?, completion: @escaping (() -> Void))
    func setCName(_ message: String?)
    func getIdentifier(_ cname: String) -> String
    func getButtonTitle() -> String
    func getTopic(_ sendkbn: String) -> String
    
    //MARK: API
    func callAPI(_ completion: @escaping((_ success: Bool) -> Void))
    func getItems() -> [T]
    func addItem(_ cname: String, completion: @escaping((_ success: Bool) -> Void))
    func deleteItem(_ cname: String, completion: @escaping((_ success: Bool) -> Void))
    func subcribeTopic(unsubcribe: Bool, completion: @escaping(Bool) -> Void)
    
    //MARK: Action
    func action(_ controller: IMTWebVC)
    func addPreference(limit limitAction: @escaping(JVoid), add addAction: @escaping(JVoid))
}

extension IMTWebViewForPreferenceFeatureViewModelProtocol {
    func getItem(_ cname: String) -> T? {
        let items = getItems()
        return items.first(where: { $0.getCName() == cname })
    }
    
    func validate() -> Bool {
        let items = getItems()
        if items.filter({ $0.getFavorite() }).count >= getMaximum() {
            return false
        }
        
        return true
    }
    
    func changeState(_ webView: WKWebView?,  completion: @escaping (() -> Void)) {
        var state: FavoritePageState = .none
        if let cname = getCName(webView) {
            self.callAPI { success in
                if success {
                    if let object = getItem(cname) {
                        let favorite = object.getFavorite()
                        state = favorite ? .favorite : .unfavorite
                    } else {
                        state = .unfavorite
                    }
                }
                
                onState.value = (false, state)
                completion()
            }
        } else {
            onState.value = (false, state)
            completion()
        }
    }
    
    func addPreference(limit limitAction: @escaping(JVoid), add addAction: @escaping(JVoid)) {
        Utils.showProgress()
        self.getMaximumFromSystem { maximum in
            self.callAPI { success in
                if success {
                    let validate = validate()
                    if(!validate) {
                        limitAction()
                    } else {
                        addAction()
                    }
                }
                Utils.hideProgress()
            }
        }
    }
    
    func getTopic(_ sendkbn: String) -> String {
        return Utils.getTopic(sendkbn, cname: getCName(nil))
    }
}
