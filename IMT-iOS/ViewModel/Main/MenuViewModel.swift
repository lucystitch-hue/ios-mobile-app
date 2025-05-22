//
//  MenuMyPersonalViewModel.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import Foundation
import UIKit
import MaterialComponents
import WebKit

enum MenuContentType: Equatable {
    case main
    case personal
    case updatePersonalInfo
    case emailAddressConfirm
    case emailAddressChange
    case changePassword
    case resetPassword
    case confirmOtp(stype: ConfirmOTPStyle!)
    case settingNotification
    case notification
    case detailNotification
    case subcriber
    case updateIpat
    case registerIpat
    case questions
    case faq
    case biometricManagement
    case sendOtpToEmail(stype: MailVerificationStyle!)
    case updateEmailSuccess
    case updateEmailFailure
    case deleteAccount
    case umacaSmartCollaboration
    case updateUMACATicket
    case registerUMACATicket
    case preferredDisplay
    case horseAndJockeySetting(selectedSegment: ListHorsesAndJockeysSegment? = nil)
    case raceHorseSearch
    case jockeySearch
    case topFavorite
    case favoriteSearchResult(type: ListFavoriteSearchResultType, text: String)
    case jockeyResultSearch(type: Abbreviations)
    case webView(_ link: String = "", userAgent: String = Constants.System.userAgentIMTA, convertHTML: Bool = false, post: Bool = false)
}

class MenuViewModel: BaseViewModel {
    
    var meDataModel: ObservableObject<(data: MeDataModel?, isIntial: Bool)> = ObservableObject<(data: MeDataModel?, isIntial: Bool)>((nil, true))
    var onCountNotification: ObservableObject<Int> = ObservableObject<Int>(Constants.countNotification)
    private var group: DispatchGroup?
    private var countRedirectFaqMail = 0
    var onCloseInquiries: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var onChangeContent: ObservableObject<MenuContentType> = ObservableObject<MenuContentType>(.main)
    var onChangePasswordSuccessfull: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var onCheckChangePass: JBool = { _ in }
    var onCheckChangeEmail: JBool = { _ in }
    
    var currentContent: UIView?
    var previousContent: UIView?
    var contentQueue: [(type: MenuContentType, controller: BaseViewController?)] = []
    var contentView: UIView!
    var mainView: UIView!
    var homeContentView: UIView?
    
    var onFetchComplete: JVoid = {}
    
    override init() {
        super.init()
    }
    
    override func removeObserver() {
        super.removeObserver()
        Utils.removeObserver(self, name: .callAPIMe)
        Utils.removeObserver(self, name: .onCountNotification)
    }
    
    override func refreshData() {
        callAPI()
        addObserver()
    }
    
    func setup(contentView: UIView, mainView: UIView, homeContentView: UIView?) {
        self.contentView = contentView
        self.mainView = mainView
        self.homeContentView = homeContentView
    }
    
    func gotoVoteOnline(_ controller: MenuVC?) {
        guard let controller = controller else { return }
        self.loadContent(controller, type: .subcriber)
    }
    
    func gotoUpdatePersonalInfo(_ controller: MenuVC?) {
        IMTBiometricAuthentication().security {
            guard let controller = controller else { return }
            self.loadContent(controller, type: .personal)
        }
    }
    
    func gotoSettingNotification(_ controller: MenuVC?) {
        IMTBiometricAuthentication().security {
            self.loadContent(controller, type: .settingNotification)
        }
    }
    
    func gotoNotification(_ controller: MenuVC?) {
        guard let controller = controller else { return }
        self.loadContent(controller, type: .notification)
    }
    
    func gotoNotificationDetail(_ controller: MenuVC?, messageCode: String) {
        guard let controller = controller else { return }
        let notificationVC = ListNotificationVC()
        
        notificationVC.onDismiss = {
            controller.onDismissChild(notificationVC)
        }
        
        let vc = UINavigationController(rootViewController: notificationVC)
        controller.presentOverFullScreen(vc)
        
        notificationVC.show(messageCode)
    }
    
    func gotoSubscriberNumber(_ controller: MenuVC?) {
        IMTBiometricAuthentication().security {
            guard let controller = controller else { return }
            if(UserManager.share().legalAge()) {
                self.loadContent(controller, type: .subcriber)
            } else {
                controller.showWarningLegalAge()
            }
        }
    }
    
