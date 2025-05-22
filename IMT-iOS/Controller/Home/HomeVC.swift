//
//  HomeVC.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//
/**
     Summary of file to comment on
     Date: 25/10/2023
     Corresponding slide number #9
     Version number: 2.6.2
     Description: Fix render warning view when refresh scene
 **/
import UIKit
import MaterialComponents
import IQKeyboardManagerSwift

class HomeVC: IMTContentActionVC<HomeViewModel> {
    
    @IBOutlet weak var stvContentView: UIStackView!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var svMainContent: UIScrollView!
    @IBOutlet weak var vNewsView: NewsView!
    @IBOutlet weak var vCurrentRace: CurrentRaceView!
    @IBOutlet weak var vSpaceParentTopic: UIView!
    @IBOutlet weak var vTopic: TopicView!
    @IBOutlet weak var vTopicExtension: TopicView!
    @IBOutlet weak var vMenuWidget: CollectWidget!
    @IBOutlet weak var vRecommendedFunctionsMenuWidget: CollectWidget!
    @IBOutlet weak var vServiceWidget: CollectWidget!
    @IBOutlet weak var vHoreRaceInfoLinkWidget: CollectWidget!
    @IBOutlet weak var vWarning: WarningView!
    @IBOutlet weak var vService: ServiceView!
    @IBOutlet weak var vServiceAppcp: ServiceView!
    
    @IBOutlet weak var btnWeather: IMTButton!
    @IBOutlet weak var svContainer: UIScrollView!
    @IBOutlet weak var vGroupWheater: IMTView!
    
    @IBOutlet weak var vGroupWarning: UIView!
    @IBOutlet weak var vSpaceWarning: UIView!
    @IBOutlet weak var vGroupTopic: UIView!
    @IBOutlet weak var vGroupTopicExtension: UIView!
    @IBOutlet weak var vSpaceTopic: UIView!
    @IBOutlet weak var vSpaceTopicExtension: UIView!
    @IBOutlet weak var vSpaceTopicExtension2: UIView!
    @IBOutlet weak var vSpaceTopicExtension3: UIView!
    @IBOutlet weak var vSpaceGroupRaceCurrent: UIView!
    @IBOutlet weak var vGroupRaceCurrent: CurrentRaceView!
    @IBOutlet weak var vSNS: UIStackView!
    @IBOutlet weak var vAutoScrollLabelContainer: UIView!
    
    @IBOutlet weak var cstHeightTopic: NSLayoutConstraint!
    @IBOutlet weak var cstHeightTopicExtension: NSLayoutConstraint!
    @IBOutlet weak var cstHeightRaceCurrent: NSLayoutConstraint!
    @IBOutlet weak var cstHeightService: NSLayoutConstraint!
    @IBOutlet weak var cstHeightServiceAppcp: NSLayoutConstraint!
    @IBOutlet weak var cstHeightNews: NSLayoutConstraint!
    @IBOutlet weak var cstHeightMenuWidget: NSLayoutConstraint!
    @IBOutlet weak var cstHeightServiceWidget: NSLayoutConstraint!
    @IBOutlet weak var cstHeightRecommendedFunctionsMenuWidget: NSLayoutConstraint!
    @IBOutlet weak var cstHeightHorseRaceInfoLinkWidget: NSLayoutConstraint!
    @IBOutlet weak var cstHeightWarning: NSLayoutConstraint!
    
    private lazy var autoScrollLabel: IMTSlider = {
        let slider: IMTSlider = IMTSlider()
        self.vAutoScrollLabelContainer.addSameSizeConstaints(subView: slider)
        return slider
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = HomeViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UserDefaults.standard.value(forKey: "open app") ?? "abc"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!isFirstLoad) {
            self.onStopAnimateVote()
            viewModel.onShowGuide.value = false
            viewModel.refreshData()
        }
        self.viewModel.reloadHomeContentIfNeed(self, isFirstLoad)
        
