//
//  HomeViewModel.swift
//  IMT-iOS
//
//  Created by dev on 07/03/2023.
//

import UIKit
import KeychainSwift
import MaterialComponents
import SWXMLHash
import SwiftyJSON
import CryptoKit
import WebKit
import Firebase
import AppsFlyerLib

enum HomeContentType: Equatable {
    case home
    case memorial
    case listMemorial
    case previewTicket
    case resultTicket
    case beginnerGuide
    case beginnerGuideTrans
    case subcriber
    case updateIpat
    case registerIpat
    case umacaSmartCollaboration
    case updateUMACATicket
    case registerUMACATicket
    case infoMenu
    case topFavorite
    case raceHorseAndJockeyList(selectedSegment: ListHorsesAndJockeysSegment?)
    case horseAndJockeySetting
    case raceHorseSearch
    case jockeySearch
    case favoriteSearchResult(type: ListFavoriteSearchResultType, text: String)
    case jockeySearchResult(type: Abbreviations)
    case webView(_ link: String = "", post: Bool = false, swipeable: Bool = true)
}

class HomeViewModel: BaseViewModel, SubscribePreferenceTopic {
    var topics: ObservableObject<[TopicModel]> = ObservableObject<[TopicModel]>([])
    var oversea: ObservableObject<[TopicModel]> = ObservableObject<[TopicModel]>([])
    var races: ObservableObject<IMTceData> = ObservableObject<IMTceData>(([RaceInfoModel](), [String]()))
    var news: ObservableObject<[NewModel]> = ObservableObject<[NewModel]>([])
    var services: ObservableObject<[Service]> = ObservableObject<[Service]>([.soku])
    var serviceAppcp: ObservableObject<[Service]> = ObservableObject<[Service]>([.beginerGuide])
    var ugrentNotice: ObservableObject<(data: WarningViewConfiguration?, isIntial: Bool)> = ObservableObject<(data: WarningViewConfiguration?, isIntial: Bool)>((nil, true))
    var hasTopTopics: ObservableObject<Bool> = ObservableObject<Bool>(true)
    var onShowGuide: ObservableObject<Bool> = ObservableObject<Bool>(false)
    var onChangeContent: ObservableObject<HomeContentType> = ObservableObject<HomeContentType>(.home)
    var onFetchComplete: JVoid = {}
    
    private var groupSysEnv: DispatchGroup?
    private var group: DispatchGroup?
    private var groupRace: DispatchGroup?
    
    private var flagRaces: [RaceInfoModel] = []
    private var flagHolidays: [String] = []
    private var flagSubscribed: Bool = false
    private var contentView: UIView!
    private var mainView: UIView!
    
    var currentContent: UIView?
    var previousContent: UIView?
    var contentQueue: [(type: HomeContentType, controller: BaseViewController?)] = []
    
    var numRequest: Int = 0
    var maximumNumberOfNews = 0
    
    func setup(contentView: UIView, mainView: UIView) {
        self.contentView = contentView
        self.mainView = mainView
        showGuideIfNeed()
        self.callAPI(true)
        self.addObserver()
        self.onReceivedFCMToken()
        
        let temp = sum(a: 5, b: 6)
        let result = temp()
        
        sum1(result: temp)
    }
    
    func sum(a: Int, b: Int) -> (() -> Int) {
        return {
            return a + b
        }
    }
    
    func sum1(result: (() -> Int)) {
        print("######: \(result())")
    }
    
    override func refreshData() {
        //        clearData()
        callAPI()
    }
    
    func gotoMyPerson(_ controller: HomeVC?) {
        guard let controller = controller else { return }
        let vc = MenuVC()
        controller.presentOverFullScreen(vc)
    }
    
    func gotoNotification(_ controller: HomeVC?) {
        guard let controller = controller else { return }
        let notificationVC = ListNotificationVC()
        
        let vc = UINavigationController(rootViewController: notificationVC)
        controller.presentOverFullScreen(vc)
    }
    
    func transactionMenuWidget(_ controller: HomeVC?, index: Int) {
        let item = MenuWidget.allCases[index]
        guard let link = item.link() else { return }
        switch item {
        case .votingHistory:
            transitionVote()
            break
        case .club:
            transitionUseSkipLogin()
            break
        }
        
        func transitionUseSkipLogin() {
            if(link.useWebView) {
                if (UserManager.share().legalAge()) {
                    self.loadContent(controller, type: .webView(link.url), bundle: nil)
                } else {
                    controller?.showWarningLegalAge()
                }
            } else {
                controller?.transitionFromSafari(link.url)
            }
        }
        
        func transitionDontUseSkipLogin() {
            controller?.transition(info: link)
        }
        
        func transitionVote() {
            let biometric = IMTBiometricAuthentication()
            biometric.security {
                Utils.logActionClick(.internetVoting)
                if(UserManager.share().legalAge()) {
                    if(UserManager.share().showLinkageIpat()) {
                        controller?.showPopupLinkage()
                    } else {
                        self.loadContent(controller, type: .webView(link.url), bundle: nil)
                    }
                } else {
                    controller?.showWarningLegalAge()
                }
            }
        }
        
    }
    