    func gotoLogout(_ controller: MenuVC?) {
        IMTBiometricAuthentication().security {
            guard let controller = controller else { return }
            let vc = LogoutVC()
            controller.presentOverFullScreen(vc, animate: false)
        }
    }
    
    func gotoDeleteAcount(_ controller: MenuVC?) {
        IMTBiometricAuthentication().security {
            guard let controller = controller else { return }
            self.loadContent(controller, type: .deleteAccount)
        }
    }
    
    func checkChangeEmail() {
        IMTBiometricAuthentication().security {
            self.manager.call(endpoint: .checkChangeEmail, showLoading: Utils.hasIncommingNotification(), completion: self.responseCheckChangeEmail)
        }
    }
    
    func gotoEmailAddressConfirmationChange(_ controller: MenuVC?) {
        guard let controller = controller else { return }
        self.loadContent(controller, type: .emailAddressConfirm)
    }
    
    func gotoChangePassword(_ controller: MenuVC?) {
        guard let controller = controller else { return }
        self.loadContent(controller, type: .changePassword)
    }
    
    func gotoConfirmOtp(_ controller: MenuVC?) {
        guard let controller = controller else { return }
        self.loadContent(controller, type: .confirmOtp(stype: .changePassword))
    }
    
    func gotoSendOtpToEmail(_ controller: MenuVC?) {
        guard let controller = controller else { return }
        self.loadContent(controller, type: .confirmOtp(stype: .changePassword))
    }
    
    func gotoListQuestions(_ controller: MenuVC?) {
        loadContent(controller, type: .questions)
    }
    
    func gotoFAQs(_ controller: MenuVC?) {
        let url = TransactionLink.pageFAQ.rawValue
        controller?.transitionFromSafari(url)
    }
    
    func gotoInquiries(_ controller: MenuVC?) {
        let link = getLink()
        loadContent(controller, type: .webView(link, userAgent: Constants.System.userAgentNoDeviceInfo, convertHTML: true))
    }
    
    func gotoPrivacyPolicy(_ controller: MenuVC?) {
        let url = TransactionLink.privacy.rawValue
        loadContent(controller, type: .webView(url))
    }
    
    func gotoTermOfService(_ controller: MenuVC?) {
        let url = TransactionLink.terms.rawValue
        loadContent(controller, type: .webView(url))
    }
    
    func gotoFaqIMTMail(_ controller: MenuVC?) {
        let url = TransactionLink.faqIMTMail.rawValue
        controller?.transitionFromSafari(url)
    }
    
    func gotoBiometricManagement(_ controller: MenuVC?) {
        IMTBiometricAuthentication().security {
            self.loadContent(controller, type: .biometricManagement)
        }
    }
    
    func pushScreenFromNotification(_ controller: MenuVC, data: FIRNotificationModel) {
        if let url = data.url, !url.isEmpty {
            
            var model = NotificationModel(json: [:])
            model.messageCode = data.messageCode
            
            let flagBunle: [NotificationBundleKey: NotificationModel] = [.detail: model]
            let bundle: [MenuBundleKey: Any] = [.detailNotification: flagBunle, .detailNotificationURL: url]
            
            clear()
            
            if(onChangeContent.value != .notification) {
                loadContent(controller, type: .notification)
            }
            
            loadContent(controller, type: .detailNotification, bundle: bundle)
        } else {
            loadContent(controller, type: .notification)
            Utils.clearDataIncommingNotification()
        }
        
        /*------------------------------------------------------------------------------------------------*/
        func clear() {
            let contain = contentQueue.contains { (type: MenuContentType, controller: UIViewController?) in
                return type == .detailNotification
            }
            
            if(contain) {
                guard let times = getTimes() else { return }
                back(controller, times: times)
            }
        }
        
        func getTimes() -> Int? {
            switch onChangeContent.value {
            case .webView:
                return 3
            case .detailNotification:
                return 2
            default:
                return nil
            }
        }
        /*------------------------------------------------------------------------------------------------*/
    }
    
    func getVersionApp() -> String {
        return "Current app version \(Bundle.main.releaseVersionNumberPretty)"
    }
    
