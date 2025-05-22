//
//  IMTWeb.swift
//  IMT-iOS
//
//  Created by dev on 03/06/2023.
//

import Foundation

protocol IMTWeb {
    func load(transaction: TransactionLink)
    func load(url strURL: String, convertHTML: Bool)
    func request(url strURL: String, post: Bool) -> URLRequest?
}

extension IMTWeb {
    func load(transaction: TransactionLink) {
        self.load(url: transaction.rawValue, convertHTML: false)
    }
  
    internal func request(url strURL: String, post: Bool = false) -> URLRequest? {
        guard let url = URL(string: strURL) else { return nil }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constants.System.timeoutIntervalWebView)
        request.allHTTPHeaderFields = ["referer" : Constants.System.refererWebView,
                                       "User-agent": Constants.System.userAgentIMTA]

        
//        if let bodyData = TransactionLink(rawValue: url.absoluteString)?.bodyData() {
//            request.httpMethod = "POST"
//            request.httpBody = bodyData.data(using: .utf8)!
//        } else 
        if (post == true) {
            request.httpMethod = "POST"
            request.httpBody = strURL.toBodyData()?.data(using: .utf8)
        }
        
        return request
    }
}