    func transactionServiceWidget(_ controller: HomeVC?, index: Int) {
        let item = ServiceWidget.allCases[index]
        item.log()
        
        switch item {
        case .all:
            self.loadContent(controller, type: .infoMenu)
            break
        case .thisWeekRaceHorseSearch:
            guard let link = item.link(), Constants.allowSearchHorsesRunningThisWeek else { return }
            gotoWeb(link, post: true)
            break
        case .result, .jockeyDirectory, .refundList, .win5, .specialRace:
            guard let link = item.link() else { return }
            gotoWeb(link, post: true)
            break
        default:
            guard let link = item.link() else { return }
            gotoWeb(link)
            break
        }
        
        func gotoWeb(_ link: JMTrans, post: Bool = false) {
            if (link.useWebView) {
                loadContent(controller, type: .webView(link.url, post: post))
            } else {
                controller?.transition(info: link)
            }
        }
    }
    
    func transactionRecommendedFunctionsMenuWidget(_ controller: HomeVC?, index: Int) {
        let item = RecommendedFunctionsMenuWidget.allCases[index]
        item.log()
        
        switch item {
        case .pushHorseFavoriteJockey:
            self.loadContent(controller, type: .horseAndJockeySetting)
            break
        case .memorial:
            if (UserManager.share().legalAge()) {
                self.loadContent(controller, type: .memorial)
            } else {
                controller?.showWarningLegalAge()
            }
            break
        }
    }
    
    func transactionHorseInfoLink(_ controller: HomeVC?, index: Int) {
        guard let controller = controller else { return }
        let item = HorseRaceInfoLinkWidget.allCases[index]
        guard let link = item.link() else { return }
        if link.useWebView {
            loadContent(controller, type: .webView(link.url))
        } else {
            controller.transition(info: link)
        }
    }
    
    func transactionService(_ controller: HomeVC?, service: Service) {
        guard let controller = controller else { return }
        service.log()
        
        switch service {
        case .order:
            break
        case .club:
            controller.transition(link: .club)
            break
        case .categoryKeiba:
            controller.transition(link: .keibaCatalog)
            break
        case .guide:
            controller.transition(link: .racecourseInformation)
            break
        case .requiredVote:
            controller.transition(link: .votingNote)
            break
        case .soku:
            controller.transitionFromSafari(TransactionLink.soKanyu.rawValue)
            break
        case .youtube:
            break
        case .beginerGuide:
            loadContent(controller, type: .beginnerGuide)
        }
    }
    
    func transactionAt(_ controller: HomeVC?, link: TransactionLink, post: Bool = false) {
        let url = link.rawValue
        transactionAt(controller, url: url, post: post)
    }
    
    func transactionAt(_ controller: HomeVC?, url: String, post: Bool = false, allowSwipe: Bool = true) {
        guard let controller = controller else { return }
        self.loadContent(controller, type: .webView(url, post: post, swipeable: allowSwipe))
    }
    
    func animateVoting(_ controller: HomeVC?) {
        if(onShowGuide.value == true) {
            controller?.onRunAnimateVote()
        } else {
            controller?.onStopAnimateVote()
        }
    }
    
    func disableServiceWidget(_ index: Int) -> Bool {
        let item = ServiceWidget.allCases[index]
        if(item == .thisWeekRaceHorseSearch) {
            return !Constants.allowSearchHorsesRunningThisWeek
        }
        
        return false
    }
    
    func pushScreenFromNotification(_ controller: HomeVC, data: FIRNotificationModel) {
        guard let type = data.getType() else { return }
        
        switch type {
        case .automatic:
            onChangeContent.value = .webView() //tam
            loadWhenAutomatic()
            Utils.clearDataIncommingNotification()
            break
        case .manual:
            return
        }
        
        func loadWhenAutomatic() {
            let category = data.category
            let categoriesDestinationPost = [50, 51, 52, 53, 54, 61, 64]
            let categoriesDestinationGet = [62, 63]
            
            if categoriesDestinationPost.contains(category) {
                if let url = data.url {
                    loadContent(controller, type:.webView(url, post: true))
                }
            } else if(categoriesDestinationGet.contains(category)) {
                if let url = data.url {
                    loadContent(controller, type:.webView(url, post: false))
                }
            } else {
                controller.actionWeather("")
            }
        }
    }
    
    func reloadHomeContentIfNeed(_ controller: HomeVC, _ isFirstLoad: Bool) {
        let withInTabHome = onChangeContent.value != .home && !tabChange
        let withOutTabHome = onChangeContent.value == .home && tabChange
        
        if(isFirstLoad || withInTabHome || withOutTabHome) {
            loadContent(controller, type: .home)
        }
    }
    
