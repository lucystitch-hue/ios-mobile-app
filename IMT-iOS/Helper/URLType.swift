//
//  URLType.swift
//  IMT-iOS
//
//  Created by dev on 21/12/2023.
//

import Foundation

enum URLType {
    case deeplink
    case https
    case http
    case emptyScheme
    
    private struct Constants {
        static let httpsScheme = "https"
        static let httpScheme = "http"
    }
    
    init(rawValue: URL) {
        if rawValue.scheme == nil {
            self = .emptyScheme
        } else if rawValue.scheme?.lowercased() == Constants.httpsScheme.lowercased() {
            self = .https
        } else if rawValue.scheme?.lowercased() == Constants.httpScheme.lowercased() {
            self = .http
        } else {
            self = .deeplink
        }
    }
}
