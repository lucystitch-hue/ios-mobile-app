//
//  MainVC.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation
import UIKit

class MainVC: UITabBarController {
    
    var isShow:Bool!
    private var viewModel: MainViewModelProtocol!
    static let maskViewIdentifier = "MaskView"
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.checkNotifyBadge()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.focusTabFromIncomingNotification(self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserver()
    }
}

//MARK: Static
extension MainVC {
    
}

//MARK: Private
extension MainVC {
    private func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.viewControllers = getTabs()
        addBordersToTabBarItemsExceptLast()
        
        if #available(iOS 13.0, *) {
            updateTabBarAppearance()
        }
    }
    
    private func setupData() {
        viewModel = MainViewModel()
        
        viewModel.onCountNotification.bind { [weak self] count in
            self?.onShowBade()
        }
        
        viewModel.onGotoScreen = { [weak self] tabInfo in
            self?.selectedIndex = tabInfo.tab.rawValue
            self?.viewModel.openDetailSreen(tabInfo)
        }
        
        viewModel.onGotoTab = { [weak self] tab in
            if let selectedIndex = self?.selectedIndex,
               let previousVC = self?.viewControllers?[selectedIndex],
               let currentVC = self?.viewControllers?[tab.rawValue] {
                self?.addHomeContentWhenChangeTab(current: currentVC, previous: previousVC)
            }
            self?.selectedIndex = tab.rawValue
        }
        
        viewModel.onGoToTabAndMessage = { [weak self] info in
            let tab = info.tab
            self?.selectedIndex = tab.rawValue
            
            guard let message = info.message else { return }
            if let tabVC = self?.selectedViewController?.children.last as? IMTTabVC {
                let contentVC = tabVC.getContentVC().controller()
                contentVC.showToastBottom(message, hasImage: true)
            }
        }
        
        viewModel.onGotoTabToRoot = { [weak self] tab in
            
            if let selectedIndex = self?.selectedIndex,
               let previousVC = self?.viewControllers?[selectedIndex],
               let currentVC = self?.viewControllers?[tab.rawValue],
               let tabVC = currentVC.children.last as? IMTTabVC {
                self?.addHomeContentWhenChangeTab(current: currentVC, previous: previousVC)
                
                var contentVC = tabVC.getContentVC()
                contentVC.prepareRoot()
            }
            
            self?.selectedIndex = tab.rawValue
        }
        
        viewModel.onGotoTabFromNotification = { [weak self] tab in
            self?.viewModel.focusTabFromIncomingNotification(self)
        }
        
        self.delegate = self
    }
    
    private func setupEvent() {
        
    }
    
    private func removeObserver() {
        viewModel.removeObserver()
    }
    
    private func addBordersToTabBarItemsExceptLast() {
        let tabBarItems = tabBar.items ?? []
        
        for (index, _) in tabBarItems.enumerated() {
            if index < tabBarItems.count - 1 {
                addBordersToTabBarItem(index: index)
            }
        }
    }
    
    private func addBordersToTabBarItem(index: Int) {
        let tabBarItems = tabBar.items ?? []
        
        guard index >= 0 && index < tabBarItems.count else {
            return
        }
        
        let tabBarItem = tabBarItems[index]
        
        let borderWidth: CGFloat = 1.0
        let borderColor = UIColor.white
        
        let borderView = UIView()
        borderView.backgroundColor = borderColor
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        if let viewChild = tabBarItem.value(forKey: "view") as? UIView {
            viewChild.addSubview(borderView)
            viewChild.bringSubviewToFront(borderView)
            
            borderView.trailingAnchor.constraint(equalTo: viewChild.trailingAnchor, constant: 1).isActive = true
            borderView.topAnchor.constraint(equalTo: viewChild.topAnchor).isActive = true
            borderView.bottomAnchor.constraint(equalTo: viewChild.bottomAnchor).isActive = true
            borderView.widthAnchor.constraint(equalToConstant: borderWidth).isActive = true
        }
    }
    
    private func getTabs() -> [UIViewController] {
        let homeVC = getRootNavigation(IMTTabVC(child: viewModel.getHomeVC()))
        let raceVC = getRootNavigation(IMTTabVC(child: viewModel.getRaceVC()))
        let onlineVotingVC = getRootNavigation(IMTTabVC(child:viewModel.getVoteVC()))
        let liveVC = getRootNavigation(IMTTabVC(child: viewModel.getLiveVC()))
        let menuVC = getRootNavigation(IMTTabVC(child: viewModel.getMenuVC()))
        
        homeVC.tabBarItem = getBarItem(title: .tab.home, image: .home)
        raceVC.tabBarItem = getBarItem(title: .tab.race, image: .race)
        onlineVotingVC.tabBarItem = getBarItem(title: .tab.onlineVoting, image: .onlineVoting)
        liveVC.tabBarItem = getBarItem(title: .tab.live, image: .live)
        menuVC.tabBarItem = getBarItem(title: .tab.menu, image: .menu)
        
        return [homeVC, raceVC,  onlineVotingVC, liveVC, menuVC]
    }
    
    private func getRootNavigation(_ controller: BaseViewController, isNavigationBarHidden: Bool = true) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.isNavigationBarHidden = isNavigationBarHidden
        
        return navController
    }
    
    private func getBarItem(title: String, image: UIImage) -> UITabBarItem {
        let resizeImage = image.resizedImage(.iconTab)
        let tabBarItem = UITabBarItem(title: title, image: resizeImage, selectedImage: resizeImage)
        return tabBarItem
    }
    
    private func updateTabBarAppearance() {
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithOpaqueBackground()
            tabBarAppearance.backgroundColor = .main
            tabBarAppearance.stackedItemPositioning = .automatic
            
            updateTabBarItemAppearance(appearance: tabBarAppearance.compactInlineLayoutAppearance)
            updateTabBarItemAppearance(appearance: tabBarAppearance.inlineLayoutAppearance)
            updateTabBarItemAppearance(appearance: tabBarAppearance.stackedLayoutAppearance)
            
            self.tabBar.standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                self.tabBar.scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
    
    @available(iOS 13.0, *)
    private func updateTabBarItemAppearance(appearance: UITabBarItemAppearance) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.maximumLineHeight = Utils.scaleWithHeight(12)
        
        appearance.selected.iconColor = .theme
        appearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.theme, NSAttributedString.Key.font: UIFont.appFontW4Size(8), NSAttributedString.Key.paragraphStyle: paragraphStyle]
        appearance.normal.iconColor = .white
        appearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.appFontW4Size(8), NSAttributedString.Key.paragraphStyle: paragraphStyle]
    }
    
    private func setHeightTabBar(_ height: CGFloat) {
        let autoHeight = Utils.scaleWithHeight(height)
        
        var tabFrame = tabBar.frame
        tabFrame.size.height = autoHeight
        tabFrame.origin.y = view.frame.size.height - autoHeight
        tabBar.frame = tabFrame
    }
    
    private func addHomeContentWhenChangeTab(current currentVC: UIViewController?, previous previousVC: UIViewController?) {
        
        let homeVC = self.viewControllers?[IMTTab.home.rawValue]
        
        guard let homeTabVC = homeVC?.children.first as? IMTTabVC,
              let homeController = homeTabVC.getContentVC().controller() as? HomeVC,
              let homeParentView = homeController.view else { return }
        homeParentView.backgroundColor = .blue
        
        if(currentVC != homeVC) {
            guard let currentTabVC = currentVC?.children.first as? IMTTabVC else { return }
            let contentVC = currentTabVC.getContentVC()
            contentVC.setHomeContentView(homeController.vContent)
            
        } else {
            guard let previousTabVC = previousVC?.children.first as? IMTTabVC else { return }
            let contentVC = previousTabVC.getContentVC()
            
            if let vContent = contentVC.getHomeContentView() {
                removeMaskView(vContent)
                homeParentView.addSubview(vContent)
                Utils.constraintFull(parent: homeParentView, child: vContent)
            } else {
                removeMaskView(homeParentView)
            }
        }
    }
    
    private func removeMaskView(_ vContent: UIView) {
        if let maskView = getLastView() {
            maskView.removeFromSuperview()
        }
        
        func getLastView() -> UIView? {
            if let stackViewOfHome = vContent.subviews.last as? UIStackView,
            let lastView = stackViewOfHome.subviews.last, lastView.accessibilityIdentifier == MainVC.maskViewIdentifier {
                return lastView
            } else if let lastView = vContent.subviews.last, lastView.accessibilityIdentifier == MainVC.maskViewIdentifier {
                return lastView
            } else if let lastView = vContent.subviews.last?.subviews.last, lastView.accessibilityIdentifier == MainVC.maskViewIdentifier {
                return lastView
            }
            
            return nil
        }
    }
}

