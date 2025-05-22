//
//  SettingsNotificationViewModel.swift
//  IMT-iOS
//
//  Created by dev on 24/03/2023.
//

import Foundation
import UIKit
import Firebase

protocol SettingsNotificationViewModelProtocol: TableWidgetProtocol {
    var indexSelected: ObservableObject<Int> { get set }
    var onUpdateSuccessfully: JVoid { get set }
    var sections: ObservableObject<(data: JSettingNotification?, isIntial: Bool)> { get set }
    
    func back(_ controller: SettingsNotificationVC?)
    
}

class SettingsNotificationViewModel:BaseViewModel, SubscribePreferenceTopic {
    
    var sections: ObservableObject<(data: JSettingNotification?, isIntial: Bool)> = ObservableObject<(data: JSettingNotification?, isIntial: Bool)>((data: nil, isIntial: false))
    var indexSelected: ObservableObject<Int> = ObservableObject<Int>(-1)
    var onUpdateSuccessfully: JVoid = {}
    
    override init() {
        super.init()
        getNotificationSetting()
    }
}

extension SettingsNotificationViewModel: SettingsNotificationViewModelProtocol {
    
    func numSection(_ tableView: UITableView) -> Int {
        return SettingsNotificationSection.allCases.count
    }

    func numCell(_ tableView: UITableView, section: Int) -> Int {
        guard let count = getSection(_indexAt: section)?.value.count else { return 0 }
        return count
    }
    
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingsCell.identifier) as? NotificationSettingsCell else { return UITableViewCell() }
        let iSection = getSection(_indexAt: indexPath.section)?.value
        let item = iSection?[indexPath.row]
        cell.setup(item, atIndexPath: indexPath)
        return cell
    }
    
    func getHeader(_ tableView: UITableView, section: Int) -> UIView? {
        let iSection = getSection(_indexAt: section)?.key
        let title = iSection?.rawValue ?? ""
        let font = iSection?.font()
        let headerView = HeaderTitle(index: " ", title: title)
        
        headerView.backgroundColor = .white
        headerView.space = 0.0
        headerView.leading = 40.0
        headerView.trailing = 40.0
        headerView.fontTitle = font
        headerView.textColor = .darkCharcoal
        
        return headerView
    }
    
    func getHeightHeader(_ tableView: UITableView, section: Int) -> CGFloat {
        let iSection = getSection(_indexAt: section)?.key
        let height = iSection?.height() ?? 0
        
        return height
    }
    
    func getFootter(_ tableView: UITableView, section: Int) -> UIView? {
        let numItem = SettingsNotificationSection.allCases.count
        let isFetch = self.sections.value?.data?.count != 0
        
        if(section == numItem - 1 && numItem != 0 && isFetch) {
            let vFooter = FootterButton()
            vFooter.onAction = { [weak self] in
                Utils.showProgress(false)
                self?.update()
            }
            
            return vFooter
        }
        
        return nil
    }
    
    func getHeightFootter(_ tableView: UITableView, section: Int) -> CGFloat {
        let numItem = SettingsNotificationSection.allCases.count
        let isFetch = self.sections.value?.data?.count != 0
        
        if(section == numItem - 1 && numItem != 0 && isFetch) {
            return 120.0
        }
        
        return 0.0
    }
    
    func back(_ controller: SettingsNotificationVC?) {
        guard let rootVC = controller?.navigationController?.viewControllers.first else { return }
        rootVC.dismiss(animated: true)
    }
}

//MARK: Private
extension SettingsNotificationViewModel {
    private func update() {
        let param = getParam()
        self.updateSetting(params: param)
    }
    