    func checkChangePass() {
        IMTBiometricAuthentication().security {
            self.manager.call(endpoint: .checkChangePass, showLoading: Utils.hasIncommingNotification(), completion: self.responseCheckChangePass)
        }
    }
    
    func gotoSendOtpToMail(_ controller: MenuVC?) {
        guard let controller = controller else { return }
        self.loadContent(controller, type: .sendOtpToEmail(stype: .sendCodeChangePassword))
    }
    
    func gotoUMACASmartCollaboration(_ controller: MenuVC) {
        IMTBiometricAuthentication().security {
            if(UserManager.share().legalAge()) {
                self.loadContent(controller, type: .umacaSmartCollaboration)
            } else {
                controller.showWarningLegalAge()
            }
        }
    }
    
    func gotoPreferredDisplay(_ controller: MenuVC) {
        IMTBiometricAuthentication().security {
            self.loadContent(controller, type: .preferredDisplay)
        }
    }
    
    func goToHorseAndJockeySetting(_ controller: MenuVC) {
        self.loadContent(controller, type: .horseAndJockeySetting())
    }
}

//MARK: Private
extension MenuViewModel {
    
    private func wasRegistered() -> Bool {
        return false
    }
    
    private func presentNavigationContent(rootVC : MenuVC?, controller: BaseViewController) {
        guard let rootVC = rootVC else { return }
        let vc = UINavigationController(rootViewController: controller)
        vc.navigationBar.isHidden = false
        rootVC.presentOverFullScreen(vc, animate: false)
    }
    
    private func getNavigationController(_ controller: BaseViewController ) -> UINavigationController {
        let vc = UINavigationController(rootViewController: controller)
        vc.navigationBar.isHidden = true
        return vc
    }
    
    private func gotoFAQs(_ webVC: IMTWebVC?) {
        guard let webVC = webVC else { return }
        let vc = FAQVC()
        webVC.push(vc)
    }
    
    private func getLink() -> String {
        return Utils.getLinkFaqMail()
    }
    
    private func addObserver() {
        Utils.onObserver(self, selector: #selector(getMe), name: .callAPIMe)
        Utils.onObserver(self, selector: #selector(loadCountNotification), name: .onCountNotification)
    }
}

//MARK: Observer
extension MenuViewModel {
    @objc private func loadCountNotification(_ notification: Notification) {
        let count = Constants.countNotification
        self.onCountNotification.value = count
    }
}

//MARK: API
extension MenuViewModel {
    
    //TODO: Call
    private func callAPI() {
        self.group = DispatchGroup()
        
        Utils.showProgress()
        
        //Me
        group?.enter()
        getMe()
        
        //Notification
        NotificationManager.share().updateBadge()
        
        group?.notify(queue: .main) { [weak self] in
            self?.group = nil
            self?.onFetchComplete()
            
            if !Utils.hasIncommingNotification() {
                Utils.hideProgress()
            }
        }
        
    }
    
    @objc private func getMe(_ notification: NSNotification? = nil) {
        manager.call(endpoint: .getUser, showLoading: false, completion: responseMe)
    }
    
    //TODO: Response
    private func response<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void)) {
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
            group?.leaveOptional()
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
            group?.leave()
        }
    }
    
    private func responseMe(_ response: ResponseMe?, success: Bool) {
        self.response(response) { [weak self] res in
            self?.meDataModel.value = (res.data, false)
            guard let meDataModel = self?.meDataModel.value?.data else { return }
            Utils.postObserver(.reloadMe, object: meDataModel)
        }
    }
    
    private func responseCheckChangePass(_ response: ResponseCheckChangePass?, success: Bool) {
        guard let response = response else { return }
        onCheckChangePass(response.success)
    }
    
    private func responseCheckChangeEmail(_ response: ResponseCheckChangeEmail?, success: Bool) {
        guard let response = response else { return }
        onCheckChangeEmail(response.success)
    }
    
}

extension MenuViewModel: IMTWebVCDelete {
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url?.absoluteString
        if(url == TransactionLink.faqMailExtend.rawValue) {
            countRedirectFaqMail += 1
        }
        
        //TODO: Only back menu when close popup
        if(countRedirectFaqMail == 2) {
            onCloseInquiries.value = true
            self.countRedirectFaqMail = 0
            onCloseInquiries.updateNoBind(false)
        }
        
