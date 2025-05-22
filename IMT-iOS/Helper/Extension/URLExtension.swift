//
//  URLExtension.swift
//  IMT-iOS
//
//  Created by dev on 21/12/2023.
//

import Foundation

extension URL {
    func type() -> URLType? {
        return URLType(rawValue: self)
    }
    
    func replaceScheme(_ scheme: String) -> URL? {
        guard var component = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        component.scheme = scheme
        return component.url
    }
    
    func query() -> [URLQueryItem]? {
        guard let component = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        return component.queryItems
    }
    
    func queryStringParameter(param: String) -> String? {
        guard let queryItems = query() else { return nil }
        return queryItems.first(where: { $0.name.lowercased() == param.lowercased() })?.value
    }
    
    func absoluteStringByTrimmingQuery() -> String? {
        if var urlcomponents = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            urlcomponents.query = nil
            return urlcomponents.string
        }
        return nil
    }
}
