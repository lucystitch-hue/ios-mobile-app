//
//  BaseViewController.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation
import UIKit
import MaterialComponents
import Toast_Swift
import IQKeyboardManagerSwift

class BaseViewController: UIViewController {
    
    public var isFirstLoad: Bool = true
    public var onPushScreen: JVoid = {} //Push to detail screen from parent
    public var applicationState: ApplicationState! = .active
    
    private var refreshControl = UIRefreshControl()
    private var vMaskGuide: UIView?
    private var flagTransition: String?
    var onDidResultCheckVerion: ((AppVersionUpdateState) -> Void) = { _ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
        onPushScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateLatestController()
        removeObserver()
        setupObserver()
        
        super.viewWillAppear(animated)
        removeMaskGuide()
        isFirstLoad = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        collapse()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.onDismissChild(self)
        super.dismiss(animated: flag, completion: completion)
    }
    
    @objc public func gotoBack() {
        self.pop()
    }
    
    @objc public func collapse() {
        view.endEditing(true)
    }
    
    @objc public func refreshData() {
        self.viewWillAppear(true)
    }
    
    @objc public func actionPullRequest() {
        setupData()
    }
    
    @objc private func didChangeStateApp(notification: Notification) {
        self.applicationState = notification.object as? ApplicationState
        guard let state = applicationState else { return }
        
        switch state {
        case .background:
            self.didChangeBackground()
            break
        case .foreground:
            self.willChangeForeground()
            break
        case .active:
            self.didBecomeActive()
            break
        case .inactive:
            self.willResignActive()
            break
        }
    }
    
    public func didChangeBackground() {
        collapse()
        IQKeyboardManager.shared.enable = false
    }
    
    public func willChangeForeground() {
        IQKeyboardManager.shared.enable = true
        checkVersion(continue: nil, situation: .foreground) { state in
            self.showPopupUpgrade(self, state: state)
        }
    }
    
    public func didBecomeActive() {

    }
    
    public func willResignActive() {
        
    }
    
    public func showPopupLinkage() {
        guard let viewController = self.children.first is IMTContentActionProtocol ? self.children.first : self, let contentVC = viewController as? IMTContentActionProtocol else { return }
        
        let vc = LinkageSubcriptionVC()
        vc.onGotoVoteOnline = contentVC.gotoVoteOnline
        vc.view.backgroundColor = UIColor(white: 0, alpha: 0.25)
        viewController.presentOverFullScreen(vc)
    }
    
    public func hidePopupLinkage() {
        let viewController = presentedViewController as? LinkageSubcriptionVC
        
        guard let viewController = viewController else { return }
        
        viewController.dismiss(animated: false)
    }
    
    public func showWarningLegalAge(_ onDismiss: JVoid? = nil) {
        showWarning(.legalAge) { _,_  in
            onDismiss?()
        }
    }
    
    public func showWarningLimitUpdate(_ onDismiss: JVoid? = nil) {
        showWarning(.limitUpdate) { _,_  in
            onDismiss?()
        }
    }
    
    public func showWarningErrorReadingQR(_ onDismiss: JVoid? = nil) {
        showWarning(.errorReadingQR) { _,_  in
            onDismiss?()
        }
    }
    
    public func showWarningLimitTicket(limit: Int, _ onDismiss: JVoid? = nil) {
        showWarning(.limitTicket(limit)) { _,_  in
            onDismiss?()
        }
    }
    
