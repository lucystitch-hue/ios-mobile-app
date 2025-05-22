//
//  FAQVC.swift
//  IMT-iOS
//
//  Created by dev on 04/07/2023.
//

import UIKit
import WebKit

class FAQVC: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    internal var numRequest: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func gotoBack() {
        self.pop()
    }
}

extension FAQVC {
    private func setupUI() {
        setupNavigation()
        configWebKit()
    }
    
    private func setupData() {
        let link = getLink()
        self.load(url: link)
    }
    
    private func getLink() -> String {
        return Utils.getLinkFaqMail()
    }
}

extension FAQVC: IMTBaseWebVC {
    typealias D = FAQVC
    
    func getWebKit() -> WKWebView {
        return self.webView
    }
    
    func getWKDelegate() -> FAQVC? {
        return self
    }
}

extension FAQVC: IMTWedRedirect {
    
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

extension FAQVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.inquiryImprovementRequest
    }
}

extension FAQVC:  WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utils.showProgress()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utils.hideProgress()
    }
}