    func racecourseWindsTools(_ controller: HomeVC, tag: Int) {
        guard let course = RacecourseWindsTools(rawValue: tag) else { return }
        transition()
        
        /*-----------------------------------------------------------------------*/
        func transition() {
            switch course {
            case .umaca:
                transitionUMACASmartCollaboration()
                break
            default:
                transitionDefault()
                break
            }
            
            course.log()
        }
        
        func transitionDefault() {
            guard let trans = course.link() else { return }
            let useWebView = trans.useWebView
            let url = trans.url
            
            if useWebView {
                transactionAt(controller, url: url)
            } else {
                controller.transition(info: trans)
            }
        }
        
        func transitionUMACASmartCollaboration() {
            IMTBiometricAuthentication().security {
                if (UserManager.share().legalAge()) {
                    if let _ = UserManager.share().getCurrentUMACASkipLogin() {
                        self.skipLogin()
                    } else {
                        self.loadContent(controller, type: .umacaSmartCollaboration)
                    }
                } else {
                    controller.showWarningLegalAge()
                }
            }
        }
        /*-----------------------------------------------------------------------*/
    }
    
    func shareSNSHome(_ controller: HomeVC, tag: Int) {
        guard let course = ShareSNSHome(rawValue: tag) else { return }
        guard let trans = course.link() else { return }
        controller.transition(info: trans)
    }
}

//MARK: API
extension HomeViewModel {
    
    private func callAPI(_ first: Bool = false) {
        groupSysEnv = DispatchGroup()
        group = DispatchGroup()
        groupRace = DispatchGroup()
        
        Utils.showProgress()
        
        //TODO: Push token
        //        let tokenInfo = UserManager.share().getToken()
        
        //        if !tokenInfo.isUserLogin {
        //            if let token = tokenInfo.token, token != Constants.System.fcmToken {
        //                manager.call(endpoint: .dropFCMToken(token), showLoading: false, completion: responseDropFCM)
        //            }
        //            
        //            manager.call(endpoint: .registFCMToken, showLoading: false, completion: responseRegistFCM)
        //        }
        
        //TODO: Me
        if(!UserManager.share().reLogin) {
            group?.enter()
            manager.call(endpoint: .getUser, showLoading: false, completion: responseMe)
        } else {
            
            //TODO: Subcrise user topic
            if(first) {
                if(UserManager.share().getRoleUser() == .test) {
                    group?.enter()
                    Messaging.messaging().subscribe(toTopic: SettingsNotificationItem.test.topic()) { [weak self] error in
                        self?.group?.leaveOptional()
                    }
                }
            }
        }
        
        if(first) {
            //TODO: Push customerUserId on third AppFlyers
            pushCUIDOnAppFlyer()
        }
        
        //TODO: UrgentNotices
        self.groupSysEnv?.enter()
        self.manager.call(endpoint: .sysEnv, showLoading: false, completion: self.responseSysEnv)
        
        groupSysEnv?.notify(queue: .global(), execute: { [weak self] in
            guard let weakSelf = self else { return }
            
            //TODO: Topics
            weakSelf.group?.enter()
            weakSelf.manager.call(endpoint: .topics(), showLoading: false, completion: weakSelf.responseTopics)
            
            //TODO: Topic oversea
            weakSelf.group?.enter()
            weakSelf.manager.call(endpoint: .oversea(), showLoading: false, completion: weakSelf.responseOversea)
            
            //TODO: Current
            weakSelf.group?.enter()
            weakSelf.groupRace?.enter()
            weakSelf.manager.call(endpoint: .currentRace(), showLoading: false, completion: weakSelf.responseCurrentRace)
            
            weakSelf.groupRace?.enter()
            weakSelf.manager.call(endpoint: .holiday, showLoading: false, completion: weakSelf.responseHoliday)
            
            //TODO: News
            weakSelf.group?.enter()
            weakSelf.manager.callXML(endpoint: .news, showLoading: false, completion: weakSelf.responseNews)
            
            //TODO: GetLatestEventDate
            weakSelf.group?.enter()
            weakSelf.manager.call(endpoint: .getLatestEventDate, showLoading: false, showError: false, completion: weakSelf.responseLatestEventDate)
            
            weakSelf.groupRace?.notify(queue: .main) { [weak self] in
                guard let flagRaces = self?.flagRaces,
                      let flagHolidays = self?.flagHolidays else { return }
                self?.races.value = IMTceData(flagRaces, flagHolidays)
                self?.groupRace = nil
                self?.group?.leaveOptional()
            }
            
            weakSelf.group?.notify(queue: .main) { [weak self] in
                if !Utils.hasIncommingNotification() {
                    Utils.hideProgress()
                }
                self?.group = nil
                self?.hasTopTopics.value = self?.noEmptyDataKindOfTopicView()
                self?.onFetchComplete()
            }
        })
    }
    
    private func responseCurrentRace(_ data: [RaceInfoModel]?, success: Bool) {
        if let races = data {
            self.flagRaces = races
            Constants.allowSearchHorsesRunningThisWeek = !races.isEmpty
        } else {
            Constants.allowSearchHorsesRunningThisWeek = true
        }
        
        self.groupRace?.leaveOptional()
    }
    
    private func responseHoliday(_ data: JSON?, success: Bool) {
        if let dict = data?.object as? NSDictionary, let days = dict.allKeys as? [String]{
            self.flagHolidays = days
        }
        
        self.groupRace?.leaveOptional()
    }
    
    private func responseNews(_ response: XMLIndexer?, success: Bool) {
        guard let allItems = response?["rdf:RDF"]["item"].all else { return }
        self.news.value = getNewsTop(allItems, top: maximumNumberOfNews)
        self.group?.leaveOptional()
    }
    