    private func convert(_ data: NotificationsSettingDataModel?, each:@escaping((topic: String, value: String)) -> Void) -> [SettingsNotificationSection: [ISettingNotificationModel]] {
        guard let data = data else { return [:] }
        let mirror = Mirror(reflecting: data)
        
        var sections: [SettingsNotificationSection: [ISettingNotificationModel]] = [:]
        
        for child in mirror.children {
            let key = child.label!
            let value = (child.value as? String ?? "0") == "1"
            let title = SettingsNotificationItem(rawValue: key)
            let topic = title?.topic() ?? ""
            let topicValue = child.value as? String ?? "0"
            
            let item = ISettingNotificationModel(title: title, checked: value)
            if let section = item.setting.section() {
                var items = sections[section] ?? []
                items.append(item)
                
                each((topic, topicValue))
                
                sections[section] = items
            }
        }
        
        //Add item descript
        if sections[.horseInformation] == nil {
            sections[.horseInformation] = [ISettingNotificationModel(title: .specialRaceRegistrationInformation, checked: false), ISettingNotificationModel(title: .confirmedRaceInformation, checked: false), ISettingNotificationModel(title: .raceResultInformation, checked: false)]
        }
        if sections[.favoriteJockeyInformation] == nil {
            sections[.favoriteJockeyInformation] = [ISettingNotificationModel(title: .thisWeeksHorseRiding, checked: false)]
        }
        sections[.describe] = []
        
        return sections
    }
    
    private func parseParam(_ sections: JSettingNotification?) -> [String: Any] {
        guard let sections = sections else { return [:] }
        var param: [String: Any] = [:]
        
        sections.values.forEach { settings in
            settings.forEach { setting in
                let key = setting.setting.rawValue
                let value = setting.getValue()
                
                param[key] = value
            }
        }
        
        return param
    }
    
    private func subcriseTopic(_ param: [String: Any]) {
        Task { @MainActor in
            do {
                let racehorses = try await getListOshiUma()
                let jockeys = try await getListOshiKishu()
                for (key, value) in param {
                    guard let item = SettingsNotificationItem(rawValue: key) else {
                        continue
                    }
                    let value = value as? String ?? "0"
                    let enable = value == "1"
                    
                    switch item {
                    case .specialRaceRegistrationInformation, .confirmedRaceInformation, .raceResultInformation:
                        subcribeFav(racehorses, key: item.sendkbn(), enable: enable)
                    case .thisWeeksHorseRiding:
                        subcribeFav(jockeys, key: item.sendkbn(), enable: enable)
                    default:
                        subcribeBy(topic: item.topic(), enable: enable)
                    }
                }
            } catch _ {
                
            }
            
            func subcribeFav(_ objects: [PreferenceFeature], key: String, enable: Bool) {
                for object in objects {
                    subcribeBy(topic: object.getTopic(key), enable: enable)
                }
            }
            
            func subcribeBy(topic: String, enable: Bool) {
                if (enable) {
                    subscribeBy(topic)
                } else {
                    unsubscribeBy(topic)
                }
            }
        }
    }
    
    private func getSection(_indexAt index: Int) -> (key: SettingsNotificationSection, value: [ISettingNotificationModel])? {
        let key = SettingsNotificationSection.allCases[index]
        guard let value = sections.value?.data?[key] else { return nil }
        return (key, value)
    }
    
    private func getParam() -> [String: Any] {
        let sections = sections.value?.data
        let param = parseParam(sections)
        
        return param
    }
}

//MARK: API
extension SettingsNotificationViewModel {
    
    //TODO: Call
    private func getNotificationSetting() {
        manager.call(endpoint: .setting, completion: responseNotificationsSetting)
    }
    
    private func updateSetting(params: [String: Any]) {
        self.manager.call(endpoint: .updateSetting(params), showLoading: false, completion: responseUpdateSetting)
        
        func responseUpdateSetting(_ response: ReponseSettingsNotification?, success: Bool) {
            self.response(response, successCompletion: { [weak self] res in
                self?.subcriseTopic(params)
                Utils.mainAsyncAfter { [weak self] in
                    //TODO: Subcribe/Unsubcribe on firbase
                    self?.onUpdateSuccessfully()
                    Utils.hideProgress()
                }
            }, failureCompletion: { [weak self] in
                self?.onUpdateSuccessfully()
                Utils.hideProgress()
            })
        }
    }
    
    //TODO: Response
    private func response<R: BaseResponse>(_ response: R?, successCompletion: @escaping((R) -> Void), failureCompletion: (JVoid?) = {}) {
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
            failureCompletion?()
        }
    }
    
    private func responseNotificationsSetting(_ response: ResponseNotificationsSetting?, success: Bool) {
        self.response(response, successCompletion: { [weak self] res in
            let data = response?.data
            
            let dataSection = self?.convert(data, each: { topicInfo in })
            self?.sections.value = (data: dataSection, isIntial: false)
        })
    }
}
