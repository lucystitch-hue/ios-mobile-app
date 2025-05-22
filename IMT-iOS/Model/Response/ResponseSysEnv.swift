//
//  ResponseSysEnv.swift
//  IMT-iOS
//
//  Created by dev on 09/08/2023.
//

import Foundation
import SwiftyJSON

struct Aysy01: JSONModel {
    var sys01keycode: String
    var sys01name: String
    var sys01value: String?
    var sys01memo: String?
    
    init(json: JSON) {
        self.sys01keycode = json["sys01keycode"].stringValue
        self.sys01name = json["sys01name"].stringValue
        self.sys01value = json["sys01value"].string
        self.sys01memo = json["sys01memo"].string
    }
}

struct Aysy02: JSONModel {
    var id: String
    var caption: String
    var title: String
    var info: String
    var hyojiStart: String
    var hyojiEnd: String
    var yukoFlg: String

    init(json: JSON) {
        self.id = json["id"].stringValue
        self.caption = json["caption"].stringValue
        self.title = json["title"].stringValue
        self.info = json["info"].stringValue
        self.hyojiStart = json["hyojiStart"].stringValue
        self.hyojiEnd = json["hyojiEnd"].stringValue
        self.yukoFlg = json["yukoFlg"].stringValue
    }
}

struct ResponseSysEnv: JSONModel {
    var aysy01: [Aysy01]?
    var aysy02: [Aysy02]?
    
    init(json: JSON) {
        self.aysy01 = json["aysy01"].array?.map({ return Aysy01(json: $0)})
        self.aysy02 = json["aysy02"].array?.map({ return Aysy02(json: $0)})
    }
    
    func convertToWaringViewConfiguration() -> WarningViewConfiguration? {
        guard let aysy01 = aysy01 else { return nil }
        
        var titleColor: String?
        var captionColor: String?
        var captionBgColor: String?
        var forceUpdateValue: String?
        var iOSVerLastUpdate: String?
        
        for i in 0..<aysy01.count {
            let item = aysy01[i]
            
            let code = item.sys01keycode
            let value = item.sys01value
            let type = SysEnvCode(rawValue: code)
            
            switch type {
            case .titleColorCode:
                titleColor = value
                break
            case .captionColorCode:
                captionColor = value
                break
            case .captionBgColorCode:
                captionBgColor = value
                break
            case .forceUpdateCode:
                forceUpdateValue = value
                break
            case .iOSVerLastUpdateCode:
                iOSVerLastUpdate = value
                break
            default:
                break
            }
        }
        
        //TODO: If value is nil ,It won't show warning at home screen
        guard let _ = showNoticeIfNeed(forceType: forceUpdateValue, newVersion: iOSVerLastUpdate) else { return nil }
        
        guard let textInfo = aysy02?.first else { return nil }
        
        var configuration = WarningViewConfiguration()
        configuration.title = textInfo.title
        
        if let titleColor = titleColor {
            configuration.titleColor = titleColor.toRGB() ?? .internationalOrange
        }
        
        configuration.caption = textInfo.caption
        
        if let captionColor = captionColor {
            configuration.captionColor = captionColor.toRGB() ?? .white
        }
        
        if let captionBgColor = captionBgColor {
            configuration.captionBgColor = captionBgColor.toRGB() ?? .internationalOrange
        }
        
        configuration.content = textInfo.info
        
        return configuration
    }
    
    func configuringSurveyQuestionList() -> Bool? {
        guard let aysy01 = aysy01 else { return nil }
        
        if aysy01.contains(where: { $0.sys01keycode == SysEnvCode.isEnableBtnCode.rawValue && $0.sys01value == "1" }) {
            return true
        }
        
        return false
    }
    
    func getValueFromAysy01(key: SysEnvCode) -> String? {
        guard let aysy01 = aysy01 else { return nil }
        
        let iValue = aysy01.first(where: { $0.sys01keycode == key.rawValue })
        return iValue?.sys01value
    }
}

//MARK: Private
extension ResponseSysEnv {
    func showNoticeIfNeed(forceType: String?, newVersion: String?) -> Bool? {
        guard let forceType = forceType else { return nil }
        guard let type = WarningTopicType(rawValue: forceType) else { return nil }
        guard let iAysy02 = aysy02?.first else { return nil }
    
        if(iAysy02.yukoFlg == "1" && type == .show) {
            return visiable(iAysy02)
        }
        
        return nil
    }
    
    func visiable(_ textInfo: Aysy02) -> Bool? {
        guard let hyojiStart = textInfo.hyojiStart.toDate(.IMTYYYYMMddhhMM) else { return nil }
        guard let hyojiEnd = textInfo.hyojiEnd.toDate(.IMTYYYYMMddhhMM) else { return nil }
        let today = Date.japanDate
        
        if(today >= hyojiStart && today <= hyojiEnd) {
            return true
        }
        
        return nil
    }
}
