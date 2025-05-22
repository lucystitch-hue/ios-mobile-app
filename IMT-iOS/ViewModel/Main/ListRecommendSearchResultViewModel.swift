//
//  ListRecommendSearchResultViewModel.swift
//  IMT-iOS
//
//  Created on 03/04/2024.
//
    

import Foundation
import UIKit
import FirebaseMessaging

class ListRecommendSearchResultViewModel: BaseViewModel, ListPreferenceSearchResultProtocol, SubscribePreferenceTopic {
    
    typealias T = OshiUma
    
    var emitReloadData: JVoid = {}
    
    var emitPushListHorseAndJockey: ((ListHorsesAndJockeysSegment) -> Void) = { _ in }
    
    var emitPushWebview: (String) -> Void = { _ in }
    
    var items: [OshiUma] = []
    
    var numberOfRegistItem: Int = 0
    
    var orginalNumberOfItem: Int = 0
    
    var onMoreThanError: ObservableObject<ListFavoriteSearchResultErrorType> = ObservableObject<ListFavoriteSearchResultErrorType>(ListFavoriteSearchResultErrorType.none)
    
    var onMaximumAddError: ObservableObject<ListFavoriteSearchResultErrorType> = ObservableObject<ListFavoriteSearchResultErrorType>(ListFavoriteSearchResultErrorType.none)
    
    var emitShowPopup: ((_ type: ListFavoriteSearchResultPopupType, _ index: Int,_ name: String) -> Void) = { _,_,_  in }
    
    var maximum: Int?
    
    func showPopup(controller: ListFavoriteSearchResultVC?, info: (type: ListFavoriteSearchResultPopupType, index: Int, favoriteObject: String)) {
        
        let index = info.index
        let popupType = info.type
        let object = info.favoriteObject
        let item = self.items[index]
        
        switch popupType {
        case .wouldYouLikeToRegisterAsAFavorite:
            
            self.addPreference {
                controller?.showWarningLimitListRecommendedHorses(self.getMaximum())
            } add: {
                controller?.showWarningWouldYouLikeToRegisterAsAFavoriteHorse(info.favoriteObject, {
                    tag, warningVC in
                    if(tag == 0) {
                        Utils.showProgress()
                        self.addItem(item.getCName(), completion: { success in
                            if success {
                                self.subcribeTopics(item: item)
                                Utils.mainAsyncAfter {
                                    item.torokuzumi = "TRUE"
                                    self.showPopup(controller: controller, info: (type: .iHaveRegisteredAsAFavorite, index: index, favoriteObject: object))
                                    
                                    Utils.hideProgress()
                                    self.emitReloadData()
                                }
                            } else {
                                Utils.hideProgress()
                            }
                        })
                        
                    } else if(tag == 1) {
                        self.emitPushWebview(item.getUrlString())
                    }
                })
            }
            break
        case .iHaveRegisteredAsAFavorite:
            controller?.showWarningIHaveRegisteredAsAFavoriteHorse(object, { [weak self] tag, warningVC in
                if tag == 0 {
                    self?.emitPushListHorseAndJockey(.recommendedHorses)
                }
            })
            break
        case .alreadyRegisteredAsAFavorite:
            controller?.showWarningAlreadyRegisteredAsAFavoriteHorse(object, { [weak self] tag, controller in
                if tag == 0 {
                    self?.emitPushWebview(item.getUrlString())
                }
            })
            break
        }
    }
    
    func setItems(_ items: [PreferenceFeature]) {
        if let items = items as? [OshiUma] {
            self.items = items
            setOrginalNumberOfItem(self.items.count)
        }
    }
    
    func addItem(_ cname: String, completion: @escaping ((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .registOshiUma(cname), showLoading: false, completion: responseOshiUma)
        
        func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
            completion(success)
        }
    }
    
    func getListRegistPreference(_ completion: @escaping([OshiUma]) -> Void) {
        NetworkManager.share().call(endpoint: .getOshiUmaList, showLoading: false, completion: responseOshiUma)
        
        func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
            var count = 0
            var cacheItem = [OshiUma]()
            
            if let items = response?.items {
                count = items.count
                cacheItem = items
            }
            
            setNumberOfRegistItem(count)
            completion(cacheItem)
        }
    }
    
    func setNumberOfRegistItem(_ value: Int) {
        self.numberOfRegistItem = value
    }
    
    func getNumberOfRegistItem() -> Int {
        return self.numberOfRegistItem
    }
    
    func setTop50Item(_ listRegist: [OshiUma]) {
        self.items = Array(items.prefix(Constants.System.limitNumberOfItem))
        
        items.forEach({ item in
            
            let findItem = listRegist.first { iRegist in
                return iRegist.blr == item.blr
            }
            
            //TODO: Reset torokuzumi variable
            item.torokuzumi = "FALSE"
            if let findItem = findItem {
                item.torokuzumi = findItem.torokuzumi
            }
        })
    }
    
    func setOrginalNumberOfItem(_ value: Int) {
        self.orginalNumberOfItem = value
    }
    
    func getOrginalNumberOfItem() -> Int {
        return self.orginalNumberOfItem
    }
    
    private func subcribeTopics(item: PreferenceFeature) {
        Task { @IMTGlobal in
            do {
                let setting = try await getNotificationSetting()
                //TODO: 61
                if let favTokubetsu = setting.favTokubetsu?.boolean(), favTokubetsu {
                    subscribeBy(item.getTopic(SettingsNotificationItem.specialRaceRegistrationInformation.sendkbn()))
                }
                //TODO: 62
                if let favYokuden = setting.favYokuden?.boolean(), favYokuden {
                    subscribeBy(item.getTopic(SettingsNotificationItem.confirmedRaceInformation.sendkbn()))
                }
                //TODO: 63
                if let favHarai = setting.favHarai?.boolean(), favHarai {
                    subscribeBy(item.getTopic(SettingsNotificationItem.raceResultInformation.sendkbn()))
                }
            } catch _ {
                
            }
        }
    }
}

//MARK: TableWidgetProtocol
extension ListRecommendSearchResultViewModel {
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.section
        let item = self.items[index]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ISearchRecommendedCell.identifier, for: indexPath) as? ISearchRecommendedCell else {
            return UITableViewCell()
        }
        
        cell.setup(item)
        return cell
    }
    
    func registerCell(_ tableView: UITableView) {
        tableView.register(identifier: ISearchRecommendedCell.identifier)
    }
}

//MARK: CheckMaximumPreferenceFeatureProtocol
extension ListRecommendSearchResultViewModel {
    func getSysEnvMaximumCode() -> SysEnvCode {
        return .maximumNumberOfHorsesToBeGuessed
    }
    
    func setMaximum(_ value: Int) {
        maximum = value
    }
}