    private func responseTopics(_ data: [TopicModel]?, success: Bool) {
        self.topics.value = data
        self.group?.leaveOptional()
    }
    
    private func response<R: BaseResponse>(_ response: R?, showError: Bool = true, successCompletion:@escaping((R) -> Void), failureCompletion:@escaping(JVoid) = {}) {
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message, showError else { return }
            showMessageError(message: message)
            failureCompletion()
        }
    }
    
    private func responseMe(_ response: ResponseMe?, success: Bool) {
        self.group?.leaveOptional()
        self.response(response) { [weak self] res in
            UserManager.share().user = res.data
            
            //TODO: Subcrise user topic
            if(UserManager.share().getRoleUser() == .test) {
                self?.group?.enter()
                Messaging.messaging().subscribe(toTopic: SettingsNotificationItem.test.topic()) { [weak self] error in
                    self?.group?.leaveOptional()
                }
            }
        }
    }
    
    private func responseSysEnv(_ response: ResponseSysEnv?, success: Bool) {
        self.ugrentNotice.value = (response?.convertToWaringViewConfiguration(), false)
        self.maximumNumberOfNews = response?.getValueFromAysy01(key: .maximumNumberOfNews)?.integer() ?? 0
        self.groupSysEnv?.leaveOptional()
    }
    
    private func responseOversea(_ data: [TopicModel]?, success: Bool) {
        self.oversea.value = data
        self.group?.leaveOptional()
    }
    
    private func responseLatestEventDate(_ response: ReponseLatestEventDate?, success: Bool) {
        self.response(response, showError: false, successCompletion: { [weak self] res in
            Constants.numberCnameWin5 = response?.data?.latestEventDate ?? ""
            self?.group?.leaveOptional()
        })
    }
    
    private func skipLogin() {
        if let _ = UserManager.share().getCurrentUMACASkipLogin() {
            Utils.showProgress()
            
            loadUMACA()
        } else {
            self.showMessageError(message: IMTErrorMessage.cantSkipLoggin.rawValue)
        }
    }
    
    private func responseRegistFCM(_ response: JSON?, success: Bool) {
        
        UserManager.share().deleteUtoken()
        if let success = response?["success"].boolValue {
            if(!success) {
                if let message = response?["message"].stringValue {
                    print("ERROR API REGISTER FCM: \(message)")
                }
            } else {
                UserManager.share().saveUtoken()
            }
            return
        }
        
        print("ERROR API REGISTER FCM")
    }
    
    private func responseDropFCM(_ response: JSON?, success: Bool) {
        if let success = response?["success"].boolValue {
            if(!success) {
                if let message = response?["message"].stringValue {
                    print("ERROR API DROP FCM: \(message)")
                }
            }
            return
        }
        
        print("ERROR API DROP FCM")
    }
}

extension HomeViewModel: ContentFrameLayout {
    
