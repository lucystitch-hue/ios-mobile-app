//
//  ListFavoriteSearchResultViewModel.swift
//  IMT-iOS
//
//  Created on 15/03/2024.
//


import Foundation
import UIKit
import SwiftyJSON

class ListFavoriteSearchResultViewModel: BaseViewModel, ListPreferenceSearchResultProtocol {

    typealias T = OshiKishu
    
    var emitReloadData: JVoid = {}
    
    var emitPushListHorseAndJockey: ((ListHorsesAndJockeysSegment) -> Void) = { _ in }
    
    var emitPushWebview: (String) -> Void = { _ in }
    
    var items: [OshiKishu] = [] {
        didSet {
            self.emitReloadData()
        }
    }
    
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
                controller?.showWarningLimitOfFavoriteJockeys(self.getMaximum())
            } add: {
                controller?.showWarningWouldYouLikeToRegisterAsAFavoriteJockey(info.favoriteObject, { [weak self] tag, warningVC in
                    warningVC?.close()
                    if(tag == 0) {
                        Utils.showProgress()
                        Utils.mainAsyncAfter {
                            self?.addItem(item.getCName(), completion: { success in
                                item.torokuzumi = "TRUE"
                                self?.showPopup(controller: controller, info: (type: .iHaveRegisteredAsAFavorite, index: index, favoriteObject: object))
                                Utils.hideProgress()
                                self?.emitReloadData()
                            })
                        }
                    } else if (tag == 1) {
                        self?.emitPushWebview(item.getUrlString())
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
                    self?.emitPushWebview(item.getUrlString())
                }
            })
            break
        }
    }

    func setItems(_ items: [PreferenceFeature]) {
        if let items = items as? [OshiKishu] {
            self.items = items
            setOrginalNumberOfItem(self.items.count)
        }
    }
    
    func addItem(_ cname: String, completion: @escaping((_ success: Bool) -> Void)) {
        self.manager.call(endpoint: .registOshiKishu(cname), showLoading: false, completion: responseOshiKishu)
        
        func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
            completion(success)
        }
    }
    
    func getListRegistPreference(_ completion: @escaping([OshiKishu]) -> Void) {
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
    
    func setNumberOfRegistItem(_ value: Int) {
        self.numberOfRegistItem = value
    }
    
    func getNumberOfRegistItem() -> Int {
        return self.numberOfRegistItem
    }
    
    func setTop50Item(_ listRegist: [OshiKishu]) {
        self.items = Array(items.prefix(Constants.System.limitNumberOfItem))
        
        items.forEach({ item in
            let findItem = listRegist.first { iRegist in
                return iRegist.joccode == item.joccode
            }
            
            //TODO: Reset torokuzumi variable 
            item.torokuzumi = "FALSE"
            if let _ = findItem {
                item.torokuzumi = "TRUE"
            }
        })
    }
    
    func setOrginalNumberOfItem(_ value: Int) {
        self.orginalNumberOfItem = value
    }
    
    func getOrginalNumberOfItem() -> Int {
        return self.orginalNumberOfItem
    }
}

//MARK: TableWidgetProtocol
extension ListFavoriteSearchResultViewModel {
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.section
        let item = self.items[index]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IFavoriteSearchResultCell.identifier, for: indexPath) as? IFavoriteSearchResultCell else {
            return UITableViewCell()
        }
        
        cell.setup(item)
        return cell
    }
    
    func registerCell(_ tableView: UITableView) {
        tableView.register(identifier: IFavoriteSearchResultCell.identifier)
    }
}

//MARK: CheckMaximumPreferenceFeatureProtocol
extension ListFavoriteSearchResultViewModel {
    func getSysEnvMaximumCode() -> SysEnvCode {
        return .maximumNumberOfGuessedRiders
    }
    
    func setMaximum(_ value: Int) {
        maximum = value
    }
}
