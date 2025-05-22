//
//  ListPreferenceSearchResultlProtocol.swift
//  IMT-iOS
//
//  Created on 03/04/2024.
//
    

import Foundation
import UIKit

protocol ListPreferenceSearchResultProtocol: AddPreferenceProtocol, TableWidgetProtocol, CheckMaximumPreferenceFeatureProtocol {
    
    var items: [T] { get set }
    var orginalNumberOfItem: Int { get set }
    var onMoreThanError: ObservableObject<ListFavoriteSearchResultErrorType> { get set }
    var onMaximumAddError: ObservableObject<ListFavoriteSearchResultErrorType> { get set }
    var emitShowPopup:((_ type: ListFavoriteSearchResultPopupType, _ index: Int, _ name: String) -> Void) { get set }
    var emitReloadData: JVoid { get set }
    
    func fetch()
    func showPopup(controller: ListFavoriteSearchResultVC?, info: (type: ListFavoriteSearchResultPopupType, index: Int, favoriteObject: String))
    func setItems(_ items: [PreferenceFeature])
    func setTop50Item(_ listRegist: [T])
    func setOrginalNumberOfItem(_ value: Int)
    func getOrginalNumberOfItem() -> Int
}

extension ListPreferenceSearchResultProtocol {
    func validateWhenInitial() {
        onMaximumAddError.value = ListFavoriteSearchResultErrorType.none
        onMoreThanError.value = ListFavoriteSearchResultErrorType.none
        
        if self.getOrginalNumberOfItem() > Constants.System.limitNumberOfItem {
            onMoreThanError.value = .moreThan50OfItem
        }
        
        let numberOfFavoriteItem = getNumberOfRegistItem()
        if numberOfFavoriteItem >= self.getMaximum() {
            onMaximumAddError.value = .maximumLimitOfRaceHorse(self.getMaximum())
        }
    }
    
    func validate() -> ListFavoriteSearchResultErrorType {
        let numberOfFavoriteItem = getNumberOfRegistItem()
        if numberOfFavoriteItem >= self.getMaximum() {
            self.onMaximumAddError.value = .maximumLimitOfRaceHorse(self.getMaximum())
            return .maximumLimitOfRaceHorse(self.getMaximum())
        }
        
        return .none
    }
    
    func fetch() {
        Utils.showProgress()
        self.getMaximumFromSystem { maximum in
            self.getListRegistPreference({ listRegist in
                //TODO: Get first 50 items. After map with items of regist. To update value tuzumaki field
                setTop50Item(listRegist)
                
                //TODO: Handle validate show error on top
                Utils.hideProgress()
                validateWhenInitial()
                
                emitReloadData()
            })
        }
    }
}

//MARK: TableWidgetProtocol
extension ListPreferenceSearchResultProtocol {
    func numSection(_ tableView: UITableView) -> Int {
        let count = items.count
        return count >= Constants.System.limitNumberOfItem ? Constants.System.limitNumberOfItem : count
    }
    
    func numCell(_ tableView: UITableView, section: Int) -> Int {
        return 1
    }
    
    func getFootter(_ tableView: UITableView, section: Int) -> UIView? {
        let vFootter = FooterLine(paddingLeft: 0.0)
        return vFootter
    }
    
    func getHeightFootter(_ tableView: UITableView, section: Int) -> CGFloat {
        return Constants.HeightConfigure.smallFooterLine
    }
    
    func didChoice(_ tableView: UITableView, indexPath: IndexPath) {
        let index = indexPath.section
        let item = self.items[index]
        if(!item.getFavorite()) {
            self.emitShowPopup(.wouldYouLikeToRegisterAsAFavorite, index, item.getName())
        } else {
            self.emitShowPopup(.alreadyRegisteredAsAFavorite, index, item.getName())
        }
    }
}
