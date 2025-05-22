//
//  ResponseNews.swift
//  IMT-iOS
//
//  Created by dev on 22/03/2023.
//

import UIKit
import SWXMLHash

struct NewModel: Codable {
    var date: String!
    var content: String!
    var remark: String!
    
    var title: String!
    var link: String!
    var description: String?
    
    init(xml: XMLIndexer) {
        self.date = xml["dc:date"].element?.text
        self.title = xml["title"].element?.text
        self.link = xml["link"].element?.text
        self.description = xml["description"].element?.text
    }
    
    func dateToString() -> String {
        let strPrefix = String(date.prefix(10))
        let valueDate = strPrefix.toDate()
        
        let year = valueDate?.getYear() ?? 0
        let month = valueDate?.getMonth() ?? 0
        let day = valueDate?.getDay() ?? 0
        
        return "\(year)\(String.placeholder.year)\(month)\(String.placeholder.month)\(day)\(String.placeholder.day)"
    }
}

struct ResponseNews: BaseResponse {
    
    typealias R = ResponseNews
    var success: Bool
    var message: String?
    var news: [NewModel]!
}