    func getContentLayoutFactory(type: HomeContentType, controller: HomeVC, bundle: [HomeBundleKey : Any]?) -> BaseViewController? {
        
        switch type {
        case .home:
            currentContent = controller.svMainContent!
            return nil
        case .memorial:
            let vc = MemorialVC(bundle: bundle)
            vc.onGotoListMemorial = { [weak self] in
                self?.loadContent(controller, type:.listMemorial)
            }
            
            vc.onGotoResultRegisterTicket = { [weak self] qrInfo in
                let bundle: [HomeBundleKey: Any] = [.object: qrInfo]
                self?.loadContent(controller, type: .resultTicket, bundle: bundle)
            }
            
            prepareMoveContent(child: vc, parent: controller)
            return vc
            
        case .listMemorial:
            let vc = ListMemorialVC(bundle: bundle)
            vc.onGotoPreviewTicket = { [weak self] listQRModel, index in
                let data: [String: Any] = ["list": listQRModel, "index": index]
                let bundle: [HomeBundleKey: Any] = [.listQRModel: data]
                self?.loadContent(controller, type: .previewTicket, bundle: bundle)
            }
            
            prepareMoveContent(child: vc, parent: controller)
            return vc
        case .previewTicket:
            let vc = PreviewTicketVC(bundle: bundle)
            
            vc.onDissmiss = { [weak self] in
                self?.back(controller)
            }
            
            prepareMoveContent(child: vc, parent: controller)
            
            return vc
        case .resultTicket:
            let vc = ResultTicketVC(bundle: bundle)
            
            vc.onGotoListMemorial = { [weak self] in
                self?.back(controller)
                self?.loadContent(controller, type: .listMemorial)
            }
            
            vc.onGotoScanQR = { [weak self] in
                let bundle: [HomeBundleKey: Any] = [.openScanQR: true]
                self?.loadContent(controller, type: .memorial, bundle: bundle)
            }
            
            prepareMoveContent(child: vc, parent: controller)
            return vc
        case .beginnerGuide:
            let vc = BeginnerGuideVC()
            
            vc.onTransition = { [weak self] trans in
                let bundle: [HomeBundleKey: Any] = [.transInfo: trans]
                self?.loadContent(controller, type: .beginnerGuideTrans, bundle: bundle)
            }
            
            prepareMoveContent(child: vc, parent: controller)
            return vc
        case .beginnerGuideTrans:
            guard let trans = bundle?[.transInfo] as? JMTransAgent else { return nil }
            let vc = IMTWebVC(string: trans.url, useNavigation: false, userAgent: trans.userAgent)
            
            if (trans.url == BeginnerGuide.transInfo(.keibaCatalog)().url ) {
                vc.isCheckBack = true
            }
            
            prepareMoveContent(child: vc, parent: controller)
            return vc
        case .subcriber:
            let exist = UserManager.share().checkExistIpat()
            let vc: BaseViewController!
            
            if(!exist) {
                let votingOnlineVC = VotingOnlineVC(type: .ipatOne, original: true, isEdit: false, inputScreen: .menu)
                
                votingOnlineVC.onSuccess = { [weak self] in
                    self?.back(controller)
                    self?.loadContent(controller, type: .subcriber)
                }
                
                vc = votingOnlineVC
            } else {
                let listVotingOnlineVC = ListVotingOnlineVC(.menu)
                listVotingOnlineVC.onGotoUpdateIPat = { [weak self] type in
                    let bundle: [HomeBundleKey: Any] = [.votingOnlineType: type]
                    self?.loadContent(controller, type: .updateIpat, bundle: bundle)
                }
                
                listVotingOnlineVC.onGotoRegisterIPat = { [weak self] in
                    self?.loadContent(controller, type: .registerIpat)
                }
                
                vc = listVotingOnlineVC
            }
            
            self.prepareMoveContent(child: vc, parent: controller)
            
            return vc
        case .updateIpat:
            guard let type = bundle?[.votingOnlineType] as? VotingOnlineType else { return nil }
            let vc = VotingOnlineVC(type: type, inputScreen: .menu)
            
            vc.onSuccess = { [weak self] in
                let exist = UserManager.share().checkExistIpat()
                if(exist) {
                    self?.back(controller)
                } else {
                    self?.loadContent(controller, type: .home)
                }
            }
            
            self.prepareMoveContent(child: vc, parent: controller)
            return vc
        case .registerIpat:
            let type: VotingOnlineType = UserManager.share().checkExistIpat1() ? .ipatTwo : .ipatOne
            let vc = VotingOnlineVC(type: type, original: false, isEdit: false, inputScreen: .menu)
            
            vc.onSuccess = { [weak self] in
                self?.back(controller)
            }
            
            self.prepareMoveContent(child: vc, parent: controller)
            
            return vc
        case .umacaSmartCollaboration:
            let contentVC: BaseViewController
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
            
            self.prepareMoveContent(child: contentVC, parent: controller)
            return contentVC
        case .updateUMACATicket:
            let umacaVC = UMACATicketVC(inputScreen: .menu)
            
            umacaVC.onSuccess = { [weak self] in
                let exist = UserManager.share().checkExistUMACA()
                if(exist) {
                    self?.back(controller)
                } else {
                    self?.loadContent(controller, type: .home)
                }
            }
            self.prepareMoveContent(child: umacaVC, parent: controller)
            return umacaVC
        case .registerUMACATicket:
            let umacaVC = UMACATicketVC(original: false, isEdit: false, inputScreen: .menu)
            
            umacaVC.onSuccess = { [weak self] in
                self?.back(controller)
            }
            
            self.prepareMoveContent(child: umacaVC, parent: controller)
            return umacaVC
        case .infoMenu:
            let infoMenuViewController = InfoMenuViewController()
            let viewModel = InfoMenuViewModel()
            viewModel.onTransition = { [weak self] item in
                switch item {
                case .horseRacingFirstTimeGuide:
                    self?.loadContent(controller, type: .beginnerGuide)
                    break
                case .whatIsWin5:
                    guard let trans = item.link() else { break }
                    controller.transitionFromSafari(trans.url)
                    break
                case .refundList, .raceHorseSearch, .win5, .resultAndSearch, .jockeyDirectory, .jockeyReading, .trainerDirectory, .trainerReading, .thisWeekRaceHorseSearch, .stallionReading, .specialRace:
                    guard let trans = item.link() else { break }
                    self?.loadContent(controller, type: .webView(trans.url, post: true))
                    break
                default:
                    guard let trans = item.link() else { break }
                    self?.loadContent(controller, type: .webView(trans.url))
                    break
                }
            }
            infoMenuViewController.viewModel = viewModel
            
            
            self.prepareMoveContent(child: infoMenuViewController, parent: controller)
            return infoMenuViewController
            
        case .topFavorite:
            let vc = TopFavoriteVC()
            
            self.prepareMoveContent(child: vc, parent: controller)
            
            return vc
            
        case .raceHorseAndJockeyList(let selectedSegment):
            let raceHorseAndJockeyListVC = ListHorsesAndJockeysVC()
            raceHorseAndJockeyListVC.viewModel = ListHorsesAndJockeysViewModel(selectedSegment: selectedSegment ?? .recommendedHorses)
            
            raceHorseAndJockeyListVC.onGotoSearch = { [weak self] selectedSegment in
                switch selectedSegment {
                case .recommendedHorses:
                    self?.loadContent(controller, type: .raceHorseSearch)
                    break
                case .favoriteJockeys:
                    self?.loadContent(controller, type: .jockeySearch)
                    break
                }
            }
            
            raceHorseAndJockeyListVC.onGotoRaceHorseRanking = { [weak self] in
                self?.loadContent(controller, type: .topFavorite)
            }
            
            raceHorseAndJockeyListVC.onGotoWebView = { [weak self] link in
                self?.loadContent(controller, type: .webView(link, post: true))
            }
            
            self.prepareMoveContent(child: raceHorseAndJockeyListVC, parent: controller)
            return raceHorseAndJockeyListVC
        case .raceHorseSearch:
            let raceHorseSearchViewController = RaceHorseSearchVC()
            raceHorseSearchViewController.viewModel = RaceHorseSearchViewModel()
            
            raceHorseSearchViewController.onGotoResultSearch = { [weak self] searchValue, items in
                let bundle: [HomeBundleKey: Any] = [.preferenceFeature: items]
                self?.loadContent(controller, type: .favoriteSearchResult(type: .recommended, text: searchValue), bundle: bundle)
            }
            
            self.prepareMoveContent(child: raceHorseSearchViewController, parent: controller)
            return raceHorseSearchViewController
        case .jockeySearch:
            let jockeySearchViewController = JockeySearchVC()
            jockeySearchViewController.viewModel = JockeySearchViewModel()
            jockeySearchViewController.onGotoResultSearch = { [weak self] item in
                self?.loadContent(controller, type: .jockeySearchResult(type: item))
            }
            self.prepareMoveContent(child: jockeySearchViewController, parent: controller)
            return jockeySearchViewController
        case .favoriteSearchResult(let type, let text):
            guard let items = bundle?[.preferenceFeature] as? [PreferenceFeature] else { return nil }
            let favoriteSearchResultListViewController = ListFavoriteSearchResultVC(type: type, items: items, searchValue: text)
            
            favoriteSearchResultListViewController.onGotoWebView = { [weak self] link in
                self?.transactionAt(controller, url: link, post: true)
            }
            
            favoriteSearchResultListViewController.onGotoListHorseAndJockey = { [weak self] _ in
                self?.back(controller, times: 2)
            }
            
            self.prepareMoveContent(child: favoriteSearchResultListViewController, parent: controller)
            return favoriteSearchResultListViewController
        case .horseAndJockeySetting:
            let listHorsesAndJockeysVC = ListHorsesAndJockeysVC()
            listHorsesAndJockeysVC.viewModel = ListHorsesAndJockeysViewModel()
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
            
            self.prepareMoveContent(child: listHorsesAndJockeysVC, parent: controller)
            return listHorsesAndJockeysVC
        case .jockeySearchResult(let type):
            let jockeySearchResultVC = ListJockeyResultSearchVC()
            jockeySearchResultVC.viewModel = ListJockeySearchResultViewModel(type: type)
            jockeySearchResultVC.onGotoWebView = { [weak self] link in
                self?.transactionAt(controller, url: link, post: true)
            }
            jockeySearchResultVC.onGotoListHorseAndJockey = { [weak self] _ in
                self?.back(controller, times: 2)
            }
            
            self.prepareMoveContent(child: jockeySearchResultVC, parent: controller)
            return jockeySearchResultVC
        case .webView(let link, let post, _):
            let vc = IMTWebVC(string: link, post: post, useNavigation: false, delegate: self)
            
            if (link == TransactionLink.votingNote.rawValue ) {
                vc.isCheckBack = true
            }
            
            vc.onPushFavorite = {
                self.loadContent(controller, type: .topFavorite)
            }
            
            vc.onPushRaceHorseAndJockeyList = { selectedSegment in
                self.loadContent(controller, type: .raceHorseAndJockeyList(selectedSegment: selectedSegment))
            }
            
            self.prepareMoveContent(child: vc, parent: controller)
            
            return vc
        }
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
    
    func pushQueue(type: HomeContentType, controller: BaseViewController?) {
        let item = (type: type, controller: controller)
        contentQueue.append(item)
    }
    
    func removeLastQueue() {
        self.contentQueue.removeLast()
    }
    
    func removeAllQueue() {
        self.contentQueue.removeAll()
    }
    
    func getMainType() -> HomeContentType {
        return .home
    }
    
    func didChangeType(type: HomeContentType) {
        onChangeContent.value = type
    }
    
    func homeScreen() -> Bool {
        return true
    }
}

extension HomeViewModel: IMTWebVCDelete {
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let urlRequest = navigationAction.request.url?.absoluteString ?? ""
        let transactionLink = TransactionLink(rawValue: urlRequest)
        
