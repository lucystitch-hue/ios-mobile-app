//
//  JockeySearchResultViewModel.swift
//  IMT-iOS
//
//  Created on 09/04/2024.
//
    

import Foundation
import UIKit
import FirebaseMessaging

class ListJockeySearchResultViewModel: BaseViewModel, SubscribePreferenceTopic {
    typealias T = OshiKishu
    
    private (set) var sectionViewModels: [AlphabeticalSectionViewModel] = [AlphabeticalSectionViewModel]()
    
    var isLoading: IMTBox<Bool> = IMTBox(false)
    var jockeys: [OshiKishu] = []
    var type: Abbreviations {
        didSet {
            fetch(update: true)
        }
    }
    var maximum: Int?
    var numberOfRegistItem: Int = 0
    var emitPushListHorseAndJockey: ((ListHorsesAndJockeysSegment) -> Void) = { _ in }
    var emitPushWebview: (String) -> Void = { _ in }
    var emitShowPopup: ((_ type: ListFavoriteSearchResultPopupType, _ item: OshiKishu) -> Void) = { _,_  in }
    
    var warningMaximumText: String? {
        guard let maximum = maximum, numberOfRegistItem >= maximum else { return nil }
        return ListFavoriteSearchResultErrorType.maximumLimitOfJockey(maximum).message()
    }
    
    init(type: Abbreviations) {
        self.type = type
        super.init()
        self.fetch()
    }
    
    func didChoice(_ tableView: UITableView, indexPath: IndexPath) {
        let sectionViewModel = sectionViewModels[indexPath.section]
        let item = sectionViewModel.jockeys[indexPath.row]
        if(!item.getFavorite()) {
            self.emitShowPopup(.wouldYouLikeToRegisterAsAFavorite, item)
        } else {
            self.emitShowPopup(.alreadyRegisteredAsAFavorite, item)
        }
    }

    func showPopup(controller: ListJockeyResultSearchVC?, info: (type: ListFavoriteSearchResultPopupType, item: OshiKishu)) {
        
        let popupType = info.type
        let object = info.item.getName()
        let item = info.item
        
        switch popupType {
        case .wouldYouLikeToRegisterAsAFavorite:
            
            self.addPreference {
                controller?.showWarningLimitOfFavoriteJockeys(self.getMaximum())
                self.isLoading.value = false
            } add: {
                controller?.showWarningWouldYouLikeToRegisterAsAFavoriteJockey(object, { [weak self] tag, warningVC in
                    warningVC?.close()
                    if(tag == 0) {
                        self?.isLoading.value = true
                        self?.addItem(item.getCName(), completion: { success in
                            if success {
                                self?.subcribeTopics(item: item)
                                Utils.mainAsyncAfter {
                                    item.torokuzumi = "TRUE"
                                    self?.showPopup(controller: controller, info: (type: .iHaveRegisteredAsAFavorite, item))
                                    self?.isLoading.value = false
                                }
                            } else {
                                self?.isLoading.value = false
                            }
                        })
                    } else if (tag == 1) {
                        self?.emitPushWebview(TransactionLink.jockeyDetail(item.param).rawValue)
                    }
                })
            }
            break
        case .iHaveRegisteredAsAFavorite:
            controller?.showWarningIHaveRegisteredAsAFavoriteJockey(object, { [weak self] tag, warningVC in
                if tag == 0 {
                    self?.emitPushListHorseAndJockey(.favoriteJockeys)
                }
            })
            break
        case .alreadyRegisteredAsAFavorite:
            controller?.showWarningIAmRegisteredAsAFavoriteJockey(object, { [weak self] tag, controller in
                if(tag == 0) {
                    self?.emitPushWebview(TransactionLink.jockeyDetail(item.param).rawValue)
                }
            })
            break
        }
    }
    
    func fetch(update: Bool = false) {
        guard !isLoading.value else { return }
        
        isLoading.value = true
        Task { @MainActor in
            do {
                if !update {
                    await checkMaximum()
                }
                jockeys = try await searchOshiKishu(param: type.value())
                fetchSection()
                isLoading.value = false
            } catch _ {
                isLoading.value = false
            }
        }
    }
    
    private func fetchSection() {
        sectionViewModels = []
        var cacheInitial = jockeys.first?.initial
        var cacheJockeys: [OshiKishu] = []
        for (index, jockey) in jockeys.enumerated() {
            if(cacheInitial != jockey.initial) {
                let section = AlphabeticalSectionViewModel(initialName: cacheInitial ?? "", jockeys: cacheJockeys)
                sectionViewModels.append(section)
                cacheInitial = jockey.initial
                cacheJockeys = []
                cacheJockeys.append(jockey)
                if (index == jockeys.count - 1) {
                    let section = AlphabeticalSectionViewModel(initialName: cacheInitial ?? "", jockeys: cacheJockeys)
                    sectionViewModels.append(section)
                    cacheInitial = jockey.initial
                    cacheJockeys = []
                }
            } else {
                cacheJockeys.append(jockey)
                if (index == jockeys.count - 1) {
                    let section = AlphabeticalSectionViewModel(initialName: cacheInitial ?? "", jockeys: cacheJockeys)
                    sectionViewModels.append(section)
                    cacheInitial = jockey.initial
                    cacheJockeys = []
                }
            }
        }
        sectionViewModels.forEach { $0.nextActionResponder = self }
    }
    
    private func searchOshiKishu(param: String) async throws -> [OshiKishu] {
        try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .searchOshiKishu(param: param), showLoading: false, completion: responseOshiKishu)
            
            func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    private func checkMaximum() async {
        await withCheckedContinuation { contination in
            addPreference(limit: {
                contination.resume()
            }, add: {
                contination.resume()
            }, showLoading: false)

        }
    }
    
    private func subcribeTopics(item: PreferenceFeature) {
        Task { @IMTGlobal in
            do {
                let setting = try await getNotificationSetting()
                if let favJoc = setting.favJoc?.boolean(), favJoc {
                    subscribeBy(item.getTopic(SettingsNotificationItem.thisWeeksHorseRiding.sendkbn()))
                }
            } catch _ {
                
            }
        }
    }
}

extension ListJockeySearchResultViewModel: AddPreferenceProtocol {
    func getListRegistPreference(_ completion: @escaping ([OshiKishu]) -> Void) {
        NetworkManager.share().call(endpoint: .getOshiKishuList, showLoading: false, completion: responseOshiKishu)
        
        func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
            var count = 0
            var cacheItems = [OshiKishu]()
            
            if let items = response?.items {
                count = items.count
                cacheItems = items
            }
            
            setNumberOfRegistItem(count)
            completion(cacheItems)
        }
    }
    
    func getNumberOfRegistItem() -> Int {
        return numberOfRegistItem
    }
    
    func getSysEnvMaximumCode() -> SysEnvCode {
        return .maximumNumberOfGuessedRiders
    }
    
    func setMaximum(_ value: Int) {
        self.maximum = value
    }
    
    func setNumberOfRegistItem(_ value: Int) {
        numberOfRegistItem = value
    }
    
    func addItem(_ cname: String, completion: @escaping((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .registOshiKishu(cname), showLoading: false, completion: responseOshiKishu)
        
        func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
            completion(success)
        }
    }
}
