//
//  PreferredDisplayViewModel.swift
//  IMT-iOS
//
//  Created on 24/01/2024.
//
    

import Foundation
import UIKit

class PreferredDisplayViewModel: BaseViewModel {
    let items: ObservableObject<[PreferredDisplayType]> = ObservableObject<[PreferredDisplayType]>(PreferredDisplayType.allCases)
    
    var itemSelected: PreferredDisplayType = PreferredDisplayType(rawValue: Utils.getPreferredDisplaySetting()) ?? .east
    
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IMTRadioButtonCell.identifier) as? IMTRadioButtonCell else { return UITableViewCell() }
        let item = items.value?[indexPath.section]
        let selected = itemSelected == item
        cell.setup(item: item, indexAt:indexPath, selected: selected)
        cell.onChecked = { [weak self] indexPath in
            self?.didSelected(tableView, indexPath: indexPath)
        }
        
        return cell
    }
    
    func getFooter(_ tableView: UITableView, section: Int) -> UIView {
        return UIView()
    }
    
    func getHeightFooter(_ tableView: UITableView, section: Int) -> Float {
        return Float(IMTRadioButtonCell.space)
    }
    
    func confirm(_ controller: PreferredDisplayVC) {
        Constants.displayDefaultPreferredSetting = true
        updatePreferredDisplayOption()
        controller.onDismiss?()
    }
}

// MARK: PRIVATE
extension PreferredDisplayViewModel {
    private func didSelected(_ tableView: UITableView, indexPath: IndexPath) {
        guard let item = items.value?[indexPath.section], itemSelected != item else { return }
        itemSelected = item
        tableView.reloadData()
    }
    
    private func updatePreferredDisplayOption() {
        Utils.setPreferredDisplaySetting(value: itemSelected)
    }
}