        if let transactionLink = transactionLink,
           transactionLink == .worldracing || transactionLink == .raceCalendar {
            decisionHandler(.cancel)
            let info: JMTrans
            info = (url: transactionLink.rawValue, useWebView: false)
            self.onTransaction(info)
        } else if (Constants.facebookShare.contains(where: { urlRequest.contains($0) })) {
            guard let urlString = navigationAction.request.url?.queryStringParameter(param: "u"), let url = URL(string: urlString), SNSType.facebook.installed() else {
                decisionHandler(.cancel)
                web.transitionFromSafari(urlRequest)
                return
            }
            decisionHandler(.cancel)
            SNSShare.post(type: .facebook, data: SNSShareData([url]), controller: web)
        } else if (Constants.lineShare.contains(where: { urlRequest.contains($0) })) {
            decisionHandler(.cancel)
            if let urlString = navigationAction.request.url?.queryStringParameter(param: "url"), let url = URL(string: urlString), SNSType.line.installed() {
                SNSShare.post(type: .line, data: SNSShareData([url]), controller: web)
            } else if let text = navigationAction.request.url?.queryStringParameter(param: "text"), SNSType.line.installed() {
                SNSShare.post(type: .line, data: SNSShareData(text), controller: web)
            } else {
                let newUrl = urlRequest.replace(target: "line://", withString: "https://line.me/R/")
                web.transitionFromSafari(newUrl)
            }
        } else if (Constants.twitterShare.contains(where: { urlRequest.contains($0) })) {
            decisionHandler(.cancel)
            web.transitionFromSafari(urlRequest)
        } else if let url = navigationAction.request.url, url.scheme == "youtube" || url.scheme == "vnd.youtube" || url.queryStringParameter(param: "redirect_app_store_ios") == "1" {
            decisionHandler(.cancel)
            var newUrl = url.absoluteString
            
            if !UIApplication.shared.canOpenURL(url), let urlHttpsScheme = url.replaceScheme("https") {
                newUrl = urlHttpsScheme.absoluteString
            }
            
            web.transitionFromSafari(newUrl)
        } else if let url = navigationAction.request.url, URLType(rawValue: url) == .deeplink {
            decisionHandler(.cancel)
            web.transitionFromSafari(urlRequest)
        } else {
            decisionHandler(.allow)
        }
    }
    
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, redirectScript navigationAction: WKNavigationAction) -> (input: String, event: String?)? {
        guard let currentUrl = navigationAction.request.url?.absoluteString,
              currentUrl == TransactionLink.votingNoteRedirect.rawValue else { return nil }
        
        let ipat = UserManager.share().getCurrentIpatSkipLogin()
        let userId = ipat?.siteUserId ?? ""
        let pinCode = ipat?.pinCode ?? ""
        let parNo = ipat?.parsNo ?? ""
        
        let js = "document.getElementById('UID').value = \"\(userId)\";" +
        "document.getElementById('PWD').value = \"\(pinCode)\";" +
        "document.getElementById('PARS').value = \"\(parNo)\";"
        
        let input = js
        return (input, nil)
    }
    
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, clearHistory currentURL: String) -> Bool {
        return currentURL == TransactionLink.votingNoteRedirect.rawValue
    }
}

