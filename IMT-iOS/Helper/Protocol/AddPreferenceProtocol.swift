//
//  AddPreferenceProtocol.swift
//  IMT-iOS
//
//  Created on 10/04/2024.
//
    

import Foundation

protocol AddPreferenceProtocol: CheckMaximumPreferenceFeatureProtocol {
    associatedtype T: PreferenceFeature
    var maximum: Int? { get set }
    var numberOfRegistItem: Int { get set }
    var emitPushListHorseAndJockey:((ListHorsesAndJockeysSegment) -> Void) { get set }
    var emitPushWebview: (String) -> Void { get set }

    func addPreference(limit: @escaping(JVoid), add: @escaping(JVoid), showLoading: Bool)
    func getListRegistPreference(_ completion: @escaping([T]) -> Void)
    func getNumberOfRegistItem() -> Int
    func setNumberOfRegistItem(_ value: Int)
    func getMaximum() -> Int
    func setMaximum(_ value: Int)
    func validate() -> ListFavoriteSearchResultErrorType
    
    func addItem(_ cname: String, completion: @escaping((_ success: Bool) -> Void))
}

extension AddPreferenceProtocol {
    func addPreference(limit: @escaping(JVoid), add: @escaping(JVoid), showLoading: Bool = true) {
        if showLoading {
            Utils.showProgress()
        }
        self.getMaximumFromSystem { maximum in
            self.getListRegistPreference { items in
                if showLoading {
                    Utils.hideProgress()
                }
                
                let errorType = validate()
                if(errorType == .maximumLimitOfRaceHorse(maximum)) {
                    limit()
                } else {
                    add()
                }
            }
        }
    }
    
    func validate() -> ListFavoriteSearchResultErrorType {
        let numberOfFavoriteItem = getNumberOfRegistItem()
        if numberOfFavoriteItem >= self.getMaximum() {
            return .maximumLimitOfRaceHorse(self.getMaximum())
        }
        
        return .none
    }
    
    func getMaximum() -> Int {
        return maximum ?? 0
    }
}