        super.viewWillAppear(animated)
        self.viewModel.tabChange = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.tabChange = true
        if(!isFirstLoad) {
            onPrepareAnimateBack()
        }
    }
    
    override func setupUI() {
        configTopic()
        configTopicExtension()
        configCurrentRace()
        configNews()
        configButton()
        configMenuWidget()
        configServiceWidgetV2()
        configServiceWidget()
        configHorseRaceInfoLinkWidget()
        configWarningView()
        configSNSView()
        configAutoScrollLabel()
        configRefreshControl(svMainContent)
    }
    
    override func setupData() {
        viewModel.setup(contentView: vContent, mainView: svMainContent)
        viewModel.animateVoting(self)
        
        viewModel.topics.bind { [weak self]results in
            guard let results = results else { return }
            let hidden = results.isEmpty
            self?.vSpaceTopic.isHidden = hidden
            self?.vGroupTopic.isHidden = hidden
            self?.vSpaceTopicExtension2.isHidden = hidden
            self?.vSpaceTopicExtension3.isHidden = !hidden
            self?.vTopic.topics = results
        }
        
        viewModel.oversea.bind { [weak self]results in
            guard let results = results else { return }
            let hidden = results.isEmpty
            self?.vSpaceTopicExtension.isHidden = hidden
            self?.vSpaceTopicExtension2.isHidden = hidden
            self?.vTopicExtension.isHidden = hidden
            self?.vGroupTopicExtension.isHidden = hidden
            self?.vTopicExtension.topics = results
            self?.vSpaceTopicExtension3.isHidden = !hidden
        }
        
        viewModel.races.bind { [weak self] results in
            guard let results = results else { return }
            let hidden = results.races.count == 0 || results.holidays.count == 0
            self?.vGroupRaceCurrent.isHidden = hidden
            self?.vSpaceGroupRaceCurrent.isHidden = hidden
            self?.vCurrentRace.isHidden = hidden
            if(hidden == false) {
                self?.vCurrentRace.setupData(data: results)
            }
            
            self?.vServiceWidget.reloadData()
        }
        
        viewModel.news.bind { [weak self] results in
            self?.vNewsView.setup(results!)
            self?.vNewsView.layoutIfNeeded()
        }
        
        viewModel.services.bind { [weak self] results in
            self?.vService.setup(services: results!, asDelegate: self!)
        }
        
        viewModel.serviceAppcp.bind { [weak self] results in
            self?.vServiceAppcp.setup(services: results!, asDelegate: self!)
        }
        
        viewModel.ugrentNotice.bind { [weak self] result in
            if let result = result, let configuration = result.data {
                self?.vSpaceWarning.isHidden = false
                self?.vGroupWarning.isHidden = false
                self?.vSpaceTopicExtension2.isHidden = false
                self?.vSpaceTopicExtension3.isHidden = false
                self?.vWarning.setup(configuration: configuration)
            } else {
                self?.vSpaceWarning.isHidden = true
                self?.vGroupWarning.isHidden = true
                self?.vSpaceTopicExtension2.isHidden = true
                self?.vSpaceTopicExtension3.isHidden = true
            }
        }
        
//        viewModel.hasTopTopics.bind { result in
//            guard let result = result else { return }
//            self.vSpaceParentTopic.isHidden = !result
//        }
        
        viewModel.onShowGuide.bind { [weak self] result in
            if(result!) {
                self?.gotoGuide()
            }
        }
        
        viewModel.onChangeContent.bind { [weak self] result in
            let hidden = result == .home
            self?.onHiddenBack(hidden)
        }
        
        viewModel.onFetchComplete = { [weak self] in
            let isScroll = self?.isScrollToTop ?? true
            if(isScroll) {
                self?.scrollToTop()
            }
            self?.endRefreshing()
        }
        
        viewModel.onTransaction = { [weak self]results in
            self?.transitionFromSafari(results.url)
        }
    }
    
    override func onDismissChild(_ controller: UIViewController) {
        if(controller.isKind(of:MDCBottomSheetController.self) || controller.isKind(of: LinkageSubcriptionVC.self)) {
            self.onStopAnimateVote()
            self.viewModel.onShowGuide.updateNoBind(false)
        }
        
        viewModel.refreshData()
    }
    
    override func didChangeBackground() {
        super.didChangeBackground()
        viewModel.animateVoting(self)
    }
    
    override func willChangeForeground() {
        super.willChangeForeground()
        viewModel.animateVoting(self)
        endRefreshing()
        svMainContent.isScrollEnabled = true
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        svMainContent.isScrollEnabled = true
    }
    
    override func checkVersionWhenRunApp() -> Bool {
        return true
    }
    
    override func back() {
        viewModel.back(self)
    }
    
    override func viewContentWillAppear(_ animated: Bool) {
        if(!viewModel.tabChange) {
            viewWillAppear(animated)
        }
    }
    
    override func onSwipe(x: CGFloat, alpha: CGFloat, finish: Bool) {
        viewModel.swipe(self, x: x, alpha: alpha, finish: finish)
    }
    
    override func getMainContent() -> UIScrollView? {
        return svMainContent
    }
    
    override func prepareRoot() {
        viewModel.loadContent(self, type: .home)
    }
    
    @IBAction func actionBettingTickets20YearsOld(_ sender: Any) {
        viewModel.transactionAt(self, link: .bettingTickets20YearsOld)
    }
    
    @IBAction func actiongAmblingAddictionMeasures(_ sender: Any) {
        viewModel.transactionAt(self, link: .amblingAddictionMeasures)
    }
    
    @IBAction func actionWeather(_ sender: Any) {
        viewModel.transactionAt(self, link: .weather, post: true)
    }
    
    @IBAction func actionRefresh(_ sender: Any) {
        actionPullRequest()
    }
    
    override func actionPullRequest() {
        viewModel.refreshData()
        UserDefaults.standard.removeObject(forKey: "open app")
    }
    
    override func action(_ data: FIRNotificationModel) {
        viewModel.pushScreenFromNotification(self, data: data)
    }
    
    override func gotoVoteOnline() {
        viewModel.loadContent(self, type: .subcriber)
    }
    
    override func getContentView() -> UIView {
        return stvContentView
    }
    
    @IBAction func actionRacecourseWindsTools(_ sender: UIButton) {
        viewModel.racecourseWindsTools(self, tag: sender.tag)
    }
    
    @IBAction func actionShareSNS(_ sender: UIButton) {
        viewModel.shareSNSHome(self, tag: sender.tag)
    }
}

