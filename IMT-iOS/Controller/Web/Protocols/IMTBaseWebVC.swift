//
//  IMTBaseWebVC.swift
//  IMT-iOS
//
//  Created by dev on 04/07/2023.
//

import Foundation
import WebKit

protocol IMTBaseWebVC {
    
    associatedtype D: WKUIDelegate, WKNavigationDelegate
    
    func getWebKit() -> WKWebView
    func getWKDelegate() -> D?
    func getUserAgent() -> String?
    
    func configWebKit()
}

extension IMTBaseWebVC {
    
    func getWKDelegate() -> D? {
        return nil
    }
    
    func getUserAgent() -> String? {
        return Constants.System.userAgentIMTA
    }
    
    func configWebKit() {
        let webKit = self.getWebKit()
        let delegate = self.getWKDelegate()
        
        webKit.backgroundColor = .clear
        webKit.customUserAgent = getUserAgent()
        webKit.uiDelegate = delegate
        webKit.navigationDelegate = delegate
        webKit.allowsBackForwardNavigationGestures = true
    }
}
