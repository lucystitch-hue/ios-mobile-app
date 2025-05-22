//
//  ListNotificationViewModel.swift
//  IMT-iOS
//
//  Created by dev on 25/03/2023.
//

import Foundation
import UIKit

enum ListNotificationMode: Int {
    case important = 0
    case advantageous = 1
}

protocol ListNotificationViewModelProtocol: BaseViewModel {
    var mode: ObservableObject<ListNotificationMode> { get set }
    var isCurrentScreen: Bool { get set }
    var notifications: ObservableObject<[NotificationModel]> { get set }
    var onReadNotificationSuccessfully: JVoid { get set }
    
    func markAllSeen(_ table: UITableView)
    func register(table: UITableView, delegate: ListNotificationVC)
    func numSection(_ tableView: UITableView) -> Int
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func didChoice(controller: ListNotificationVC?, tableView: UITableView, section: Int)
    func footerView() -> UIView
    func heightFooter() -> CGFloat
    
    func getReadNotification()
    func gotoDetailNotification(_ controller: ListNotificationVC?, bundle: [NotificationBundleKey: Any])
    func callAPI()
}

class ListNotificationViewModel: BaseViewModel {
    var mode: ObservableObject<ListNotificationMode> = ObservableObject<ListNotificationMode>(.important)
    var notifications: ObservableObject<[NotificationModel]> = ObservableObject<[NotificationModel]>([])
    var onReadNotificationSuccessfully: JVoid = {}
    var isCurrentScreen: Bool = true
    private var group: DispatchGroup!
    
    override init() {
        super.init()
        addObserver()
    }
    
    override func removeObserver() {
        super.removeObserver()
        Utils.removeObserver(self, name: .onCountNotification)
    }
}

extension ListNotificationViewModel: ListNotificationViewModelProtocol {
    //TODO: Call
    @objc func callAPI() {
        if(isCurrentScreen) {
            self.group = DispatchGroup()
            
            group.enter()
            getListNotification()
            
            group.notify(queue: .main) {
                if !Utils.hasIncommingNotification() {
                    Utils.hideProgress()
                }
            }
        }
    }
    
    func markAllSeen(_ table: UITableView) {
        Constants.countNotification = 0
        table.reloadData()
        Utils.postObserver(.markAllSeen, object: true)
    }
    
    func register(table: UITableView, delegate: ListNotificationVC) {
        table.register(identifier: NotificationCell.identifier)
        table.dataSource = delegate
        table.delegate = delegate
    }
    
    func numSection(_ tableView: UITableView) -> Int {
        return notifications.value?.count ?? 0
    }
    
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.identifier) as? NotificationCell else { return UITableViewCell()}
        let item = notifications.value?[indexPath.section]
        cell.setup(item)
        cell.setNeedsLayout()
        return cell
    }
    
    func didChoice(controller: ListNotificationVC?, tableView: UITableView, section: Int) {
        guard let detail = notifications.value?[section] else { return }
        self.gotoDetailNotification(controller, bundle:[.detail: detail])
        self.isCurrentScreen = false
    }
    
    func footerView() -> UIView {
        return FootterDotLine()
    }
    
    func heightFooter() -> CGFloat {
        return Constants.HeightConfigure.smallFooterLine
    }

    func gotoDetailNotification(_ controller: ListNotificationVC?, bundle: [NotificationBundleKey: Any]){
        guard let controller = controller else { return }
        controller.onGotoDetail?(bundle)
    }
}

//MARK: API
extension ListNotificationViewModel {
    
    func getListNotification() {
        manager.call(endpoint: .notificationList, completion: responseListNotification)
    }
    
    func getReadNotification() {
        NotificationManager.share().markAll({ [weak self] data in
            self?.notifications.value = data
            self?.onReadNotificationSuccessfully()
        })
    }
    
    //TODO: Response
    private func response<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void)) {
        
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
    
    private func responseListNotification(_ response: ResponseNotification?, success: Bool) {
        self.response(response) { [weak self] res in
            self?.notifications.value = res.data
            if (self?.notifications.value == nil){
                self?.showMessageError(message: "Not found notification with this user")
            }
        }
    }
    
}

//MARK: Private
extension ListNotificationViewModel {
    private func addObserver() {
        Utils.onObserver(self, selector: #selector(callAPI), name: .onCountNotification)
    }
}