//MARK: Observer
extension MainVC {
    @objc private func onShowBade() {
        // true là hiện, flase là ẩn đi
        isShow = Utils.hasNotification()
        if(isShow) {
            self.tabBar.showBadge(at: 4)
        } else {
            self.tabBar.hideBadge(at: 4)
        }
    }
}

extension MainVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //Get parent controller
        var controller = viewController
        
        return execute()
        
        /*------------------------------------------------------------------------------------------*/
        func execute() -> Bool {
            
            //TODO: Step 1
            guard let _ = skipSelectTab() else { return false }
            
            //TODO: Step 2
            scrollToTopIfNeed()
            
            //TODO: Step 3
            refreshData()
            
            addHomeContentWhenChangeTab(current: viewController, previous: selectedViewController)
            
            return true
        }
        
        func skipSelectTab() -> Bool? {
            
            let homeVC = self.viewControllers?[IMTTab.home.rawValue]
            let raceVC = self.viewControllers?[IMTTab.race.rawValue]
            let voteVC = self.viewControllers?[IMTTab.onlineVote.rawValue]
            let liveVC = self.viewControllers?[IMTTab.live.rawValue]
            let menuVC = self.viewControllers?[IMTTab.menu.rawValue]
            let prevController = viewControllers?[selectedIndex]
            
            guard let homeTabVC = homeVC?.children.first as? IMTTabVC,
                  let vHomeContent = homeTabVC.getContentVC().controller() as? HomeVC else {
                return false
            }
            
            
            if prevController == homeVC, UserManager.share().showGuide() {
                return showLinkage()
            } else if controller == voteVC {
                return authentication()
            } else {
                return true
            }
            
            func authentication() -> Bool? {
                IMTBiometricAuthentication().security {
                    if(controller == voteVC) {
                        showPopupVote()
                    }
                }
                
                return nil
            }
        }
        
        func showLinkage() -> Bool? {
            Utils.postObserver(.hideGuide, object: true)
            return nil
        }
        
        func showPopupVote() {
            let previousTabVC = self.viewControllers![self.selectedIndex].children.first as? IMTTabVC
            previousTabVC?.actionVote("")
        }
        
        func scrollToTopIfNeed() {
            let prevController = viewControllers?[selectedIndex]
            
            if(viewController == prevController) {
                if let tabVC = viewController.children.first as? IMTTabVC {
                    var contentVC = tabVC.getContentVC()
                    if !tabVC.availableBack() {
                        contentVC.isScrollToTop = true
                    }
                }
            }
        }
        
        func refreshData() {
            
            if(tabBarController.selectedViewController == viewController) {
                if viewController.isKind(of: UINavigationController.self) {
                    guard let vc = viewController.children.first else { return }
                    controller = vc
                }
            }
            
            controller.viewWillAppear(true)
        }
        /*------------------------------------------------------------------------------------------*/
        
    }
}



