//
//  LiveVC.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import UIKit
import WebKit

class LiveVC: IMTContentActionVC<LiveViewModel> {
    
    @IBOutlet weak var stvContentView: UIStackView!
    @IBOutlet weak var svMainContent: UIScrollView!
    @IBOutlet weak var webView: WKWebView!
    
    internal var numRequest: Int = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel = LiveViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.load(transaction: .live)
        Utils.logActionClick(.liveTab)
        super.viewWillAppear(animated)
        setupData()
        viewModel.loadContent(self, type: .main)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        webView.evaluateJavaScript("document.body.remove()")
    }
    
    override func setupUI() {
        self.onHiddenBack(false)
        configWebKit()
    }
    
    override func setupData() {
        viewModel.setup(contentView: stvContentView, mainView: svMainContent, homeContentView: vHomeContent)
    }
    
    override func back() {
        viewModel.back(self)
    }
    
    override func onSwipe(x: CGFloat, alpha: CGFloat, finish: Bool = false) {
        viewModel.swipe(self, x: x, alpha: alpha, finish: finish)
    }
    
    override func getSwipingRatio() -> CGFloat {
        return viewModel.getSwipingRatio()
    }
    
    override func gotoVoteOnline() {
        viewModel.loadContent(self, type: .subcriber)
    }
    
    override func getNumberRemainPage() -> Int {
        return viewModel.getNumberRemainPage()
    }
}

extension LiveVC: IMTBaseWebVC {
    typealias D = LiveVC
    
    func getWebKit() -> WKWebView {
        return self.webView
    }
    
    func getWKDelegate() -> LiveVC? {
        return self
    }
}

extension LiveVC: IMTWedRedirect {
    
    func increaseRequest() {
        self.numRequest += 1
    }
    
    func redirect(url: String?, html: String?, success: Bool) {
        guard let url = url,
        let request = self.request(url: url, post: false) else { return }
        self.webView.load(request)
        
        self.numRequest = 0
    }
}

extension LiveVC:  WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utils.showProgress()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utils.hideProgress()
    }
}
