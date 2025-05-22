//
//  RaceHorseSearchViewModel.swift
//  IMT-iOS
//
//  Created on 18/03/2024.
//
    

import Foundation
import UIKit

class RaceHorseSearchViewModel: BaseViewModel {
    
    private (set) var sectionViewModels: [FilterSectionViewModel] = [FilterSectionViewModel]()
    
    let menuSections: ObservableObject<[FilterSectionType]> = ObservableObject(FilterSectionType.allCases)
    let error: IMTBox<String?> = IMTBox(nil)
    let isLoading: IMTBox<Bool> = IMTBox(false)
    let datasource: IMTBox<[String]> = IMTBox(["Starts with", "Ends with", "Contains"])

    
    private var form: FormRaceHorseSearch = FormRaceHorseSearch()
    
    override init() {
        super.init()
        setupSection()
    }
    
    func onChangeInput(_ textField: UITextField) {
        form.bna = textField.text
    }
    
    func onChangeDropdown(_ index: Int) {
        form.opt = "\(index)"
    }
    
    func getCell(_ tableView: UITableView, cellViewModel: BaseCellViewModel, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellViewModel.cellIdentifier)
        
        switch cellViewModel {
        case let filterCellViewModel as FilterCellViewModel:
            if let filterCell = cell as? FilterCell {
                filterCell.viewModel = filterCellViewModel
            }
        default:
            break
        }
        return cell ?? UITableViewCell()
    }
    
    func handleSearch(_ controller: RaceHorseSearchVC) {
        let validate = form.validate()
        
        if (validate.valid) {
            guard let bna = form.bna else { return }
            isLoading.value = true
            error.value = nil
            Task { @MainActor in
                do {
                    let oshiUma = try await searchOshiUma(bna: bna, opt: form.opt, ewtkbc: form.ewtkbc, sex: form.sex, del: form.del)
                    isLoading.value = false
                    error.value = oshiUma.isEmpty ? IMTErrorMessage.thereWasNoCorrespondingData.rawValue : nil
                    if !oshiUma.isEmpty {
                        controller.onGotoResultSearch?(bna, oshiUma)
                    }
                } catch _ {
                    isLoading.value = false
                    error.value = IMTErrorMessage.thereWasNoCorrespondingData.rawValue
                }
            }
        } else {
            guard let message = validate.message else { return }
            error.value = message.rawValue
        }
    }
    
    override func handleAction(_ action: IMTAction) {
        guard let filterAction = action as? FilterAction else {
            return
        }
        
        guard let item = filterAction.userInfo[FilterActionKey.destinationPage] as? String else {
            return
        }
        
        let substring = item.split(separator: "|")
        if let key = substring.first, let section = FilterSectionType(rawValue: String(key)), let value = substring.last  {
            switch section {
            case .affiliation:
                form.ewtkbc = String(value)
            case .sex:
                form.sex = String(value)
            case .activeOrCancelled:
                form.del = String(value)
            }
        }
        
    }
    
    private func setupSection() {
        sectionViewModels = FilterSectionType.allCases.compactMap({ section in
            return FilterSectionViewModel(section: section)
        })
        
        sectionViewModels.forEach({ $0.nextActionResponder = self })
    }
    
    private func searchOshiUma(bna: String, opt: String, ewtkbc: String, sex: String, del: String) async throws -> [OshiUma] {
        try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .searchOshiUma(bna: bna, opt: opt, ewtkbc: ewtkbc, sex: sex, del: del), showLoading: false, completion: responseOshiUma)
            
            func responseOshiUma(_ resposne: ResponseOshiUma?, success: Bool) {
                if let resposne = resposne {
                    continuation.resume(returning: resposne.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
}