//MARK: Private
extension HomeViewModel {
    
    private func needShowGuide() -> Bool {
        return UserManager.share().showGuide()
    }
    
    private func showGuideIfNeed() {
        let isShow = needShowGuide()
        if(isShow) {
            self.onShowGuide.value = isShow
        }
    }
    
    private func getNewsTop(_ allItems: [XMLIndexer], top: Int) ->[NewModel] {
        var items: [NewModel] = []
        
        if(top != 0) {
            for i in 0..<allItems.count {
                let iXml = allItems[i]
                let item = NewModel(xml: iXml)
                
                if(iXml.description.contains("pickup_")) {
                    items.append(item)
                }
                
                if(items.count == top) {
                    return items
                }
            }
        }
        
        return items
    }
    
    private func clearData() {
        self.topics.updateNoBind([])
        self.oversea.updateNoBind([])
        self.news.updateNoBind([])
        self.flagRaces.removeAll()
        self.flagHolidays.removeAll()
        self.races.updateNoBind(nil)
        self.ugrentNotice.updateNoBind((nil, true))
    }
    
    private func convert(_ data: NotificationsSettingDataModel?, each:@escaping((topic: String, value: String, raw: SettingsNotificationItem?)) -> Void) -> [SettingsNotificationSection: [ISettingNotificationModel]] {
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
                
                each((topic, topicValue, title))
                
                sections[section] = items
            }
            
        }
        
        //Add item descript
        sections[.describe] = []
        
        return sections
    }
    
    private func noEmptyDataKindOfTopicView() -> Bool {
        if let topic = topics.value, !topic.isEmpty {
            return true
        } else if let oversea = oversea.value, !oversea.isEmpty {
            return true
        } else if let _ = ugrentNotice.value?.data {
            return true
        } else {
            return false
        }
    }
    
    private func pushCUIDOnAppFlyer() {
        guard let cuid = Utils.getUserDefault(key: .userId) else { return }
        AppsFlyerLib.shared().customerUserID = cuid
        AppsFlyerLib.shared().start { message, error in
            
        }
    }
    
    private func addObserver() {
        Utils.onObserver(self, selector: #selector(onReceivedFCMToken), name: .receivedFCMToken)
    }
    
    @objc private func onReceivedFCMToken(_ notification: Notification? = nil) {
        let needSubscribe = !flagSubscribed && !Constants.System.fcmToken.isEmpty
        if(needSubscribe) {
            //TODO: Subscribe emergency topic
            self.subscribeEmergencyTopic()
            
            //TODO: Subscribe userId topic
            self.subscribeUserTopic()
            
            //TODO: Subscribe setting topic
            self.subscribeSettingTopic()
            
            self.flagSubscribed = true
        }
    }
    
    private func subscribeEmergencyTopic() {
        subscribeBy(SettingsNotificationItem.emergency.topic())
    }
    
    private func subscribeUserTopic() {
        if let userId = UserManager.share().user?.userId.trim() {
            subscribeBy(userId)
        }
    }
    
    private func subscribeSettingTopic() {
        Task { @IMTGlobal in
            do {
                let setting = try await getNotificationSetting()
                let listOshiuma = try await getListOshiUma()
                let listOshiKishu = try await getListOshiKishu()
                let preferenceTopics: [SettingsNotificationItem] = [.specialRaceRegistrationInformation, .confirmedRaceInformation, .raceResultInformation, .thisWeeksHorseRiding]
                
                main()
                
                /*--------------------------------------------------------------------------------------------------------------------*/
                func main() {
                    let _ = self.convert(setting, each: { topicInfo in
                        let topic = topicInfo.topic
                        let enumTopic = topicInfo.raw
                        let enable = topicInfo.value == "1"
                        
                        if(enable) {
                            subscribe(enumTopic, topic: topic)
                        } else {
                            unsubscribe(enumTopic, topic: topic)
                        }
                    })
                }
                
                func subscribe(_ enumTopic: SettingsNotificationItem?, topic topicSetting: String) {
                    if let enumTopic = enumTopic, preferenceTopics.contains(enumTopic) {
                        subscribePreferenceTopics(enumTopic, action: subscribeBy)
                    } else {
                        subscribeBy(topicSetting)
                    }
                }
                
                func unsubscribe(_ enumTopic: SettingsNotificationItem?, topic topicSetting: String) {
                    if let enumTopic = enumTopic, preferenceTopics.contains(enumTopic) {
                        subscribePreferenceTopics(enumTopic, action: unsubscribeBy)
                    } else {
                        unsubscribeBy(topicSetting)
                    }
                }
                
                func subscribePreferenceTopics(_ enumTopic: SettingsNotificationItem, action: ((String) -> Void)) {
                    switch enumTopic {
                    case .specialRaceRegistrationInformation, .confirmedRaceInformation, .raceResultInformation:
                        listOshiuma.forEach { item in
                            let topic = item.getTopic(enumTopic.sendkbn())
                            action(topic)
                        }
                        break
                    case .thisWeeksHorseRiding:
                        listOshiKishu.forEach { item in
                            let topic = item.getTopic(enumTopic.sendkbn())
                            action(topic)
                        }
                        break
                    default:
                        break
                    }
                }
                /*--------------------------------------------------------------------------------------------------------------------*/
            } catch _ {
                
            }
        }
    }
}

