//
//  ListHorsesAndJockeysViewModel.swift
//  IMT-iOS
//
//  Created on 14/03/2024.
//
    

import Foundation
import UIKit
import FirebaseMessaging

enum ListHorsesAndJockeysSegment: Int, CaseIterable {
    case recommendedHorses
    case favoriteJockeys
    
    func text() -> String {
        switch self {
        case .recommendedHorses:
            return "Favorite Horses"
        case .favoriteJockeys:
            return "Favorite Jockeys"
        }

        func title() -> String {
            switch self {
            case .recommendedHorses:
                return "Favorite Horses List"
            case .favoriteJockeys:
                return "Favorite Jockeys List"
            }
        }

        func cancelTitle() -> String {
            switch self {
            case .recommendedHorses:
                return "Remove Selected Favorite Horses"
            case .favoriteJockeys:
                return "Remove Selected Favorite Jockeys"
            }
        }

}

class ListHorsesAndJockeysViewModel: BaseViewModel, SubscribePreferenceTopic {
    
    var isLoading: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var reloadData: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var shouldShowWarningPopup: IMTBox<String?> = IMTBox(nil)
    var selectedItemsObservable: IMTBox<Int> = IMTBox(0)
    var objects: [PreferenceFeature] = []
    var objectsSelected: [PreferenceFeature] = [] {
        didSet {
            selectedItemsObservable.value = objectsSelected.count
        }
    }
    private var viewModelsForDisplaying = [BaseCellViewModel]()
    public var onShowRemoveAllPreferenceComplete: ((Int, ListHorsesAndJockeysSegment) -> Void) = { _,_ in }
    var emitPushWebview: (String) -> Void = { _ in }
    
    var shouldHideRanking: Bool {
        return selectedSegment == .favoriteJockeys
    }
    
    var itemsCount: Int {
        return objects.count
    }
    
    var selectedCount: Int {
        return objectsSelected.count
    }
    
    var shouldActiveRanking: Bool = false
    var maximum: Int = -1
    var shouldShowCheckBox: Bool = false
    
    var selectedSegment: ListHorsesAndJockeysSegment = .recommendedHorses {
        didSet {
            fetch()
        }
    }
    
    var availableSegment = ListHorsesAndJockeysSegment.allCases
    
    init(selectedSegment: ListHorsesAndJockeysSegment = .recommendedHorses) {
        super.init()
        self.selectedSegment = selectedSegment
        fetch()
    }
    
    func fetch() {
        guard !(isLoading.value ?? false) else {
            return
        }
        isLoading.value = true
        
        Task { @MainActor in
            do {
                let responseSysEnv = try await self.getSystemValue()
                switch selectedSegment {
                case .recommendedHorses:
                    self.maximum = Int(responseSysEnv.getValueFromAysy01(key: .maximumNumberOfHorsesToBeGuessed) ?? "0") ?? 0
                    self.shouldActiveRanking = responseSysEnv.getValueFromAysy01(key: .guessHorseRanking) == "1" ? true : false
                    self.objects = try await self.getRaceHorses()
                    break
                case .favoriteJockeys:
                    self.maximum = Int(responseSysEnv.getValueFromAysy01(key: .maximumNumberOfGuessedRiders) ?? "0") ?? 0
                    self.objects = try await self.getJockeys()
                    break
                }
                self.reloadViewModels()
                self.isLoading.value = false
            } catch _ {
                self.objects = []
                self.reloadViewModels()
                self.isLoading.value = false
            }
        }

    }

    private func reloadViewModels() {
        viewModelsForDisplaying.removeAll()
        
        for object in objects {
            switch object {
            case let jockey as OshiKishu:
                let model = JockeyCellViewModel(jockey: jockey)
                viewModelsForDisplaying.append(model)
                break
            case let racehorse as OshiUma:
                let model = RaceHorseCellViewModel(racehorse: racehorse)
                viewModelsForDisplaying.append(model)
                break
            default:
                return
            }
        }
        reloadData.value = true
    }
    
    func selectedAll() {
        objectsSelected.removeAll()
        objectsSelected.append(contentsOf: objects)
        reloadData.value = true
    }
    
    func removeAll() {
        objectsSelected.removeAll()
        reloadData.value = true
    }
    
    func cancel(_ index: Int) {
        guard let object = objects.safeObjectForIndex(index: index) else { return }
        isLoading.value = true
        Task { @MainActor in
            do {
                switch selectedSegment {
                case .favoriteJockeys:
                    objects = try await deleteOshiKishu(object.getCName())
                    unsubscribeBy(object.getTopic(SettingsNotificationItem.thisWeeksHorseRiding.sendkbn()))
                    break
                case .recommendedHorses:
                    objects = try await deleteOshiUma(object.getCName())
                    unsubscribeBy(object.getTopic(SettingsNotificationItem.specialRaceRegistrationInformation.sendkbn()))
                    unsubscribeBy(object.getTopic(SettingsNotificationItem.confirmedRaceInformation.sendkbn()))
                    unsubscribeBy(object.getTopic(SettingsNotificationItem.raceResultInformation.sendkbn()))
                    break
                }
                try await Task.sleep(seconds: Constants.System.delayAPI)
                reloadViewModels()
                isLoading.value = false
                shouldShowWarningPopup.value = object.getName()
            } catch _ {
                isLoading.value = false
            }
        }
    }
    
