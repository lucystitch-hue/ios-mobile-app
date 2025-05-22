//
//  InfoMenuViewModel.swift
//  IMT-iOS
//
//  Created on 25/01/2024.
//
    

import Foundation
import UIKit

class InfoMenuViewModel: BaseViewModel {
    private (set) var sectionViewModels: [MenuSectionViewModel] = [MenuSectionViewModel]()
    
    let menuSections: ObservableObject<[MenuSectionType]> = ObservableObject<[MenuSectionType]>(MenuSectionType.allCases)
    
    var onTransition: ((MenuItemType) -> Void)?
    
    override init() {
        super.init()
        setupSection()
    }
    
    func getCell(_ tableView: UITableView, cellViewModel: MenuItemCellViewModel, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier) as? MenuItemCell else { return UITableViewCell() }
        
        cell.viewModel = cellViewModel
        return cell
    }
    
    override func handleAction(_ action: IMTAction) {
        guard let menuAction = action as? MenuAction else {
            return
        }
        
        guard let item = menuAction.userInfo[MenuActionKey.destinationPage] as? MenuItemType else {
            return
        }
        
        onTransition?(item)
    }
}

// MARK: PRIVATE

extension InfoMenuViewModel {
    private func setupSection() {
        sectionViewModels = MenuSectionType.allCases.compactMap({ section in
            return MenuSectionViewModel(section: section)
        })
        
        sectionViewModels.forEach({ $0.nextActionResponder = self })
    }
}