extension HomeViewModel: IMTWedRedirect {
    func increaseRequest() {
        self.numRequest += 1
    }
    
    func redirect(url: String?, html: String?, success: Bool) {
        Utils.hideProgress()
        if let url = url {
            Utils.mainAsync { [weak self] in
                self?.onTransaction((url: url, useWebView: false))
            }
        }
        self.numRequest = 0
    }
    
    private func loadUMACA() {
        self.call(transaction: .umaca) { [weak self] htmlUMACA in
            if let urlUMACASkipLogin = self?.getFullURLSkipLogin(transition: .umaca, html: htmlUMACA) {
                self?.redirect(url: urlUMACASkipLogin, html: htmlUMACA, success: true)
            } else {
                self?.redirect(url: TransactionLink.umaca.rawValue, html: nil, success: true)
            }
            Utils.hideProgress()
        } failureCompletion: {
            Utils.hideProgress()
        }
    }
    
    private func call(transaction: TransactionLink,
                      successCompletion:@escaping(_ html: String) -> Void,
                      failureCompletion:@escaping() -> Void) {
        if let request = request(url: transaction.rawValue, post: true) {
            URLSession.shared.dataTask(with: request) {data, response, error in
                if let data = data,
                   let html = String(data: data, encoding: .japaneseEUC) {
                    successCompletion(html)
                } else {
                    failureCompletion()
                }
            }.resume()
        } else {
            failureCompletion()
        }
    }
    
    private func getFullURLSkipLogin(transition: TransactionLink, html: String) -> String? {
        if let range = html.range(of: "NAME=uh VALUE="),
           let umaca = UserManager.share().getCurrentUMACASkipLogin() {
            let afterStr = html[range.upperBound...]
            
            let uhValue = afterStr.prefix(7).suffix(6)
            let gValue = "780"
            let cardNumberValue = umaca.cardNumber ?? ""
            let birthdayValue = umaca.birthday ?? ""
            let pinCodeValue =  umaca.pinCode ?? ""
            let mergeValue = "\(cardNumberValue)\(birthdayValue)\(pinCodeValue)"
            let ifValue = "1"
            
            let parameters = "\(uhValue)&\(gValue)&\(mergeValue)&\(ifValue)"
            let fullURL = transition.externalLink(parameters)
            return fullURL
        }
        
        return nil
    }
    
}