//MARK: Private
extension HomeVC {
    private func configTopic(){
        self.vTopic.setShadow()
        self.vTopic.visibleOfNumber = true
        self.vTopic.delegate = self
    }
    
    private func configTopicExtension(){
        self.vTopicExtension.setShadow()
        self.vTopicExtension.title = "Featured Overseas Race Information"
        self.vTopicExtension.visibleOfNumber = true
        self.vTopicExtension.delegate = self
    }
    
    private func configCurrentRace() {
        self.vCurrentRace.delegate = self
    }
    
    private func configNews() {
        self.vNewsView.delegate = self
    }
    
    private func configButton() {
        self.onRunAnimateVote()
        self.vGroupWheater.backgroundColor = .main
//        self.btnWeather.backgroundColor = .main
    }
    
    private func configMenuWidget() {
        vMenuWidget.delegate = self
        vMenuWidget.setup()
    }
    
    private func configServiceWidget() {
        vServiceWidget.delegate = self;
        vServiceWidget.setup()
    }
    
    private func configServiceWidgetV2() {
        vRecommendedFunctionsMenuWidget.delegate = self;
        vRecommendedFunctionsMenuWidget.setup()
    }
    
    private func configHorseRaceInfoLinkWidget() {
        vHoreRaceInfoLinkWidget.delegate = self
        vHoreRaceInfoLinkWidget.setup()
    }
    
    private func configWarningView() {
        vWarning.delegate = self
//        vWarning.setup()
    }
    
    private func configSNSView() {
        vSNS.spacing = vSNS.frame.width / 9
    }
    
    private func configAutoScrollLabel() {
        autoScrollLabel.delegate = self
        autoScrollLabel.isUserInteractionEnabled = true
        autoScrollLabel.backgroundColor = .white
        autoScrollLabel.textColor = .darkCharcoal
        autoScrollLabel.labelSpacing = 60
        autoScrollLabel.scrollSpeed = 30
        autoScrollLabel.texts = [
            "Betting is allowed from age 20",
            "IMT's Measures Against Gambling Addiction"
        ]
        autoScrollLabel.scrollDirection = .left
        autoScrollLabel.font = .appFontW6Size(14)
    }
}

extension HomeVC: TopicViewDelegate {
    func didHeightChange(_ height: Float, view: TopicView) {
        if(view == vTopic) {
            self.cstHeightTopic.constant = CGFloat(height)
        } else if(view == vTopicExtension) {
            self.cstHeightTopicExtension.constant = CGFloat(height)
        }
    }
    
    func didChoiceTopic(view: TopicView) {
        if(view == vTopic) {
            viewModel.transactionAt(self, link: .featuredRacesOfTheWeek)
        } else if(view == vTopicExtension) {
            viewModel.transactionAt(self, link: .featuredRacesOverseas)
        }
    }
}

extension HomeVC: CurrentRaceViewDelegate {
    func didHeightChange(_ height: Float, view: CurrentRaceView) {
        self.cstHeightRaceCurrent.constant = CGFloat(height)
    }
    
