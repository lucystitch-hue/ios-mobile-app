//
//  MainViewModel.swift
//  IMT-iOS
//
//  Created by dev on 16/06/2023.
//

import Foundation

import UIKit
import MaterialComponents

protocol MainViewModelProtocol: BaseViewModel {
    var onCountNotification: ObservableObject<Int> { get set }
    var onGotoScreen:JTabScreenInfo { get set }
    var onGotoTab:JTabScreen { get set }
    var onGoToTabAndMessage: JTabScreenAndMessage { get set }
    var onGotoTabFromNotification: JTabScreen { get set }
    var onGotoTabToRoot: JTabScreen { get set }
    
    //Tab screen
    func getHomeVC() -> HomeVC
    func getRaceVC() -> RaceVC
    func getLiveVC() -> LiveVC
    func getMenuVC() -> MenuVC
    func getVoteVC() -> VoteVC
    
    func checkNotifyBadge()
    func focusTabFromIncomingNotification(_ controller: MainVC?) //discussion: After focus tab. IMTContentVC call action to push screen
    func openDetailSreen(_ tab: JTabInfo)
}

class MainViewModel: BaseViewModel {
    var onCountNotification: ObservableObject<Int> = ObservableObject<Int>(Constants.countNotification)
    var onGotoScreen: JTabScreenInfo = { _ in }
    var onGotoTab: JTabScreen = { _ in }
    var onGoToTabAndMessage: JTabScreenAndMessage = { _ in }
    var onGotoTabFromNotification: JTabScreen = { _ in }
    var onGotoTabToRoot: JTabScreen = { _ in }
    
    private let homeVC = HomeVC()
    private let raceVC = RaceVC()
    private let liveVC = LiveVC()
    private let menuVC = MenuVC()
    private let voteVC = VoteVC()
    
    override init() {
        super.init()
        addObserver()
    }
    
    override func refreshData() {
        
    }
    
    override func removeObserver() {
        Utils.removeObserver(self, name: .onCountNotification)
        Utils.removeObserver(self, name: .openScreenFromNotify)
    }

}

extension MainViewModel: MainViewModelProtocol {
    func checkNotifyBadge() {
        NotificationManager.share().updateBadge()
    }
    
    func getHomeVC() -> HomeVC {
        return homeVC
    }
        
    func getRaceVC() -> RaceVC {
        return raceVC
    }
    
    func getLiveVC() -> LiveVC {
        return liveVC
    }
    
    func getMenuVC() -> MenuVC {
        return menuVC
    }
    
    func getVoteVC() -> VoteVC {
        return voteVC
    }
    
    func openDetailSreen(_ tabInfo: JTabInfo) {
        let tab = tabInfo.tab
        let data = tabInfo.data
        
        switch tab {
        case .home:
            homeVC.action(data)
            break
        case .race:
            raceVC.action(data)
            break
        case .live:
            liveVC.action(data)
            break
        case .menu:
            menuVC.action(data)
            break
        case .onlineVote:
            voteVC.action(data)
        }
    }
    
    func focusTabFromIncomingNotification(_ controller: MainVC?) {
        guard let controller = controller else { return }
        guard let notification = Constants.incomingNotification else { return }
        guard let tab = notification.getType()?.tab() else { return }
        guard let currentTab = IMTTab(rawValue: controller.selectedIndex) else { return }
        
        if(currentTab == tab) {
            let tabInfo: JTabInfo = (tab: tab, data: notification)
            openDetailSreen(tabInfo)
        } else {
            onGotoTab(tab)
        }
    }
    
}

//MARK: Private
extension MainViewModel {
    private func addObserver() {
        Utils.onObserver(self, selector: #selector(loadCountNotification), name: .onCountNotification)
        Utils.onObserver(self, selector: #selector(onOpenScreenFromNotify), name: .openScreenFromNotify)
        Utils.onObserver(self, selector: #selector(onOpenTab), name: .openTab)
        Utils.onObserver(self, selector: #selector(onOpenTabAndMessage), name: .openTabAndMessage)
        Utils.onObserver(self, selector: #selector(onOpenTabToRoot), name: .openTabToRoot)
    }
}

//MARK: Observer
extension MainViewModel {
    @objc private func loadCountNotification(_ notification: Notification) {
        let count = Constants.countNotification
        self.onCountNotification.value = count
    }
    
    @objc private func onOpenScreenFromNotify(_ notification: Notification) {
        guard let IMTTab = notification.object as? IMTTab else { return }
        self.onGotoTabFromNotification(IMTTab)
    }
    
    @objc private func onOpenTab(_ notification: Notification) {
        guard let IMTTab = notification.object as? IMTTab else { return }
        self.onGotoTab(IMTTab)
    }
    
    @objc private func onOpenTabAndMessage(_ notification: Notification) {
        guard let IMTTab = notification.object as? JTabAndMessage else { return }
        self.onGoToTabAndMessage(IMTTab)
    }
    
    @objc private func onOpenTabToRoot(_ notification: Notification) {
        guard let IMTTab = notification.object as? IMTTab else { return }
        self.onGotoTabToRoot(IMTTab)
    }
}

