//
//  Constants.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import UIKit

class Constants: NSObject {
    
    static var showTerms: Bool = true
    static var countNotification: Int = 0
    static var firstLogin: Bool = false
    static var isLoginScreen: Bool = false
    static var showGuideQR: Bool = true
    static var showGuide: Bool = false
    static var topPadding: CGFloat = 0.0
    static var flagFutureRace: Bool = false
    static var needToCheckFutureRace: Bool = false //Only check first time and hours >= 19
    static var cacheSysdate: Date? //Use for raceView. When change date in setting app
    static var lastLoginEmail: String?
    static var incomingNotification: FIRNotificationModel? //Clear data after push screen
    static let hScreenSE3: CGFloat = 667.0
    static let hScreenSE1: CGFloat = 568.0
    static var numberCnameWin5: String = ""
    static var lastVersionCheck: String = ""
    static let localeIdentifier = "ja_JP"
    static var lastController: String?
    static let facebookShare = ["localhost/share.php", "localhost/sharer/sharer.php"]
    static let lineShare = ["social-plugins.line.me/lineit/share", "line.me/R/share", "https://lin.ee", "line://"]
    static let twitterShare = ["http://x.com", "https://x.com", "https://twitter.com", "http://twitter.com"]
    static var displayDefaultPreferredSetting: Bool = true
    static var allowSearchHorsesRunningThisWeek = false
    static var halfRadius = 0.5
    
    class System {
        static var fcmToken: String = ""
        static let tknNum: Int = 1 //1: iOS, 2: Android
        static let durationLoginAnimate = 1.0
        static let durationBackAnimate = 0.5
        static let timeoutIntervalWebView = 30.0 //seconds
        static let systemVersion = UIDevice.current.systemVersion
        static let systemVerionUnderscore = systemVersion.replace(target: ".", withString: "_")
        static let userAgentIMTA = "IMTAPP Mozilla/5.0 (iPhone; CPU iPhone OS \(systemVerionUnderscore) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5 Mobile/15E148 Safari/604.1"
        static let userAgentNoDeviceInfo = "IMTAPP"
        static let userAgentMobile = "Mobile"
        static let refererWebView = "localhost"
        static let delayAPI = 8.0
        static let delayAPILV2 = 10.0
        static let hourGetFutureRace = 19
        static let legalAgeToJoin = 20
        static let delayCamera = 0.25
        static let delayToast = 0.05
        static let spaceYAllowWhenSwipe = 50.0
        static let touchXAllowWhenSwipe = 50.0
        static let swipeRatio = 0.5 //Maximum is 1
        static let swipeToEndRatio = 0.25
        static let ratioIsAllowedToDragWhenTouchedForTheFirstTime = 0.05
        static let fromYear = 1900
        static let toYear = Date().getYear()
        static let saltKey = {
            guard let strValue = Utils.infoDict["SAFT_KEY"] as? String else {
                fatalError("SAFT_KEY is not found")
            }
            return strValue
        }()
        static let limitAddFavorite = 30
        static let limitNumberOfItem = 50
        static let borderWidthOfIMTBorderButton = 3.0
        static let enableEncrypt: Bool = false
    }
    
    class IconConfigure {
        static let sizeTab = CGSize(width: 28, height: 28)
    }
    
    class NumItemConfigure {
        static let raceDate = 3
        static let raceArea = 3
        static let topic = 4
        static let menuWidget = 2
        static let serviceWidget = 3
    }
    
    class HeightConfigure {
        static let smallFooterLine: CGFloat = Utils.scaleWithHeight(0.5)
        static let serviceCell: CGFloat = Utils.scaleWithHeight(80.0)
        static let spaceService: CGFloat = Utils.scaleWithHeight(0.0)
        static let icon: CGFloat = Utils.scaleWithHeight(64.0)
    }
    
    class SystemConfigure {
        static let delayCamera: Double = 0.5
    }
    
    class RadiusConfigure {
        static let small = 4.0
        static let medium = 8.0
        static let big = 24.0
    }
    
    class LineSpaceText {
        static let small: CGFloat = Utils.scaleWithHeight(5.0)
        static let medium: CGFloat = Utils.scaleWithHeight(10.0)
        static let large: CGFloat = Utils.scaleWithHeight(20.0)
    }
    
    class BottomSheetConfigure {
        static let ratioMainScreen = 0.66
        static let ratioMainScreenSE3 = 0.8
        static let ratioMainScreenSE1 = 0.98
    }
    
    class HeightRectangeCell {
        static let menu = Utils.scaleWithHeight(96.67)
    }
    
    class HeightCircleCell {
        static let service = Utils.smallScreen() ? Utils.scaleWithHeight(110) : Utils.scaleWithHeight(85.0)
    }
}

