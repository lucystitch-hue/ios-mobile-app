//
//  TopicModel.swift
//  IMT-iOS
//
//  Created by dev on 21/03/2023.
//


import UIKit
import SwiftyJSON

struct TopicModel: JSONModel {
    
    var place: String!
    var date: String?
    var grade: String?
    var gradeName: String?
    var name: String!
    var coller: String!
    
    init(json: JSON) {
        self.place = json["place"].string
        self.date = json["date"].string
        self.grade = json["grade"].string
        self.gradeName = json["gradeName"].string
        self.name = json["name"].string
        self.coller = json["coller"].string
    }
    
    init(place: String, date: String?, grade: String?, gradeName: String, name: String, coller: String?) {
        self.place = place
        self.date = date
        self.grade = grade
        self.gradeName = gradeName
        self.name = name
        self.coller = coller
    }
    
    func placeColor() -> UIColor? {
        return RaceColler(rawValue: coller)?.tabPlaceColor() ?? .darkCharcoal
    }
    
    func gradeColor() -> UIColor? {
        if let color = GradeName(rawValue: self.gradeName ?? "")?.color() {
            return color
        } else {
            guard let _ = self.gradeName else { return nil }
            return GradeName.L.color() //default
        }
    }
    
    func dateToString() -> String {
        return date?.toDate()?.toString(format: .IMTM_D_EEE) ?? ""
    }
    
    func dateToAttribute() -> NSAttributedString? {
        return (date?.toDate()?.toAttributeIMTShort())
    }
    
    func gradeToString() -> String {
        return self.grade ?? ""
    }
    
    func gradeNameToString() -> String {
        if let gradeName = gradeName,
           let value = GradeName(rawValue: gradeName)?.toString() {
            return value
        } else {
            return gradeName ?? ""
        }
    }
}

struct ResponseTopic: BaseResponse {
    typealias R = ResponseTopic
    
    var success: Bool
    var message: String?
}