    func cancelMultiple() {
        isLoading.value = true
        Task { @MainActor in
            do {
                let cname = objectsSelected.map({$0.getCName()}).joined(separator: "_")
                switch selectedSegment {
                case .favoriteJockeys:
                    objects = try await multiDeleteOshiKishu(cname)
                    unsubscribeFavJockeys()
                case .recommendedHorses:
                    objects = try await multiDeleteOshiUma(cname)
                    unsubscribeRecommededHorses()
                }
                try await Task.sleep(seconds: Constants.System.delayAPILV2)
                self.onShowRemoveAllPreferenceComplete(selectedCount, selectedSegment)
                
                reloadViewModels()
                isLoading.value = false
            } catch _ {
                isLoading.value = false
            }
            
            func unsubscribeFavJockeys() {
                for objectsSelect in objectsSelected {
                    unsubscribeBy(objectsSelect.getTopic(SettingsNotificationItem.thisWeeksHorseRiding.sendkbn()))
                }
            }
            
            func unsubscribeRecommededHorses() {
                for objectsSelect in objectsSelected {
                    unsubscribeBy(objectsSelect.getTopic(SettingsNotificationItem.specialRaceRegistrationInformation.sendkbn()))
                    unsubscribeBy(objectsSelect.getTopic(SettingsNotificationItem.confirmedRaceInformation.sendkbn()))
                    unsubscribeBy(objectsSelect.getTopic(SettingsNotificationItem.raceResultInformation.sendkbn()))
                }
            }
        }
    }
    
    func tableViewCell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModelsForDisplaying[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier, for: indexPath)
        
        switch viewModel {
        case let jockeyCellViewModel as JockeyCellViewModel:
            if let jockeyCell = cell as? HorseAndJockeyCell {
                jockeyCellViewModel.selected = objectsSelected.contains(where: {$0.getCName() == jockeyCellViewModel.jockey.getCName()})
                jockeyCell.viewModel = jockeyCellViewModel
                jockeyCell.showRadioButton = shouldShowCheckBox
            }
        case let raceHorseCellViewModel as RaceHorseCellViewModel:
            if let raceHorseCell = cell as? HorseAndJockeyCell {
                raceHorseCellViewModel.selected = objectsSelected.contains(where: {$0.getCName() == raceHorseCellViewModel.racehorse.getCName()})
                raceHorseCell.viewModel = raceHorseCellViewModel
                raceHorseCell.showRadioButton = shouldShowCheckBox
            }
        default:
            break
        }
        cell.layoutIfNeeded()
        return cell
    }
    
    func numberOfItemsInSection() -> Int {
        return viewModelsForDisplaying.count
    }
    
    func didChoice(for tableView: UITableView, indexPath: IndexPath) {
        let object = objects[indexPath.row]
        execute()
        
        /*-------------------------------------------------------------------------------------------*/
        func execute() {
            if(shouldShowCheckBox) {
                deleleItem()
            } else {
                showDetail()
            }
        }
        
        func deleleItem() {
            if let index = objectsSelected.firstIndex(where: { $0.getCName() == object.getCName() }) {
                objectsSelected.remove(at: index)
            } else {
                objectsSelected.append(object)
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
        }
        
        func showDetail() {
            self.emitPushWebview(object.getUrlString())
        }
        /*-------------------------------------------------------------------------------------------*/
    }
    
    func getName(_ index: Int) -> String? {
        guard let object = objects.safeObjectForIndex(index: index) else { return nil }
        switch object {
        case let jockey as OshiKishu:
            return jockey.jon
        case let racehorse as OshiUma:
            return racehorse.bna
        default:
            return nil
        }
    }
    
    private func getSysEnvMaximumCode() -> SysEnvCode {
        return self.selectedSegment == .favoriteJockeys ? .maximumNumberOfGuessedRiders : .maximumNumberOfHorsesToBeGuessed
    }
    
    private func getSystemValue() async throws -> ResponseSysEnv {
        return try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .sysEnv, showLoading: false, completion: responseSysEnv)
            
            func responseSysEnv(_ response: ResponseSysEnv?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    private func getJockeys() async throws -> [OshiKishu] {
        return try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .getOshiKishuList, showLoading: false, completion: responseOshiKishu)
            
            func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    private func getRaceHorses() async throws -> [OshiUma] {
        return try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .getOshiUmaList, showLoading: false, completion: responseOshiUma)
            
            func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    private func deleteOshiKishu(_ joccode: String) async throws -> [OshiKishu] {
        try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .deleteOshiKishu(joccode), showLoading: false, completion: responseOshiKishu)
            
            func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    private func deleteOshiUma(_ blr: String) async throws -> [OshiUma] {
        try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .deleteOshiUma(blr), showLoading: false, completion: responseOshiUma)
            
            func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    private func multiDeleteOshiKishu(_ joccode: String) async throws -> [OshiKishu] {
        try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .multiDeleteOshiKishi(joccode), showLoading: false, completion: responseOshiKishu)
            
            func responseOshiKishu(_ response: ResponseOshiKishu?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    private func multiDeleteOshiUma(_ blr: String) async throws -> [OshiUma] {
        try await withCheckedThrowingContinuation { continuation in
            manager.call(endpoint: .multiDeleteOshiUma(blr), showLoading: false, completion: responseOshiUma)
            
            func responseOshiUma(_ response: ResponseOshiUma?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
}
