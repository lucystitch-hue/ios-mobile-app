//
//  ResponseRaceInfo.swift
//  IMT-iOS
//
//  Created by dev on 22/03/2023.
//

import UIKit
import SwiftyJSON

struct RaceModel: JSONModel {
    var no: String!
    var name: String!
    var mark: String?
    var starttime: String!
    var cource: String!
    var distance: String!
    var count: String!
    var result: Bool
    var resultUrl: String?
    var odds: Bool
    var oddsUrl: String?
    var video: Bool
    var linkUrl: String?
    var videoUrl: String?
    
    var className: String?
    
    init(json: JSON) {
        self.no = json["no"].string
        self.name = json["name"].string
        self.mark = json["mark"].string
        self.starttime = json["starttime"].string
        self.cource = json["cource"].string
        self.distance = json["distance"].string
        self.count = json["count"].string
        self.result = json["result"].boolValue
        self.resultUrl = json["resultUrl"].string
        self.odds = json["odds"].boolValue
        self.oddsUrl = json["oddsUrl"].string
        self.video = json["video"].boolValue
        self.videoUrl = json["videoUrl"].string
        self.linkUrl = json["linkUrl"].string
    }
    
    func imageRaceResult() -> UIImage {
        return result ? .raceComplete : .raceCurrent
    }
    
    func imageRaceResultVideo() -> UIImage {
        return result ? .raceCompleteVideo : .raceCurrentVideo
    }
    
    func descriptionAttribute() -> NSAttributedString {
        let attrs = NSMutableAttributedString()
        let fontSize: CGFloat = 11.0
        
        let attrCourse = NSAttributedString(string: "\(self.cource ?? "") ", attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(fontSize)])
        
        let attrDistance = NSAttributedString(string: "\(self.distance ?? "")m ", attributes: [NSAttributedString.Key.font: UIFont.appFontNumberBoldSize(fontSize)])
        
        let prefixCount = String(count.drop(while: { $0 == "0" }))
        let attrNumber = NSAttributedString(string: "\(prefixCount)", attributes: [NSAttributedString.Key.font: UIFont.appFontNumberBoldSize(fontSize)])
        let attrUnit = NSAttributedString(string: "頭", attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(fontSize)])
        
        attrs.append(attrCourse)
        attrs.append(attrDistance)
        attrs.append(attrNumber)
        attrs.append(attrUnit)
        
        return attrs
    }
    
    func getNameAndGrade() -> (name: String, grade: String?) {
        
        if let grade = getGrade(name) {
            let name = name.replacingOccurrences(of: grade.rawValue, with: "", options: [.regularExpression, .caseInsensitive]).trimmingCharacters(in: .whitespaces)
            return (name, grade.toString())
        } else {
            return (name, nil)
        }
    }
    
    func getOddsTitle() -> String {
        return result ? .RaceCellString.result : .RaceCellString.odds
    }
    
    func getBackgroundColorVideo() -> UIColor {
        return video ? .darkCharcoal : .quickSilver
    }
    
    func getBackgroundColorOdds() -> UIColor {
        let allow = result || odds
        return allow ? .darkCharcoal : .quickSilver
    }
    
    private func getGrade(_ value: String) -> GradeName? {
        var length = 0
        var grade: GradeName?
        
        for i in 0..<GradeName.allCases.count {
            let iGrade = GradeName.allCases[i]
            let lGrade = iGrade.rawValue.count
            let contain = value.contains(iGrade.rawValue) && iGrade != .all && lGrade >= length
            if (contain) {
                grade = iGrade
                length = lGrade
            }
        }
        
        return grade
    }
}

struct RaceInfoModel: JSONModel {
    var date: String!
    var place: String!
    var coller: String!
    var races: [RaceModel]!
    
    init(json: JSON) {
        self.date = json["date"].string
        self.place = json["place"].string
        self.coller = json["coller"].string
        self.races = json["races"].arrayValue.map({ RaceModel(json: $0) })
    }
}

struct ResponseRaceInfo: BaseResponse {
    typealias R = ResponseRaceInfo
    
    var success: Bool
    var message: String?
    var raceinfo: [RaceInfoModel]!
}
