//
//  MenuVC.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import UIKit

protocol MyPersonDelegate {
    
}
class MenuVC: IMTContentActionVC<MenuViewModel> {
    
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var svMainContent: UIScrollView!
    @IBOutlet weak var btnRedDot: UIButton!
    @IBOutlet weak var lbNoticeIMT: IMTLabel!
    @IBOutlet weak var lbVersion: IMTLabel!
    @IBOutlet weak var vPersonalGroup: UIView!
    @IBOutlet weak var vEmailGroup: UIView!
    @IBOutlet weak var vChangePasswordGroup: UIView!
    @IBOutlet weak var vDeleteAccount: UIView!
    @IBOutlet weak var vUMACAGroup: UIView!
    
    public var delegate: MyPersonDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = MenuViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
        viewModel.loadContent(self, type: .main)
        self.viewModel.refreshData()
    }
    
    override func viewContentWillAppear(_ animated: Bool) {
        viewWillAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.removeObserver()
    }
    
    override func onDismissChild(_ controller: UIViewController) {
        self.viewModel.refreshData()
    }
    
    override func onSwipe(x: CGFloat, alpha: CGFloat, finish: Bool = false) {
        viewModel.swipe(self, x: x, alpha: alpha, finish: finish)
    }
    
    override func getSwipingRatio() -> CGFloat {
        viewModel.getSwipingRatio()
    }
    
    override func setupUI() {
        self.onHiddenBack(false)
        self.configBaseEnviroment()
    }
    
    override func setupData() {
        viewModel.setup(contentView: vContent, mainView: svMainContent, homeContentView: vHomeContent)
        
        viewModel.onCountNotification.bind { [weak self] count in
            self?.configUINotification()
        }
        
        viewModel.onCloseInquiries.bind { [weak self] close in
            guard let close = close , close else { return }
            self?.viewModel.loadContent(self, type: .main)
            self?.scrollToTop()
        }
        
        viewModel.onChangePasswordSuccessfull.bind { [weak self]  changeEmail in
            guard let change = changeEmail , change else { return }
            self?.viewModel.gotoConfirmOtp(self)
        }
        
        viewModel.onFetchComplete = { [weak self] in
            let isScroll = self?.isScrollToTop ?? true
            if(isScroll) {
                self?.scrollToTop()
            }
            self?.endRefreshing()
        }
        
        viewModel.onCheckChangePass = { [weak self] success in
            if (success) {
                self?.viewModel.gotoSendOtpToMail(self)
            } else {
                self?.showWarningLimitUpdate()
            }
        }
        
        viewModel.onCheckChangeEmail = { [weak self] success in
            if (success) {
                self?.viewModel.gotoEmailAddressConfirmationChange(self)
            } else {
                self?.showWarningLimitUpdate()
            }
        }
        
        lbVersion.text = viewModel.getVersionApp()
    }
    
    override func back() {
        viewModel.back(self)
    }
    
    override func backToRoot() {
        viewModel.loadContent(self, type: .main)
    }
    
    override func action(_ data: FIRNotificationModel) {
        self.viewModel.pushScreenFromNotification(self, data: data)
    }
    
    override func gotoVoteOnline() {
        self.viewModel.gotoVoteOnline(self)
    }
    
    override func getMainContent() -> UIScrollView? {
        return svMainContent
    }
    
    override func getNumberOfChildController() -> Int {
        return self.viewModel.contentQueue.count
    }
    
    override func getNumberRemainPage() -> Int {
        return self.viewModel.getNumberRemainPage()
    }
    
    @IBAction func actionUserInformationConfirmationChange(_ sender: Any) {
        self.viewModel.gotoUpdatePersonalInfo(self)
    }
    
    @IBAction func actionEmailAddressConfirmationChange(_ sender: Any) {
        self.viewModel.checkChangeEmail()
    }
    
    @IBAction func actionChangePassword(_ sender: Any) {
        self.viewModel.checkChangePass()
    }
    
    @IBAction func actionNotificationSettings(_ sender: Any) {
        self.viewModel.gotoSettingNotification(self)
    }
    
    @IBAction func actionOnlineVotingCooperation(_ sender: Any) {
        self.viewModel.gotoSubscriberNumber(self)
    }
    
    @IBAction func actionNoticeFromIMT(_ sender: Any) {
        self.viewModel.gotoNotification(self)
    }
    
    @IBAction func actionFAQs(_ sender: Any) {
        self.viewModel.gotoFAQs(self)
    }
    
    @IBAction func actionInquiries(_ sender: Any) {
        self.viewModel.gotoInquiries(self)
    }
    
    @IBAction func actionQuestionnaire(_ sender: Any) {
        viewModel.gotoListQuestions(self)
    }
    
    @IBAction func actionTermsOfService(_ sender: Any) {
        viewModel.gotoTermOfService(self)
    }
    
    @IBAction func actionPrivacyPolicy(_ sender: Any) {
        viewModel.gotoPrivacyPolicy(self)
    }
    
    @IBAction func actionAppLogout (_ sender: Any) {
        viewModel.gotoLogout(self)
    }
    
    @IBAction func actionWithdrawal(_ sender: Any) {
        viewModel.gotoDeleteAcount(self)
    }
    
    @IBAction func actionFaqIMTMail(_ sender: Any) {
        viewModel.gotoFaqIMTMail(self)
    }
    
    @IBAction func actionBiometric(_ sender: Any) {
        viewModel.gotoBiometricManagement(self)
    }
    
    @IBAction func actionUMACASmartCollaboration(_ sender: Any) {
        viewModel.gotoUMACASmartCollaboration(self)
    }
    
    @IBAction func actionPreferredDisplay(_ sender: Any) {
        viewModel.gotoPreferredDisplay(self)
    }
}

//MARK: Private
extension MenuVC {
    private func configUINotification() {
        self.btnRedDot.isHidden = !Utils.hasNotification()
        self.lbNoticeIMT.text = "\(Constants.countNotification)"
    }
    
    private func configBaseEnviroment() {
        let env = Utils.getEnviroment()
    }
}