        decisionHandler(.allow)
    }
    
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, clearHistory currentURL: String) -> Bool {
        let isOrignal = orginalUrl == Utils.getLinkFaqMail()
        let isCurrent = currentURL == TransactionLink.faqMailExtend.rawValue
        let isClearHistory = isOrignal && isCurrent
        
        return isClearHistory
    }
}

//MARK: Private
extension MenuViewModel: ContentFrameLayout {
    func getContentLayoutFactory(type: MenuContentType, controller: MenuVC, bundle: [MenuBundleKey: Any?]?) -> BaseViewController? {
        controller.onEnableParentScroll(true)
        
        var contentVC: BaseViewController?
        
        switch type {
        case .main:
            currentContent = contentView
            break
        case .personal:
            let form = meDataModel.value?.data?.toForm()
            let confirmVC = ConfirmUpdateUserVC(style: .update, form: form, inputScreen: .menu)
            
            confirmVC.onGotoUpdatePersonInfo = { [weak self] flagBundle in
                let bundle: [MenuBundleKey: Any?] = [.updatePersonalInfo: flagBundle]
                self?.loadContent(controller, type: .updatePersonalInfo, bundle: bundle)
            }
            
            contentVC = confirmVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .updatePersonalInfo:
            guard let flagBundle = bundle?[.updatePersonalInfo] as? [String: Any] else { return nil }
            let vc = UpdatePersonalInfoVC(bundle: flagBundle, style: .update, inputScreen: .menu)
            
            vc.onDismiss = { [weak self] in
                controller.hidePopupLinkage()
                self?.loadContent(controller, type: .main)
            }
            
            contentVC = vc
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .emailAddressConfirm:
            guard let meDataModel = meDataModel.value?.data else { return nil }
            let emailConfirm = EnterChangeEmailVC(email: meDataModel.email.decrypt(), inputScreen: .menu)
            
            emailConfirm.onGotoMailChange = { [weak self] flagBundle in
                let bundle: [MenuBundleKey: Any?] = [.oldAccount: flagBundle]
                self?.loadContent(controller, type: .emailAddressChange, bundle: bundle)
            }
            
            contentVC = emailConfirm
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .emailAddressChange:
            guard let flagBundle = bundle?[.oldAccount] as? [String: Any] else { return nil }
            guard let email = flagBundle["email"] as? String else { return nil }
            guard let password = flagBundle["password"] as? String else { return nil }
            
            let vc = MailVerificationVC(style: .changeEmail, oldEmail: email, password: password, inputScreen: .menu)
            
            vc.onResultUpdateEmail = { [weak self] dictBundle in
                let result = (dictBundle[.result] as? Bool) ?? false
                
                if(result) {
                    let newEmail = dictBundle[.email] as? String ?? ""
                    let password = dictBundle[.password] as? String ?? ""
                    
                    let flagBundle: [MenuBundleKey: Any?] = [.email: newEmail, .password: password]
                    self?.loadContent(controller, type: .updateEmailSuccess, bundle: flagBundle)
                } else {
                    let message = (dictBundle[.errorMessage] as? String) ?? ""
                    let flagBundle: [MenuBundleKey: Any?] = [.message: message]
                    self?.loadContent(controller, type: .updateEmailFailure, bundle: flagBundle)
                }
            }
            
            contentVC = vc
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .updateEmailSuccess:
            guard let email = bundle?[.email] as? String else { return nil }
            guard let password = bundle?[.password] as? String else { return nil }
            
            contentVC = ResultUpdateEmailSuccessVC(newEmail: email, password: password)
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .updateEmailFailure:
            let message = (bundle?[.message] as? String) ?? ""
            let vc = ResultUpdateEmailFailureVC(message: message)
            
            vc.onDismiss = { [weak self] in
                self?.back(controller, times: 1)
            }
            
            contentVC = vc
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .changePassword:
            guard let meDataModel = meDataModel.value?.data else { return nil }
            let changePasswordVC  = ChangePasswordVC(email: meDataModel.email.decrypt(), userId: meDataModel.userId, pushScreen: .menu)
            
            changePasswordVC.onSuccess = { [weak self] in
                self?.loadContent(controller, type: .main)
            }
            
            changePasswordVC.onGotoSendOtpToEmail = { [weak self]  in
                self?.loadContent(controller, type: .sendOtpToEmail(stype: .sendCodeForgotPassword))
            }
            
            contentVC = changePasswordVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .resetPassword:
            guard let flagBundle = bundle?[.resetPassword] as? [String: Any] else { return nil }
            
            let passwordResetVC = PasswordResetVC(bundle: flagBundle, inputScreen: .menu)
            
            passwordResetVC.onSuccess = { [weak self]  in
                self?.loadContent(controller, type: .main)
            }
            
            contentVC = passwordResetVC
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .confirmOtp(let style):
            guard let flagBundle = bundle?[.confirmOtp] as? [ConfirmOTPBundleKey: Any] else { return nil }
            
            let confirmOtpVC = ConfirmOTPVC(style: style, bundle: flagBundle, inputScreen: .menu)
            
            confirmOtpVC.onSuccess = { [weak self] in
                self?.loadContent(controller, type: .changePassword)
            }
            
            confirmOtpVC.onGotoResetPassword = { [weak self] flagBundle in
                let bundle: [MenuBundleKey: Any?] = [.resetPassword: flagBundle]
                self?.loadContent(controller, type: .resetPassword , bundle: bundle)
            }
            
            contentVC = confirmOtpVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .sendOtpToEmail(let style):
            guard let meDataModel = meDataModel.value?.data else { return nil }
            guard let style = style else { return nil }
            
            let mailVerificationVC = MailVerificationVC(style: style, oldEmail: meDataModel.email.decrypt(), inputScreen: .menu)
            
            mailVerificationVC.onBack = { [weak self] in
                self?.back(controller)
            }
            
            mailVerificationVC.onGotoConfirmOtp = { [weak self] flagBundle, style in
                let bundle: [MenuBundleKey: Any?] = [.confirmOtp: flagBundle]
                self?.loadContent(controller, type: .confirmOtp(stype: style), bundle: bundle)
            }
            
            contentVC = mailVerificationVC
            self.prepareMoveContent(child: contentVC!, parent: controller)
        case .settingNotification:
            let settingNotificationVC = SettingsNotificationVC()
            
            settingNotificationVC.onSuccess = { [weak self] in
                self?.back(controller)
            }
            
            contentVC = settingNotificationVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .subcriber:
            let exist = UserManager.share().checkExistIpat()
            if(!exist) {
                let votingOnlineVC = VotingOnlineVC(type: .ipatOne, original: true, isEdit: false, inputScreen: .menu)
                
                votingOnlineVC.onSuccess = { [weak self] in
                    self?.back(controller)
                    self?.loadContent(controller, type: .subcriber)
                }
                
                contentVC = votingOnlineVC
            } else {
                let listVotingOnlineVC = ListVotingOnlineVC(.menu)
                listVotingOnlineVC.onGotoUpdateIPat = { [weak self] type in
                    let bundle: [MenuBundleKey: Any] = [.votingOnlineType: type]
                    self?.loadContent(controller, type: .updateIpat, bundle: bundle)
                }
                
                listVotingOnlineVC.onGotoRegisterIPat = { [weak self] in
                    self?.loadContent(controller, type: .registerIpat)
                }
                
                contentVC = listVotingOnlineVC
            }
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .updateIpat:
            guard let type = bundle?[.votingOnlineType] as? VotingOnlineType else { return nil }
            let votingOnlineVC = VotingOnlineVC(type: type, inputScreen: .menu)
            
            votingOnlineVC.onSuccess = { [weak self] in
                let exist = UserManager.share().checkExistIpat()
                if(exist) {
                    self?.back(controller)
                } else {
                    self?.loadContent(controller, type: .main)
                }
            }
            
            contentVC = votingOnlineVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
        case .registerIpat:
            let type: VotingOnlineType = UserManager.share().checkExistIpat1() ? .ipatTwo : .ipatOne
            let votingOnlineVC = VotingOnlineVC(type: type, original: false, isEdit: false, inputScreen: .menu)
            
            votingOnlineVC.onSuccess = { [weak self] in
                self?.back(controller)
            }
            
            contentVC = votingOnlineVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
        case .questions:
            contentVC = ListQuestionsVC()
            self.prepareMoveContent(child: contentVC!, parent: controller)
        case .notification:
            let notificationVC = ListNotificationVC()
            
            notificationVC.onDismiss = { [weak self] in
                self?.back(controller)
            }
            
            notificationVC.onGotoDetail = { [weak self] flagBundle in
                let bundle: [MenuBundleKey: Any] = [.detailNotification: flagBundle]
                self?.loadContent(controller, type: .detailNotification, bundle: bundle)
            }
            
            contentVC = notificationVC
            self.prepareMoveContent(child: contentVC!, parent: controller)
        case .detailNotification:
            guard let flagBundle = bundle?[.detailNotification] as? [NotificationBundleKey : Any] else { return nil }
            let vc = DetailNotificationVC(bundle: flagBundle)
            
            vc.onTransition = { [weak self] url in
                self?.loadContent(controller, type: .webView(url))
            }
            
            contentVC = vc
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            
            if let url = bundle?[.detailNotificationURL] as? String {
                vc.onViewDidAppear = {
                    self.loadContent(controller, type: .webView(url.toValidURL()))
                }
            } else {
                Utils.clearDataIncommingNotification()
            }
            
            break
        case .deleteAccount:
            controller.onEnableParentScroll(false)
            
            let deleteAccountVC = DeleteAccountVC()
            
            deleteAccountVC.onDismiss = { [weak self] in
                self?.back(controller, times: 1)
            }
                        
            contentVC = deleteAccountVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            
            break

        case .biometricManagement:
            let vc = BiometricManagementVC()
            
            vc.onDisableBiometric = {
                let disableBiometricVC = BiometricWarningSwitchVC()
                
                disableBiometricVC.onDisableBiometric = {
                    vc.didDisableBitometric()
                }
                
                disableBiometricVC.onDismiss = {
                    vc.didResetBiometric()
                }
                
                vc.presentOverFullScreen(disableBiometricVC)
            }
            
            contentVC = vc
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            
            break
        case .umacaSmartCollaboration:
            let exist = UserManager.share().checkExistUMACA()
            if(!exist) {
                let umacaVC = UMACATicketVC(original: true, isEdit: false, inputScreen: .menu)
                
                umacaVC.onSuccess = { [weak self] in
                    self?.back(controller)
                    self?.loadContent(controller, type: .umacaSmartCollaboration)
                }
                
                contentVC = umacaVC
            } else {
                let listUMACATicketVC = ListUMACATicketVC(.menu)
                
                listUMACATicketVC.onGotoUpdateUMACATicket = { [weak self] in
                    self?.loadContent(controller, type: .updateUMACATicket)
                }
                
                listUMACATicketVC.onGotoRegisterUMACA = { [weak self] in
                    self?.loadContent(controller, type: .registerUMACATicket)
                }
                
                contentVC = listUMACATicketVC
            }
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .updateUMACATicket:
            let umacaVC = UMACATicketVC(inputScreen: .menu)
            
            umacaVC.onSuccess = { [weak self] in
                let exist = UserManager.share().checkExistUMACA()
                if(exist) {
                    self?.back(controller)
                } else {
                    self?.loadContent(controller, type: .main)
                }
            }
            
            contentVC = umacaVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .registerUMACATicket:
            let umacaVC = UMACATicketVC(original: false, isEdit: false, inputScreen: .menu)
            
            umacaVC.onSuccess = { [weak self] in
                self?.back(controller)
            }
            
            contentVC = umacaVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .preferredDisplay:
            let preferredDisplayViewController = PreferredDisplayVC()
            
            preferredDisplayViewController.onDismiss = { [weak self] in
                self?.back(controller, refresh: false)
            }
            
            contentVC = preferredDisplayViewController
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .horseAndJockeySetting(let selectedSegment):
            let listHorsesAndJockeysVC = ListHorsesAndJockeysVC()
            listHorsesAndJockeysVC.viewModel = ListHorsesAndJockeysViewModel(selectedSegment: selectedSegment ?? .recommendedHorses)
            
            listHorsesAndJockeysVC.onGotoSearch = { [weak self] segment in
                switch segment {
                case .recommendedHorses:
                    self?.loadContent(controller, type: .raceHorseSearch)
                case .favoriteJockeys:
                    self?.loadContent(controller, type: .jockeySearch)
                }
            }
            
            listHorsesAndJockeysVC.onGotoWebView = { [weak self] link in
                self?.loadContent(controller, type: .webView(link, post: true))
            }
            
            listHorsesAndJockeysVC.onGotoRaceHorseRanking = { [weak self] in
                self?.loadContent(controller, type: .topFavorite)
            }
            
            contentVC = listHorsesAndJockeysVC
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .raceHorseSearch:
            let raceHorseSearchViewController = RaceHorseSearchVC()
            raceHorseSearchViewController.viewModel = RaceHorseSearchViewModel()
            raceHorseSearchViewController.onGotoResultSearch = { [weak self] searchValue, items in
                let bundle: [MenuBundleKey: Any] = [.preferenceFeature: items]
                self?.loadContent(controller, type: .favoriteSearchResult(type: .recommended, text: searchValue), bundle: bundle)
            }
            contentVC = raceHorseSearchViewController
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .jockeySearch:
            let jockeySearchViewController = JockeySearchVC()
            jockeySearchViewController.viewModel = JockeySearchViewModel()
            jockeySearchViewController.onGotoResultSearch = { [weak self] type in
                self?.loadContent(controller, type: .jockeyResultSearch(type: type))
            }
            contentVC = jockeySearchViewController
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .topFavorite:
            let topFavoriteViewController = TopFavoriteVC()
            
            contentVC = topFavoriteViewController
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .favoriteSearchResult(let type, let text):
            guard let items = bundle?[.preferenceFeature] as? [PreferenceFeature] else { return nil }
            let listFavoriteSearchResultViewController = ListFavoriteSearchResultVC(type: type, items: items, searchValue: text)
            listFavoriteSearchResultViewController.onGotoWebView = { [weak self] link in
                self?.loadContent(controller, type: .webView(link, post: true))
            }
            listFavoriteSearchResultViewController.onGotoListHorseAndJockey = { [weak self] _ in
                self?.back(controller, times: 2)
            }
            contentVC = listFavoriteSearchResultViewController
            
            self.prepareMoveContent(child: contentVC!, parent: controller)
        case .jockeyResultSearch(let type):
            let jockeyResultSearch = ListJockeyResultSearchVC()
            jockeyResultSearch.viewModel = ListJockeySearchResultViewModel(type: type)
            jockeyResultSearch.onGotoWebView = { [weak self] link in
                self?.loadContent(controller, type: .webView(link, post: true))
            }
            jockeyResultSearch.onGotoListHorseAndJockey = { [weak self] _ in
                self?.back(controller, times: 2)
            }
            contentVC = jockeyResultSearch
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        case .webView(let link, let userAgent, let convertHTML, let post):
            //TODO: Refresh value of flag
            countRedirectFaqMail = 0
            
            let webViewController = IMTWebVC(string: link, post: post, useNavigation: false, convertHTML: convertHTML, delegate: self, userAgent: userAgent, tryReload: false)
            
            webViewController.onPushFavorite = {
                self.loadContent(controller, type: .topFavorite)
            }
            
            webViewController.onPushRaceHorseAndJockeyList = { selectedSegment in
                self.loadContent(controller, type: .horseAndJockeySetting(selectedSegment: selectedSegment))
            }
            contentVC = webViewController
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        default:
            break
        }
        
        return contentVC
    }
    
    func getContainer() -> UIView? {
        return contentView
    }
    
    func getMainView() -> UIView {
        return mainView
    }
    
    func updateContent(view: UIView) {
        self.currentContent = view
    }
    
    func pushQueue(type: MenuContentType, controller: BaseViewController?) {
        let item = (type: type, controller: controller)
        contentQueue.append(item)
    }
    
    func removeLastQueue() {
        self.contentQueue.removeLast()
    }
    
    func removeAllQueue() {
        self.contentQueue.removeAll()
    }
    
    func getMainType() -> MenuContentType {
        return .main
    }
    
    func didChangeType(type: MenuContentType) {
        onChangeContent.value = type
    }
    
    func getHomeView() -> UIView? {
        return homeContentView
    }
    
    func getNumberRemainPage() -> Int {
        return self.contentQueue.count
    }
}