    func didTransaction(link: String, view: CurrentRaceView) {
        self.viewModel.transactionAt(self, url: link, post: true)
    }
    
    func didTransaction(link: JMLink, view: CurrentRaceView) {
        self.viewModel.transactionAt(self, url: link.url, post: link.post)
    }
    
    func didTransaction(link: JMLink, didChoiceView view: CurrentRaceView) {
        self.viewModel.transactionAt(self, url: link.url, post: link.post, allowSwipe: true)
    }
}

extension HomeVC: NewsViewDelegate {
    func didHeightChange(_ height: Float, view: NewsView) {
        self.cstHeightNews.constant = CGFloat(height);
    }
    
    func didChoiceAllNew(_ view: NewsView) {
        viewModel.transactionAt(self, link: .allNew)
    }
    
    func didChoiceNewAt(_ index: Int, view: NewsView) {
        guard let link = viewModel.news.value?[index].link else { return }
        viewModel.transactionAt(self, url: link)
    }
}

extension HomeVC: ServiceViewDelegate {
    func serviceView(_ serviceView: ServiceView, heightChange: Float) {
        if serviceView == vService {
            self.cstHeightService.constant = CGFloat(heightChange)
        } else if serviceView == vServiceAppcp {
            self.cstHeightServiceAppcp.constant = CGFloat(heightChange)
        }
    }
    
    func serviceView(_ serviceView: ServiceView, didSelectAt service: Service) {
        self.viewModel.transactionService(self, service: service)
    }
    
    func serviceView(_ serviceView: ServiceView, didChoiceServiceOrderTicketFromQRCode isQRCode: Bool) {
        if(!isQRCode) {
            self.transition(link: .contentLanding)
        }
    }
}

extension HomeVC: CollectWidgetDelegate {
    func kindOfCollectWidget(_ widget: CollectWidget) -> CollectWidgetStyle {
        if(widget == vMenuWidget) {
            return .menu
        } else if(widget == vServiceWidget) {
            return .service
        } else if(widget == vRecommendedFunctionsMenuWidget) {
            return .recommendedFunctionsMenu
        } else {
            return .horseRaceInfoLink
        }
    }
    
    func collectWidget(_ widget: CollectWidget, heightChange: Float) {
        if(widget == vMenuWidget) {
            cstHeightMenuWidget.constant = CGFloat(heightChange)
        } else if(widget == vServiceWidget) {
            cstHeightServiceWidget.constant = CGFloat(heightChange)
        } else if(widget == vRecommendedFunctionsMenuWidget) {
            cstHeightRecommendedFunctionsMenuWidget.constant = CGFloat(heightChange)
        } else if(widget == vHoreRaceInfoLinkWidget) {
            cstHeightHorseRaceInfoLinkWidget.constant = CGFloat(heightChange)
        }
    }
    
    func collectWidget(_ widget: CollectWidget, didSelectAt index: Int) {
        if(widget == self.vMenuWidget) {
            self.viewModel.transactionMenuWidget(self, index: index)
        } else if(widget == self.vServiceWidget) {
            self.viewModel.transactionServiceWidget(self, index: index)
        } else if(widget == self.vRecommendedFunctionsMenuWidget) {
            self.viewModel.transactionRecommendedFunctionsMenuWidget(self, index: index)
        } else if(widget == self.vHoreRaceInfoLinkWidget) {
            self.viewModel.transactionHorseInfoLink(self, index: index)
        }
    }
    
    func collectWidget(_ widget: CollectWidget, disableWidgetAt index: Int) -> Bool {
        if(widget == vServiceWidget) {
            return self.viewModel.disableServiceWidget(index)
        }
        
        return false
    }
}

extension HomeVC: WarningViewDelegate {
    func didHeightChange(_ height: Float, view: WarningView) {
        if(view == vWarning) {
            cstHeightWarning.constant = CGFloat(height)
        }
    }
}

extension HomeVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollView.isScrollEnabled = UIApplication.shared.applicationState == .active
    }
}

extension HomeVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        
        return false;
    }
}

extension HomeVC: IMTSliderDelegate {
    func slider(_ slider: IMTSlider, didSelectText tag: Int) {
        switch tag {
        case 0:
            viewModel.transactionAt(self, url: TransactionLink.bettingTickets20YearsOld.rawValue)
            break
        case 1:
            viewModel.transactionAt(self, url: TransactionLink.amblingAddictionMeasures.rawValue)
            break
        default:
            break
        }
    }
}