    public func showWarningRequestUpgrade(_ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.requestUpgrade, requireClose: false, onDismiss: onDismiss)
    }
    
    public func showWarningForceUpgrade(_ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.forceUpgrade, requireClose: false, onDismiss: onDismiss)
    }
    
    public func showWarningWithMessage(_ message: String, _ onDismiss: JVoid? = nil) {
        showWarning(.custom(message)) { _,_  in
            onDismiss?()
        }
    }
    
    public func showWarningWhenDeleteSingleTicket(_ onDismiss:((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.deleteSingleTicket, onDismiss: onDismiss)
    }
    
    public func showWarningWhenDeleteMultipleTicket(numberOfItem: Int, _ onDismiss:((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.deleteMultipleTicket(numberOfItem: numberOfItem), onDismiss: onDismiss)
    }
    
    public func showWarningAddFavoritePerson(person: String, _ onDismiss:((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.addListFavorite(person), onDismiss: onDismiss)
    }
    
    public func showWarningRemoveFavoritePerson(person: String, _ onDismiss:((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.removeListFavorite(person), onDismiss: onDismiss)
    }
    
    public func showWarningListOfFavoriteJockeys(person: String, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.listOfFavoriteJockeys(person), onAction: onAction)
    }
    
    public func showWarningLimitOfFavoriteJockeys(_ limit: Int = Constants.System.limitAddFavorite, _ onDismiss:((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.limitListFavoriteJockeys(limit), onDismiss: onDismiss)
    }
    
    public func showWarningLimitListRecommendedHorses(_ limit: Int = Constants.System.limitAddFavorite, _ onDismiss:((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.limitListRecommendedHorses(limit), onDismiss: onDismiss)
    }
    
    public func showWarningAddRecommendedHorse(horse: String, _ onDismiss:((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.addListRecommended(horse), onDismiss: onDismiss)
    }
    
    public func showWarningRemoveRecommendHorse(horse: String, _ onDismiss:((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.removeListRecommened(horse), onDismiss: onDismiss)
    }
    
    public func showWarningListOfRecommendedHorses(horse: String, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.listOfRecommendedHorses(horse), onAction: onAction)
    }
    
    public func showWarningCancelPushHorse(horseName: String, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.cancelThePushHorse(horseName), onDismiss: onDismiss)
    }
    
    public func showWarningPushHorseReleased(horseName: String, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.pushHorseHasBeenReleased(horseName), onDismiss: onDismiss)
    }
    
    public func showWarningCancelFavoriteJockey(jockeyName: String, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.cancelThePushJockey(jockeyName), onDismiss: onDismiss)
    }
    
    public func showWarningFavoriteJockeyReleased(jockeyName: String, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.favoriteJockeyHasBeenReleased(jockeyName), onDismiss: onDismiss)
    }
    
    public func showWarningCancelMultiplePushHorse(numberOfItems: Int, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.cancelMultipleThePushHorse(numberOfItems: numberOfItems), onDismiss: onDismiss)
    }
    
    public func showWarningCancelMultipleTheFavoriteJockey(numberOfItems: Int, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        showWarning(.cancelMultipleTheFavoriteJockey(numberOfItems: numberOfItems), onDismiss: onDismiss)
    }
    
    public func showWarningWouldYouLikeToRegisterAsAFavoriteHorse(_ horse: String, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.wouldYouLikeToRegisterAsAFavoriteHorse(horse), onAction: onAction)
    }
    
    public func showWarningIHaveRegisteredAsAFavoriteHorse(_ horse: String, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.iHaveRegisteredAsAFavoriteHorse(horse), onAction: onAction)
    }
    
    public func showWarningAlreadyRegisteredAsAFavoriteHorse(_ horse: String, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.alreadyRegisteredAsAFavoriteHorse(horse), onAction: onAction)
    }
    
    public func showWarningWouldYouLikeToRegisterAsAFavoriteJockey(_ person: String, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.wouldYouLikeToRegisterAsAFavoriteJockey(person), onAction: onAction)
    }
    
    public func showWarningIHaveRegisteredAsAFavoriteJockey(_ person: String, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.iHaveRegisteredAsAFavoriteJockey(person), onAction: onAction)
    }
    
    public func showWarningIAmRegisteredAsAFavoriteJockey(_ person: String, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.iAmRegisteredAsAFavoriteJockey(person), onAction: onAction)
    }
    
    public func showWarningCancelMultiple(with selectedSegment: ListHorsesAndJockeysSegment, numberOfItems: Int, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        switch selectedSegment {
        case .favoriteJockeys:
            showWarningCancelMultipleTheFavoriteJockey(numberOfItems: numberOfItems, onDismiss)
        case .recommendedHorses:
            showWarningCancelMultiplePushHorse(numberOfItems: numberOfItems, onDismiss)
        }
    }
    
    public func showWarningCancel(with selectedSegment: ListHorsesAndJockeysSegment, name: String, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        switch selectedSegment {
        case .favoriteJockeys:
            showWarningCancelFavoriteJockey(jockeyName: name, onDismiss)
        case .recommendedHorses:
            showWarningCancelPushHorse(horseName: name, onDismiss)
        }
    }
    
    public func showWarningReleased(with selectedSegment: ListHorsesAndJockeysSegment, name: String, _ onDismiss: ((WarningAction?, WarningVC?) -> Void)? = nil) {
        switch selectedSegment {
        case .favoriteJockeys:
            showWarningFavoriteJockeyReleased(jockeyName: name, onDismiss)
        case .recommendedHorses:
            showWarningPushHorseReleased(horseName: name, onDismiss)
        }
    }
    
    public func showPurchaseHorseRacingTicket(_ onSelectedOption: ((PurchaseHorseRacingTicketOption) -> Void)? = nil) {
        let purchaseHorseRacingVC = PurchaseHorseRacingTicketVC()
        purchaseHorseRacingVC.modalTransitionStyle = .crossDissolve
        purchaseHorseRacingVC.onSelectedOption = onSelectedOption
        presentOverFullScreen(purchaseHorseRacingVC, animate: true)
    }
    
    public func showWarningDidRemoveAllPreferenceComplete(_ numberOfItem: Int, _ segment: ListHorsesAndJockeysSegment, _ onAction:((_ tag: Int,_ controller: WarningV2VC?) -> Void)? = nil) {
        showWarningV2(.didRemoveAllPreferenceComplete(numberOfItem, segment), onAction: onAction)
    }
    
    //MARK: Transition
    public func transition(link: TransactionLink) {
        self.transition(link.rawValue)
    }
    
    func checkInterfaceOrientation() {
        if let window = UIApplication.shared.windows.first  {
            if ( window.safeAreaInsets.top != 0.0){
                Constants.topPadding = window.safeAreaInsets.top
            }
        }
    }
    
    public func transition(_ string: String, post: Bool = false, convertHTML: Bool = false, replaceAttributeHTML: [String: String]? = nil, delegate: IMTWebVCDelete? = nil, userAgent: String? = Constants.System.userAgentIMTA) {
        let webVC = IMTWebVC(string: string, post: post, convertHTML: convertHTML, replaceAttributeHTML: replaceAttributeHTML, delegate: delegate, userAgent: userAgent)
        let vc = UINavigationController(rootViewController: webVC)
        self.presentOverFullScreen(vc)
    }
    
    public func transition(info: JMTrans, delegate: IMTWebVCDelete? = nil) {
        if(!info.useWebView) {
            //TODO: open on the third app
            if let appName = TransactionLink(rawValue: info.url)?.appName(),
               let url = URL(string: appName) {
                let open = UIApplication.shared.canOpenURL(url)
                if(open && flagTransition == nil) {
                    UIApplication.shared.open(url) { [weak self] finish in
                        self?.flagTransition = nil
                    }
                    return
                }
            }
            
            //TODO: Open on browser or appstore
            transitionFromSafari(info.url)
        } else {
            
            //TODO: Open on webView
            transition(info.url, delegate: delegate)
        }
    }
    
    public func transitionFromSafari(_ string: String) {
        if flagTransition == nil {
            if let url = URL(string: string) {
                flagTransition = url.absoluteString
                UIApplication.shared.open(url) { [weak self] finish in
                    self?.flagTransition = nil
                }
            }
        }
    }
    
    public func transitionToInquiries() {
        let version = Bundle.main.releaseVersionNumberPretty
        let category = 2
        let link = "\(TransactionLink.faqMail.rawValue)?category=\(category)&ver=\(version)"
        transitionFromSafari(link)
    }
    
    public func transitionChangeModel() {
        let link = "\(TransactionLink.changeModel.rawValue)"
        transitionFromSafari(link)
    }
    
    //MARK: Guide
    public func gotoGuide(_ completion:@escaping(JVoid) = {}) {
        let vc = GuideVC()
        
        vc.onDismiss = { [weak self] in
            self?.removeMaskGuide()
            completion()
        }
        
        vc.onGotoLinkageSubcription = { [weak self] in
            self?.showPopupLinkage()
        }
        
        self.add(vc)
        
        //TODO: Config vMaskGuide
        configMaskGuide()
        
        //TODO: Config content
        guard let vContent = vc.view else { return }
        loadContentGuideMaskGuide(vContent)
    }
    
    public func onDismissChild(_ controller: UIViewController) {
        removeMaskGuide()
    }
    
    public func showToast(message: String, position: ToastPosition = .bottom) {
        self.view.makeToast(message, duration: 1.0, position: position)
    }
    
    public func showAlert(title: String = "", message: String, completion: JVoid? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { alertAction in
            guard let completion = completion else { return }
            completion()
        }))
        
        self.present(alert, animated: true)
    }
    
    //MARK: PullRequest
    public func configRefreshControl(_ scrollView: UIScrollView) {
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(actionPullRequest), for: .valueChanged)
    }
    
    public func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    //MARK: Other
    public func action(_ data: FIRNotificationModel) {
        
    }
    
    public func allowToBack() -> Bool {
        return true
    }
    
    public func getContentView() -> UIView {
        return self.view
    }
}

extension BaseViewController: MDCBottomSheetControllerDelegate {
    func bottomSheetControllerDidDismissBottomSheet(_ controller: MDCBottomSheetController) {
        onDismissChild(controller)
    }
}

extension BaseViewController: IMTForceUpdateProtocol {
    @objc func continueWhenCancelUpgrade(_ controller: BaseViewController?) {
        
    }
    
    @objc func checkVersionBecomeForeground() -> Bool {
        return true
    }
    
    @objc func checkVersionWhenRunApp() -> Bool {
        return false
    }
}

//MARK: Private
extension BaseViewController {
    private func setupUI() {
        checkInterfaceOrientation()
    }
    
    private func setupData() {
        checkVersion(continue: nil, situation: .autoLogin) { state in
            self.showPopupUpgrade(self, state: state)
        }
        
        printLog()
    }
    
    private func setupObserver() {
        Utils.onObserver(self, selector: #selector(showErrorSystemp), name: .showErrorSystem)
        Utils.onObserver(self, selector: #selector(didChangeStateApp), name: .stateApp)
    }
    
    private func removeObserver() {
        Utils.removeObserver(self, name: .showErrorSystem)
        Utils.removeObserver(self, name: .stateApp)
        
    }
    
    @objc func showErrorSystemp(_ notification: Notification) {
        guard let lastControllerName = Constants.lastController else { return }
        let controllerName = self.getName()
        
        if(lastControllerName == controllerName || UserManager.share().expired()) {
            guard let message = notification.object as? String else { return }
            Utils.mainAsyncAfter(Constants.System.delayToast) {
                self.showToastBottom(message)
            }
        }
    }
    
    public func removeMaskGuide() {
        if let vMaskGuide = vMaskGuide, !isFirstLoad {
            vMaskGuide.removeFromSuperview()
            self.vMaskGuide = nil
            self.onDismissChild(self)
        }
    }
    
    private func configMaskGuide() {
        vMaskGuide = UIView()
        
        vMaskGuide!.backgroundColor = UIColor(white: 0, alpha: 0.25)
        self.view.addSubview(vMaskGuide!)
        vMaskGuide!.translatesAutoresizingMaskIntoConstraints = false
        
//        let top = getHeightHeader()
        NSLayoutConstraint.activate([
            vMaskGuide!.topAnchor.constraint(equalTo: self.view.topAnchor),
            vMaskGuide!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            vMaskGuide!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            vMaskGuide!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func loadContentGuideMaskGuide(_ contentView: UIView) {
        vMaskGuide!.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        var hGuide = (UIScreen.main.bounds.height - IMTTabVC.getHeightHeader()) * Constants.BottomSheetConfigure.ratioMainScreen
        
        if (UIScreen.main.bounds.height <= Constants.hScreenSE1) {
            hGuide = (UIScreen.main.bounds.height - IMTTabVC.getHeightHeader()) * Constants.BottomSheetConfigure.ratioMainScreenSE1
        } else if(UIScreen.main.bounds.height <= Constants.hScreenSE3) {
            hGuide = (UIScreen.main.bounds.height - IMTTabVC.getHeightHeader()) * (UIScreen.isZoomed ? Constants.BottomSheetConfigure.ratioMainScreenSE1 : Constants.BottomSheetConfigure.ratioMainScreenSE3)
        }
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: hGuide),
            contentView.leadingAnchor.constraint(equalTo: vMaskGuide!.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: vMaskGuide!.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: vMaskGuide!.trailingAnchor)
        ])
        
        self.view.bringSubviewToFront(vMaskGuide!)
    }
    
    private func loadContentLinkage(_ contentView: UIView) {
        vMaskGuide!.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: vMaskGuide!.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: vMaskGuide!.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: vMaskGuide!.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: vMaskGuide!.trailingAnchor)
        ])
        
        self.view.bringSubviewToFront(vMaskGuide!)
    }
    
    private func showWarning(_ type: WarningType, requireClose: Bool = true, onDismiss: ((_ action: WarningAction?,_ controller: WarningVC?) -> Void)?) {
        let warningViewController = WarningVC(requireClose: requireClose)
        warningViewController.modalTransitionStyle = .crossDissolve
        warningViewController.viewModel = WarningViewModel(type)
        warningViewController.onDismiss = onDismiss
        self.presentOverFullScreen(warningViewController, animate: true)
    }
    
    private func showWarningV2(_ type: WarningTypeV2, requireClose: Bool = true, onAction:((_ tag: Int, _ controller: WarningV2VC?) -> Void)?) {
        let warningVC = WarningV2VC(requireClose: requireClose, type: type)
        warningVC.modalTransitionStyle = .crossDissolve
        warningVC.onAction = onAction
        self.presentOverFullScreen(warningVC, animate: true)
    }
    
    private func updateLatestController() {
        Constants.lastController = self.getName() == "WarningVC" || self.getName() == "WarningV2VC" ? Constants.lastController : self.getName()
    }
    
    private func printLog() {
        print("### Current controller name: \(self.getName())")
    }
}
