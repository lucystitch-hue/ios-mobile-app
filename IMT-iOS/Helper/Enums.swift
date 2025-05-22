//
//  Enums.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation
import UIKit
import CryptoKit

enum NotificationName: String {
    case showErrorSystem = "showErrorSystem"
    case didLoginSuccessfully = "didLoginSuccessfully"
    case completeRegisterStep = "completeRegisterStep"
    case reloadScreen = "reloadScreen"
    case stateApp = "stateApp"
    case markAllSeen = "markAllSeen"
    case callAPIMe = "callAPIMe"
    case reloadMe = "reloadMe"
    case onCountNotification = "onCountNotification"
    case openScreenFromNotify = "openScreenFromNotify"
    case openTab = "openTab"
    case openTabAndMessage = "openTabAndMessage"
    case openTabToRoot = "openTabToRoot"
    case sendLaunch = "sendLaunch"
    case hideGuide = "hideGuide"
    case killScroll = "killScroll"
    case receivedFCMToken = "recieveFCMToken"
}

enum Class: String {
    case GI = "g1"
    case GII = "g2"
    case GIII = "g3"
    
    func string() -> String {
        switch self {
        case .GI:
            return "GI"
        case .GII:
            return "GII"
        case .GIII:
            return "GIII"
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .GI:
            return .lapisLazuli
        case .GII:
            return .internationalOrange
        case .GIII:
            return .wageningenGreen
        }
    }
}

enum GradeName: String, CaseIterable {
    case GⅠ = "GⅠ"
    case GI = "GI"
    case JGI = "J・GI"
    case JG1 = "J・GⅠ"
    case Jpn1 = "JpnⅠ"
    case G1 = "G1"
    case GⅠⅠ = "GⅠⅠ"
    case GII = "GII"
    case GⅡ = "GⅡ"
    case JGⅡ = "J・GⅡ"
    case JG2 = "J・GII"
    case Jpn2 = "JpnII"
    case G2 = "G2"
    case GⅠⅠⅠ = "GⅠⅠⅠ"
    case GIII = "GIII"
    case GⅢ = "GⅢ"
    case JGⅢ = "J・GⅢ"
    case JG3 = "J・GIII"
    case Jpn3 = "JpnIII"
    case G3 = "G3"
    case L = "L"
    case graded = "Graded Stakes"
    case all = "All"
    case null = ""
    case others = "Others"
    
    func color() -> UIColor? {
        switch self {
        case .GⅠ, .GI, .JGI, .JG1, .Jpn1, .G1:
            return .lapisLazuli
        case .GⅠⅠ, .GII, .GⅡ, .JGⅡ, .JG2, .Jpn2, .G2:
            return .internationalOrange
        case .GⅠⅠⅠ, .GIII, .GⅢ, .JGⅢ, .JG3, .Jpn3, .G3:
            return .wageningenGreen
        case .L, .Graded Stakes:
            return .deepSpaceSparkle
        default:
            return nil
        }
    }
    
    func colorRace() -> UIColor? {
        switch self {
        case .GⅠ, .GI, .JGI, .JG1, .Jpn1, .G1:
            return .lapisLazuli
        case .GⅠⅠ, .GII, .GⅡ, .JGⅡ, .JG2, .Jpn2, .G2:
            return .internationalOrange
        case .GⅠⅠⅠ, .GIII, .GⅢ, .JGⅢ, .JG3, .Jpn3, .G3:
            return .wageningenGreen
        case .L:
            return .deepSpaceSparkle
        default:
            return nil
        }
    }
    
    func raws() -> [GradeName] {
        switch self {
        case .GI, .GⅠ, .JGI, .JG1, .Jpn1, .G1:
            return [.GI, .GⅠ, .JGI, .JG1, .Jpn1, .G1]
        case .GII, .GⅠⅠ, .GⅡ, .JGⅡ, .JG2, .Jpn2, .G2:
            return [.GII, .GII, .GⅡ, .JGⅡ, .JG2, .Jpn2, .G2]
        case .GIII, .GⅠⅠⅠ, .GⅢ, .JGⅢ, .JG3, .Jpn3, .G3:
            return [.GIII, .GⅠⅠⅠ, .GⅢ, .JGⅢ, .JG3, .Jpn3, .G3]
        case .all:
            return [.GI, .GⅠ, .JGI, .JG1, .Jpn1, .G1, .GII, .GII, .GⅡ, .JGⅡ, .JG2, .Jpn2, .G2, .GIII, .GⅠⅠⅠ, .GⅢ, .JGⅢ, .JG3, .Jpn3, .G3, .L, .Graded Stakes, .null]
        case .others:
            return [ .L, .Graded Stakes, .null]
        default:
            return []
        }
    }
    
    func toString() -> String {
        switch self {
        case .GI, .GⅠ:
            return "GI"
        case .G1 :
            return "G1"
        case .GII, .GⅠⅠ, .GⅡ:
            return "GII"
        case .G2 :
            return "G2"
        case .GIII, .GⅠⅠⅠ, .GⅢ:
            return "GIII"
        case .G3 :
            return "G3"
        default:
            return rawValue
        }
    }
}

enum Place: String {
    case Tokyo = "Tokyo"
    case Hanshin = "Hanshin"
    case Kokura = "Kokura"
    case Nakayama = "Nakayama"
    case Fukushima = "Fukushima"
    case Abroad = "Overseas"

    
    func color() -> UIColor {
        switch self {
        case .Tokyo:
            return .tropicalRainForest //#0B3599
        case .Hanshin:
            return .internationalOrange
        case .Kokura:
            return .lapisLazuli
        case .Nakayama:
            return .tropicalRainForest
        case .Fukushima:
            return .lapisLazuli
        case .Abroad:
            return .scarlet
        }
    }
}

enum RaceResultType: Int {
    case current = 1
    case complete = 2
    
    func imageResult() -> UIImage {
        switch self {
        case .current:
            return .raceCurrent
        case .complete:
            return .raceComplete
        }
    }
    
    func imageResultVideo() -> UIImage {
        switch self {
        case .current:
            return .raceCurrentVideo
        case .complete:
            return .raceCompleteVideo
        }
    }
}

enum Service {
    
    case order
    case club
    case categoryKeiba
    case guide
    case requiredVote
    case soku
    case youtube
    case beginerGuide
    
    enum TypeUI: Int {
        case view = 1
        case image = 2
    }
    
    func typeUI() -> TypeUI {
        switch self {
        case .order:
            return .view
        case .club, .categoryKeiba, .guide, .requiredVote, .soku, .youtube, .beginerGuide:
            return .image
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .order:
            return nil
        case .club:
            return .bg_club
        case .categoryKeiba:
            return .bg_category_keiba
        case .guide:
            return .bg_guide
        case .requiredVote:
            return .bg_require_vote
        case .soku:
            return .bg_soku
        case .youtube:
            return .bg_youtube
        case .beginerGuide:
            return .bg_beginerGuide
        }
    }
    
    func log() {
        var logValues: FlyersActionLog?
        
        switch self {
        case .soku:
            logValues = .newOnlineVotingRegistration
            break
        case .beginerGuide:
            logValues = .firseHorseRacingGuide
        default:
            break
        }
        
        guard let logValues = logValues else { return }
        Utils.logActionClick(logValues)
    }
}

enum TransactionLink {
    
    case club
    case qrCode
    case keibaCatalog
    case racecourseInformation
    case votingNote
    case votingNoteRedirect
    case allNew
    case featuredRacesOfTheWeek
    case featuredRacesOverseas
    case bettingTickets20YearsOld
    case amblingAddictionMeasures
    case contentLanding
    case ipat
    case nIpat
    case directPat
    case skipLoginDirect
    case weather
    
    case raceResultSearch
    case raceHorseSearch
    case searchHorsesRunningThisWeek
    case jockeyDirectory
    case trainerDirectory
    case reading
    case racecourseInfo
    case refundList
    case win5
    case specialRace
    case racingCalendar
    case papaInfo
    case almostAchievedRecord
    case newJockeyData
    case stallionReading
    case horseRacingTicketRule
    case whatIsWin5
       
    case answerTheSurvey
    case soKanyu
    case pageFAQ
    case mailFAQ
    case terms
    case privacy
    case live

    case horseRaceInfoYoutube
    case horseRaceInfoFacebook
    case horseRaceInfoInstagram
    case horseRaceInfoIMTFun
    case horseRaceInfoIMTFunEventList
    case horseRaceInfoIMTWellcome
    case horseRaceInfoIMTEvent
    case horseRaceInfoIMTVan
    case horseRaceInfoGCWeb
    case horseRaceInfoTurfy
    case horseRaceinfoTakeRV
    case horseRaceInfoTwitter
    case horseRaceInfoEvent70th
    case mapSapporo
    case picMapAll
    case faqMailExtend
    case faqMail
    case faqIMTMail
    case soku // link same soKanyu
    case subscriberNumberEtc
    case appcp
    case worldracing
    case windsInformation
    case raceCalendar
    case umaca
    case forgetUmacaPolicy
    case myApp
    case changeModel
    case jockeyReading
    case trainerReading
    case jockeyDetail(_ cname: String)
    case stallionDetail(_ cname: String)
    
    init?(rawValue: String) {
        switch rawValue {
        case TransactionLink.club.url, TransactionLink.club.rawValue:
            self = .club
        case TransactionLink.qrCode.url, TransactionLink.qrCode.rawValue:
            self = .qrCode
        case TransactionLink.keibaCatalog.url, TransactionLink.keibaCatalog.rawValue:
            self = .keibaCatalog
        case TransactionLink.racecourseInformation.url, TransactionLink.racecourseInformation.rawValue:
            self = .racecourseInformation
        case TransactionLink.votingNote.url, TransactionLink.votingNote.rawValue:
            self = .votingNote
        case TransactionLink.votingNoteRedirect.url, TransactionLink.votingNoteRedirect.rawValue:
            self = .votingNoteRedirect
        case TransactionLink.allNew.url, TransactionLink.allNew.rawValue:
            self = .allNew
        case TransactionLink.featuredRacesOfTheWeek.url, TransactionLink.featuredRacesOfTheWeek.rawValue:
            self = .featuredRacesOfTheWeek
        case TransactionLink.featuredRacesOverseas.url, TransactionLink.featuredRacesOverseas.rawValue:
            self = .featuredRacesOverseas
        case TransactionLink.bettingTickets20YearsOld.url, TransactionLink.bettingTickets20YearsOld.rawValue:
            self = .bettingTickets20YearsOld
        case TransactionLink.amblingAddictionMeasures.url, TransactionLink.amblingAddictionMeasures.rawValue:
            self = .amblingAddictionMeasures
        case TransactionLink.contentLanding.url, TransactionLink.contentLanding.rawValue:
            self = .contentLanding
        case TransactionLink.ipat.url, TransactionLink.ipat.rawValue:
            self = .ipat
        case TransactionLink.nIpat.url, TransactionLink.nIpat.rawValue:
            self = .nIpat
        case TransactionLink.directPat.url, TransactionLink.directPat.rawValue:
            self = .directPat
        case TransactionLink.skipLoginDirect.url, TransactionLink.skipLoginDirect.rawValue:
            self = .skipLoginDirect
        case TransactionLink.weather.url, TransactionLink.weather.rawValue:
            self = .weather
        case TransactionLink.raceResultSearch.url, TransactionLink.raceResultSearch.rawValue:
            self = .raceResultSearch
        case TransactionLink.raceHorseSearch.url, TransactionLink.raceHorseSearch.rawValue:
            self = .raceHorseSearch
        case TransactionLink.searchHorsesRunningThisWeek.url, TransactionLink.searchHorsesRunningThisWeek.rawValue:
            self = .searchHorsesRunningThisWeek
        case TransactionLink.jockeyDirectory.url, TransactionLink.jockeyDirectory.rawValue:
            self = .jockeyDirectory
        case TransactionLink.trainerDirectory.url, TransactionLink.trainerDirectory.rawValue:
            self = .trainerDirectory
        case TransactionLink.reading.url, TransactionLink.reading.rawValue:
            self = .reading
        case TransactionLink.racecourseInfo.url, TransactionLink.racecourseInfo.rawValue:
            self = .racecourseInfo
        case TransactionLink.refundList.url, TransactionLink.refundList.rawValue:
            self = .refundList
        case TransactionLink.win5.url, TransactionLink.win5.rawValue:
            self = .win5
        case TransactionLink.specialRace.url, TransactionLink.specialRace.rawValue:
            self = .specialRace
        case TransactionLink.racingCalendar.url, TransactionLink.racingCalendar.rawValue:
            self = .racingCalendar
        case TransactionLink.papaInfo.url, TransactionLink.papaInfo.rawValue:
            self = .papaInfo
        case TransactionLink.almostAchievedRecord.url, TransactionLink.almostAchievedRecord.rawValue:
            self = .almostAchievedRecord
        case TransactionLink.newJockeyData.url, TransactionLink.newJockeyData.rawValue:
            self = .newJockeyData
        case TransactionLink.stallionReading.url, TransactionLink.stallionReading.rawValue:
            self = .stallionReading
        case TransactionLink.horseRacingTicketRule.url, TransactionLink.horseRacingTicketRule.rawValue:
            self = .horseRacingTicketRule
        case TransactionLink.whatIsWin5.url, TransactionLink.whatIsWin5.rawValue:
            self = .whatIsWin5
        case TransactionLink.answerTheSurvey.url, TransactionLink.answerTheSurvey.rawValue:
            self = .answerTheSurvey
        case TransactionLink.soKanyu.url, TransactionLink.soKanyu.rawValue:
            self = .soKanyu
        case TransactionLink.pageFAQ.url, TransactionLink.pageFAQ.rawValue:
            self = .pageFAQ
        case TransactionLink.mailFAQ.url, TransactionLink.mailFAQ.rawValue:
            self = .mailFAQ
        case TransactionLink.terms.url, TransactionLink.terms.rawValue:
            self = .terms
        case TransactionLink.privacy.url, TransactionLink.privacy.rawValue:
            self = .privacy
        case TransactionLink.live.url, TransactionLink.live.rawValue:
            self = .live
        case TransactionLink.horseRaceInfoYoutube.url, TransactionLink.horseRaceInfoYoutube.rawValue:
            self = .horseRaceInfoYoutube
        case TransactionLink.horseRaceInfoFacebook.url, TransactionLink.horseRaceInfoFacebook.rawValue:
            self = .horseRaceInfoFacebook
        case TransactionLink.horseRaceInfoInstagram.url, TransactionLink.horseRaceInfoInstagram.rawValue:
            self = .horseRaceInfoInstagram
        case TransactionLink.horseRaceInfoIMTFun.url, TransactionLink.horseRaceInfoIMTFun.rawValue:
            self = .horseRaceInfoIMTFun
        case TransactionLink.horseRaceInfoIMTFunEventList.url, TransactionLink.horseRaceInfoIMTFunEventList.rawValue:
            self = .horseRaceInfoIMTFunEventList
        case TransactionLink.horseRaceInfoIMTWellcome.url, TransactionLink.horseRaceInfoIMTWellcome.rawValue:
            self = .horseRaceInfoIMTWellcome
        case TransactionLink.horseRaceInfoIMTEvent.url, TransactionLink.horseRaceInfoIMTEvent.rawValue:
            self = .horseRaceInfoIMTEvent
        case TransactionLink.horseRaceInfoIMTVan.url, TransactionLink.horseRaceInfoIMTVan.rawValue:
            self = .horseRaceInfoIMTVan
        case TransactionLink.horseRaceInfoGCWeb.url, TransactionLink.horseRaceInfoGCWeb.rawValue:
            self = .horseRaceInfoGCWeb
        case TransactionLink.horseRaceInfoTurfy.url, TransactionLink.horseRaceInfoTurfy.rawValue:
            self = .horseRaceInfoTurfy
        case TransactionLink.horseRaceinfoTakeRV.url, TransactionLink.horseRaceinfoTakeRV.rawValue:
            self = .horseRaceinfoTakeRV
        case TransactionLink.horseRaceInfoTwitter.url, TransactionLink.horseRaceInfoTwitter.rawValue:
            self = .horseRaceInfoTwitter
        case TransactionLink.horseRaceInfoEvent70th.url, TransactionLink.horseRaceInfoEvent70th.rawValue:
            self = .mapSapporo
        case TransactionLink.mapSapporo.url, TransactionLink.mapSapporo.rawValue:
            self = .mapSapporo
        case TransactionLink.picMapAll.url, TransactionLink.picMapAll.rawValue:
            self = .picMapAll
        case TransactionLink.faqMailExtend.url, TransactionLink.faqMailExtend.rawValue:
            self = .faqMailExtend
        case TransactionLink.faqMail.url, TransactionLink.faqMail.rawValue:
            self = .faqMail
        case TransactionLink.faqIMTMail.url, TransactionLink.faqIMTMail.rawValue:
            self = .faqIMTMail
        case TransactionLink.soku.url, TransactionLink.soku.rawValue:
            self = .soku
        case TransactionLink.subscriberNumberEtc.url, TransactionLink.subscriberNumberEtc.rawValue:
            self = .subscriberNumberEtc
        case TransactionLink.appcp.url, TransactionLink.appcp.rawValue:
            self = .appcp
        case TransactionLink.worldracing.url, TransactionLink.worldracing.rawValue:
            self = .worldracing
        case TransactionLink.windsInformation.url, TransactionLink.windsInformation.rawValue:
            self = .windsInformation
        case TransactionLink.raceCalendar.url, TransactionLink.raceCalendar.rawValue:
            self = .raceCalendar
        case TransactionLink.umaca.url, TransactionLink.umaca.rawValue:
            self = .umaca
        case TransactionLink.forgetUmacaPolicy.url, TransactionLink.forgetUmacaPolicy.rawValue:
            self = .forgetUmacaPolicy
        case TransactionLink.myApp.url, TransactionLink.myApp.rawValue:
            self = .myApp
        case TransactionLink.changeModel.url, TransactionLink.changeModel.rawValue:
            self = .changeModel
        case TransactionLink.jockeyReading.url, TransactionLink.jockeyReading.rawValue:
            self = .jockeyReading
        case TransactionLink.trainerReading.url, TransactionLink.trainerReading.rawValue:
            self = .trainerReading
        default:
            if let url = URL(string: rawValue) {
                if let cname = url.queryStringParameter(param: "cname") {
                    switch url.absoluteString.replace(target: "CNAME", withString: "cname") {
                    case TransactionLink.jockeyDetail(cname).rawValue:
                        self = .jockeyDetail(cname)
                    case TransactionLink.stallionDetail(cname).rawValue:
                        self = .stallionDetail(cname)
                    default:
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
    
    var url: String {
        let domain = NetworkManager.domain
        switch self {
        case .club:
            return "localhost"
        case .qrCode:
            return "localhost"
        case .keibaCatalog:
            return "localhost"
        case .racecourseInformation:
            return "localhost"
        case .votingNote:
            return "localhost"
        case .votingNoteRedirect:
            return "localhost"
        case .allNew:
            return "localhost"
        case .featuredRacesOfTheWeek:
            return "localhost"
        case .featuredRacesOverseas:
            return "localhost"
        case .bettingTickets20YearsOld:
            return "localhost"
        case .amblingAddictionMeasures:
            return "localhost"
        case .contentLanding:
            return "localhost"
        case .ipat:
            return "localhost"
        case .nIpat:
            return "localhost"
        case .directPat:
            return "localhost"
        case .skipLoginDirect:
            return "localhost"
        case .weather:
            return "localhost"
        case .raceResultSearch:
            return "localhost"
        case .raceHorseSearch:
            return "localhost"
        case .searchHorsesRunningThisWeek:
            return "localhost"
        case .jockeyDirectory:
            return "localhost"
        case .trainerDirectory:
            return "localhost"
        case .reading:
            return "localhost"
        case .racecourseInfo:
            return "localhost"
        case .refundList:
            return "localhost"
        case .win5:
            return "localhost"
        case .specialRace:
            return "localhost"
        case .racingCalendar:
            return "localhost"
        case .papaInfo:
            return "localhost"
        case .almostAchievedRecord:
            return "localhost"
        case .newJockeyData:
            return "localhost"
        case .stallionReading:
            return "localhost"
        case .horseRacingTicketRule:
            return "localhost"
        case .whatIsWin5:
            return "localhost"
        case .answerTheSurvey:
            return "localhost"
        case .soKanyu:
            return "localhost"
        case .pageFAQ:
            return "localhost"
        case .mailFAQ:
            return "localhost"
        case .terms:
            return "localhost"
        case .privacy:
            return "localhost"
        case .live:
            return "localhost"

        case .horseRaceInfoYoutube:
            return "localhost"
        case .horseRaceInfoFacebook:
            return "localhost"
        case .horseRaceInfoInstagram:
            return "localhost"
        case .horseRaceInfoIMTFun:
            return "localhost"
        case .horseRaceInfoIMTFunEventList:
            return "localhost"
        case .horseRaceInfoIMTWellcome:
            return "localhost"
        case .horseRaceInfoIMTEvent:
            return "localhost"
        case .horseRaceInfoIMTVan:
            return "localhost"
        case .horseRaceInfoGCWeb:
            return "localhost"
        case .horseRaceInfoTurfy:
            return "localhost"
        case .horseRaceinfoTakeRV:
            return "localhost"
        case .horseRaceInfoTwitter:
            return "localhost"
        case .horseRaceInfoEvent70th:
            return "localhost"
        case .mapSapporo:
            return "localhost"
        case .picMapAll:
            return "localhost"
        case .faqMailExtend:
            return "localhost"
        case .faqMail:
            return "localhost"
        case .faqIMTMail:
            return "localhost"
        case .soku:
            return "localhost"
        case .subscriberNumberEtc:
            return "localhost"
        case .appcp:
            return "localhost"
        case .worldracing:
            return "localhost"
        case .windsInformation:
            return "localhost"
        case .raceCalendar:
            return "localhost"
        case .umaca:
            return "localhost"
        case .forgetUmacaPolicy:
            return "localhost"
        case .myApp:
            return "localhost"
        case .changeModel:
            return "localhost"
        case .jockeyReading:
            return "localhost"
        case .trainerReading:
            return "localhost"
        case .jockeyDetail:
            return "localhost"
        case .stallionDetail:
            return "localhost"
        }
    }
    
    var rawValue: String {
        let url = self.url
        switch self {
        case .weather:
            return "\(url)?cname="
        case .raceResultSearch:
            return "\(url)?cname="
        case .raceHorseSearch:
            return "\(url)?cname="
        case .searchHorsesRunningThisWeek:
            return "\(url)?cname="
        case .jockeyDirectory:
            return "\(url)?cname="
        case .trainerDirectory:
            return "\(url)?cname="
        case .refundList:
            return "\(url)?cname="
        case .win5:
            return "\(url)?cname="
        case .specialRace:
            return "\(url)?cname="
        case .stallionReading:
            return "\(url)?cname="
        case .jockeyReading:
            return "\(url)?cname="
        case .trainerReading:
            return "\(url)?cname="
        case .jockeyDetail(let cname):
            return "\(url)?cname=\(cname)"
        case .stallionDetail(let cname):
            return "\(url)?cname=\(cname)"
        default:
            return url
        }
    }
    
    func characters() -> String {
        switch self {
        case .ipat:
            return "We are not accepting voting applications at this time"
        case .nIpat:
            return "Voting is currently closed."
        default:
            return ""
        }
    }
    
    func scripts() -> (input: String, event: String)? {
        switch self {
        case .club:
            let ipat = UserManager.share().getCurrentIpatSkipLogin()
            let userId = ipat?.siteUserId ?? ""
            let parNo = ipat?.parsNo ?? ""
            
            let iUserId = ""
            let iParNo = ""
            
            let input = iUserId + iParNo
            let event = "document.getElementsByName('login')[0].click();"
            
            return (input, event)
        case .votingNote:
            
            let ipat = UserManager.share().getCurrentIpatSkipLogin()
            let userId = ipat?.siteUserId ?? ""
            let pinCode = ipat?.pinCode ?? ""
            let parNo = ipat?.parsNo ?? ""
            
            let js = "document.getElementById('UID').value = \"\(userId)\";" +
            "document.getElementById('PWD').value = \"\(pinCode)\";" +
            "document.getElementById('PARS').value = \"\(parNo)\";" +
            "document.getElementsByName('UID')[0].value = \"\(userId)\";" +
            "document.getElementsByName('PWD')[0].value = \"\(pinCode)\";" +
            "document.getElementsByName('PARS')[0].value = \"\(parNo)\";"
            
            let input = js
            let event = "document.getElementsByName('P010Form')[0].submit();"
            
            return (input, event)
            
        case .nIpat:
            let ipat = UserManager.share().getCurrentIpatSkipLogin()
            let userId = ipat?.siteUserId ?? ""
            let pinCode = ipat?.pinCode ?? ""
            let parNo = ipat?.parsNo ?? ""
            
            let iUserId = "document.getElementById('userid').value = \"\(userId)\";"
            let iPassword = "document.getElementById('password').value = \"\(pinCode)\";"
            let iParNo = "document.getElementById('pars').value = \"\(parNo)\";"
            
            let input = iUserId + iPassword + iParNo
            let event = "document.getElementsByClassName('btnBrown')[0].getElementsByTagName('a')[0].onclick()"
           
            
            return (input, event)
        case .jockeyDirectory, .jockeyReading, .jockeyDetail:
            let input = """
            var title = document.getElementById('titleDiv').textContent;
            if (title === 'Jockey Information') {
                var text = document.querySelector('.linkBtn a').getAttribute('onclick').replace('return doAction(', '').slice(0, -2).replaceAll('\\'', '').replaceAll(' ', '').split(',');
                alert(text[1])
            }
            """
            
            return (input, "")
        default:
            return nil
        }
    }

    func externalLink(_ parameters: String) -> String? {
        let domain = NetworkManager.domainMain
        
        switch self {
        case .directPat:
            return "localhost\(parameters)"
        case .ipat:
            return "localhost\(parameters)"
        case .nIpat:
            return "localhost\(parameters)"
        case .umaca:
            return "localhost\(parameters)"
        default:
            return nil
        }
    }
    
    func hasRedirect() -> Bool {
        switch self {
        case .directPat, .nIpat, .ipat:
            return true
        default:
            return false
        }
    }
    
    func appName() -> String? {
        switch self {
        case .horseRaceInfoIMTWellcome:
            return "localhost"
        case .horseRaceInfoIMTEvent:
            return "localhost"
        case .horseRaceInfoIMTVan:
            return "localhost"
        case .horseRaceInfoFacebook:
            return "localhost"
        case .horseRaceInfoInstagram:
            return "localhost"
        case .horseRaceInfoTwitter:
            return "localhost"
        default:
            return nil
        }
    }
    
    func tryReload() -> Bool {
        switch self {
        case .reading, .votingNote:
            return false
        default:
            return true
        }
    }
}

extension TransactionLink: Equatable {
    static func ==(lhs: TransactionLink, rhs: TransactionLink) -> Bool {
        switch (lhs, rhs) {
        case (.club, .club): return true
        case (.qrCode, .qrCode): return true
        case (.keibaCatalog, .keibaCatalog): return true
        case (.racecourseInformation, .racecourseInformation): return true
        case (.votingNote, .votingNote): return true
        case (.votingNoteRedirect, .votingNoteRedirect): return true
        case (.allNew, .allNew): return true
        case (.featuredRacesOfTheWeek, .featuredRacesOfTheWeek): return true
        case (.featuredRacesOverseas, .featuredRacesOverseas): return true
        case (.bettingTickets20YearsOld, .bettingTickets20YearsOld): return true
        case (.amblingAddictionMeasures, .amblingAddictionMeasures): return true
        case (.contentLanding, .contentLanding): return true
        case (.ipat, .ipat): return true
        case (.nIpat, .nIpat): return true
        case (.directPat, .directPat): return true
        case (.skipLoginDirect, .skipLoginDirect): return true
        case (.weather, .weather): return true
        case (.raceResultSearch, .raceResultSearch): return true
        case (.raceHorseSearch, .raceHorseSearch): return true
        case (.searchHorsesRunningThisWeek, .searchHorsesRunningThisWeek): return true
        case (.jockeyDirectory, .jockeyDirectory): return true
        case (.trainerDirectory, .trainerDirectory): return true
        case (.reading, .reading): return true
        case (.racecourseInfo, .racecourseInfo): return true
        case (.refundList, .refundList): return true
        case (.win5, .win5): return true
        case (.specialRace, .specialRace): return true
        case (.racingCalendar, .racingCalendar): return true
        case (.papaInfo, .papaInfo): return true
        case (.almostAchievedRecord, .almostAchievedRecord): return true
        case (.newJockeyData, .newJockeyData): return true
        case (.stallionReading, .stallionReading): return true
        case (.horseRacingTicketRule, .horseRacingTicketRule): return true
        case (.whatIsWin5, .whatIsWin5): return true
        case (.answerTheSurvey, .answerTheSurvey): return true
        case (.soKanyu, .soKanyu): return true
        case (.pageFAQ, .pageFAQ): return true
        case (.mailFAQ, .mailFAQ): return true
        case (.terms, .terms): return true
        case (.privacy, .privacy): return true
        case (.live, .live): return true
        case (.horseRaceInfoYoutube, .horseRaceInfoYoutube): return true
        case (.horseRaceInfoFacebook, .horseRaceInfoFacebook): return true
        case (.horseRaceInfoInstagram, .horseRaceInfoInstagram): return true
        case (.horseRaceInfoIMTFun, .horseRaceInfoIMTFun): return true
        case (.horseRaceInfoIMTFunEventList, .horseRaceInfoIMTFunEventList): return true
        case (.horseRaceInfoIMTWellcome, .horseRaceInfoIMTWellcome): return true
        case (.horseRaceInfoIMTEvent, .horseRaceInfoIMTEvent): return true
        case (.horseRaceInfoIMTVan, .horseRaceInfoIMTVan): return true
        case (.horseRaceInfoGCWeb, .horseRaceInfoGCWeb): return true
        case (.horseRaceInfoTurfy, .horseRaceInfoTurfy): return true
        case (.horseRaceinfoTakeRV, .horseRaceinfoTakeRV): return true
        case (.horseRaceInfoTwitter, .horseRaceInfoTwitter): return true
        case (.horseRaceInfoEvent70th, .horseRaceInfoEvent70th): return true
        case (.mapSapporo, .mapSapporo): return true
        case (.picMapAll, .picMapAll): return true
        case (.faqMailExtend, .faqMailExtend): return true
        case (.faqMail, .faqMail): return true
        case (.faqIMTMail, .faqIMTMail): return true
        case (.soku, .soku): return true
        case (.subscriberNumberEtc, .subscriberNumberEtc): return true
        case (.appcp, .appcp): return true
        case (.worldracing, .worldracing): return true
        case (.windsInformation, .windsInformation): return true
        case (.raceCalendar, .raceCalendar): return true
        case (.umaca, .umaca): return true
        case (.forgetUmacaPolicy, .forgetUmacaPolicy): return true
        case (.myApp, .myApp): return true
        case (.changeModel, .changeModel): return true
        case (.jockeyReading, .jockeyReading): return true
        case (.trainerReading, .trainerReading): return true
        case (.jockeyDetail(let l), .jockeyDetail(let r)): return l == r
        case (.stallionDetail(let l), .stallionDetail(let r)): return l == r
        default: return false
        }
    }
}

enum SettingsNotificationSection: String, CaseIterable {
    case informationAboutTheRace = "Race Information"
    case noticeRegarRunHorsesSpecialSegistration = "Running Horse Information"
    case horseInformation = "Favorite Horse Information"
    case favoriteJockeyInformation = "Favorite Jockey Information"
    case advantageousInformationNews = "Notifications from IMT"
    case describe = "\nImportant notices regarding system maintenance and horse racing events will be sent to all users regardless of notification settings.\n"
    
    func font() -> UIFont {
        switch self {
        case .informationAboutTheRace,
                .noticeRegarRunHorsesSpecialSegistration,
                .advantageousInformationNews,
                .horseInformation,
                .favoriteJockeyInformation:
            return .appFontW6Size(15)
        case .describe:
            return .appFontW3Size(12)
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .informationAboutTheRace,
                .noticeRegarRunHorsesSpecialSegistration,
                .advantageousInformationNews,
                .horseInformation,
                .favoriteJockeyInformation:
            return 40.0
        case .describe:
            return 100.0
        }
    }
}

enum SettingsNotificationItem: String, CaseIterable {
    case cancellationOfRace = "torikeshi"
    case raceExclusion = "jogai"
    case jockeyChange = "kisyu"
    case startTimeChange = "jikoku"
    case changeTrackStatus = "baba"
    case weatherConditionChange = "weather"
    case giRaceHorseWeight = "umaWeight"
    case refundConfirmationGI = "harai"
    case specialRegistrationConfirmedGI = "utokubetsu"
    case confirmationOfRunningHorseGI = "mokuden"
    case frameOrderFixedGI = "yokuden"
    case highlightsTheWeek = "thisWeek"
    case deals = "news"
    case specialRaceRegistrationInformation = "favTokubetsu"
    case confirmedRaceInformation = "favYokuden"
    case raceResultInformation = "favHarai"
    case thisWeeksHorseRiding = "favJoc"
    case emergency = "mergency"
    case test = "test"
    
    func title() -> String? {
        switch self {
        case .cancellationOfRace:
            return "Race Cancellation"
        case .raceExclusion:
            return "Race Exclusion"
        case .jockeyChange:
            return "Jockey Change"
        case .startTimeChange:
            return "Start Time Change"
        case .changeTrackStatus:
            return "Track Condition Change"
        case .weatherConditionChange:
            return "Weather Change"
        case .giRaceHorseWeight:
            return "GI Horse Weight"
        case .refundConfirmationGI:
            return "GI Payout Confirmation"
        case .specialRegistrationConfirmedGI:
            return "GI Registered Horses"
        case .confirmationOfRunningHorseGI:
            return "GI Running Horses"
        case .frameOrderFixedGI:
            return "GI Post Position Finalized"
        case .highlightsTheWeek:
            return "This Week’s Highlights"
        case .deals:
            return "Special Offers"
        case .specialRaceRegistrationInformation:
            return "Special Race Registration Info"
        case .confirmedRaceInformation:
            return "Confirmed Race Information"
        case .raceResultInformation:
            return "Race Result Information"
        case .thisWeeksHorseRiding:
            return "This Week’s Mounted Horses"
        case .emergency:
            return nil
        case .test:
            return nil
        }
    }
    
    func topic() -> String {
        let role = UserManager.share().getRoleUser()
        let sufix = role == .test ? "TEST" : ""
        
        switch self {
        case .cancellationOfRace:
            return "PUSHTORIKESHI\(sufix)"
        case .raceExclusion:
            return "PUSHJOGAI\(sufix)"
        case .jockeyChange:
            return "PUSHKISYU\(sufix)"
        case .startTimeChange:
            return "PUSHJIKOKU\(sufix)"
        case .changeTrackStatus:
            return "PUSHBABA\(sufix)"
        case .weatherConditionChange:
            return "PUSHWEATHER\(sufix)"
        case .giRaceHorseWeight:
            return "PUSHUMAWEIGHT\(sufix)"
        case .refundConfirmationGI:
            return "PUSHHARAI"
        case .specialRegistrationConfirmedGI:
            return "PUSHUTOKUBETSU\(sufix)"
        case .confirmationOfRunningHorseGI:
            return "PUSHMOKUDEN\(sufix)"
        case .frameOrderFixedGI:
            return "PUSHYOKUDEN\(sufix)"
        case .highlightsTheWeek:
            return "PUSHTHISWEEK\(sufix)"
        case .deals:
            return "PUSHNEWS\(sufix)"
        case .specialRaceRegistrationInformation:
            return "PUSHFAVTOKUBETSU\(sufix)"
        case .confirmedRaceInformation:
            return "PUSHFAVYOKUDEN\(sufix)"
        case .raceResultInformation:
            return "PUSHFAVHARAI\(sufix)"
        case .thisWeeksHorseRiding:
            return "PUSHFAVJOC"
        case .emergency:
            return "EMERGENCYTOPIC"
        case .test:
            return "TESTUSER"
        }
    }
    
    func section() -> SettingsNotificationSection? {
        switch self {
        case .cancellationOfRace, .raceExclusion, .jockeyChange, .startTimeChange, .changeTrackStatus, .weatherConditionChange, .giRaceHorseWeight, .refundConfirmationGI :
            return .informationAboutTheRace
        case .specialRegistrationConfirmedGI, .confirmationOfRunningHorseGI, .frameOrderFixedGI, .highlightsTheWeek:
            return .noticeRegarRunHorsesSpecialSegistration
        case .deals:
            return .advantageousInformationNews
        case .specialRaceRegistrationInformation, .confirmedRaceInformation, .raceResultInformation:
            return .horseInformation
        case .thisWeeksHorseRiding:
            return .favoriteJockeyInformation
        default:
            return nil
        }
    }
    
    func sendkbn() -> String {
        switch self {
        case .specialRaceRegistrationInformation:
            return "61"
        case .confirmedRaceInformation:
            return "62"
        case .raceResultInformation:
            return "63"
        case .thisWeeksHorseRiding:
            return "64"
        default:
            return ""
        }
    }
}

enum Guide {
    case step1
    case step2
    case step3
    case step4
    case step5
    
    func image() -> UIImage {
        switch self {
        case .step1:
            return .bg_guide_step_1
        case .step2:
            return .bg_guide_step_2
        case .step3:
            return .bg_guide_step_3
        case .step4:
            return .bg_guide_step_4
        case .step5:
            return .bg_guide_step_5
        }
    }
    
    func title() -> String {
        switch self {
        case .step1:
            return "① Easy Login to Online Betting"
        case .step2:
            return "② Live Streaming of Race Videos"
        case .step3:
            return "③ Betting Ticket Memorial"
        case .step4:
            return "④ Real-Time Live Streaming"
        case .step5:
            return "⑤ Instant Voting with Subscriber Number Link"

        }
    }
    
    func attrDetail() -> String {
        switch self {
        case .step1:
            return "If you are a member of online betting, linking your subscriber number to the IMT app lets you start betting immediately!"
        case .step2:
            return "Live streaming of all IMT race videos! Watch races anytime on your device!"
        case .step3:
            return "Save your memorable betting tickets purchased at racecourses or off-track betting facilities by scanning them with your device’s camera as ticket images!"
        case .step4:
            return "Get real-time LIVE footage on your mobile — perfect for those who can’t go to the racecourse or watch TV."
        case .step5:
            return "Register your number in My Page beforehand to vote immediately without logging in again."

        }
    }
}

enum KeyChain: String {
    case account = "account"
    case autoLogin = "autoLogin"
    case guide = "guide"
    case registFCMToken = "registFCMToken"
    case userId = "userId"
    case email = "email"
    case password = "password"
    case expireIn = "expireIn"
    case access_token = "access_token"
    case refresh_token = "refresh_token"
    case loginDate = "loginDate"
}

enum KeyUserDefaults: String {
    case account = "account"
    case autoLogin = "autoLogin"
    case guide = "guide"
    case registFCMToken = "registFCMToken"
    case userId = "userId"
    case email = "email"
    case cacheOldEmail = "cacheOldEmail"
    case password = "password"
    case expiredAt = "expiredAt"
    case access_token = "access_token"
    case refresh_token = "refresh_token"
    case loginDate = "loginDate"
    case showTerm = "showTerm"
    case didLinkageIpat = "didLinkageIpat"
    case userIdsDidLogin = "userIdsDidLogin"
    case didUseBiomatricAuthentication = "didUseBiomatricAuthentication"
    case useBiometricAuthenticationInSetting = "useBiometricAuthenticationInSetting"
    case userKng
    case showGuideQR = "showGuideQR"
    case umacaTickets = "umacaTickets"
    case uToken = "uToken"
    case cacheAccessDate = ""
    case enhanceSecuritySetting = "enhanceSecuritySetting"
    case preferredDisplaySetting = "preferredDisplaySetting"
}

enum AppFontSize: CGFloat {
    case superTiny = 8
    case tiny = 9
    case small = 11
    case regular = 13
    case medium = 15
    case large = 21
}

enum RegisterAndVerfiCodeStep: String {

    case register
    case verfication
    
    func title() -> String {
        switch self {
        case .register:
            return "Register with Email Address"
        case .verfication:
            return "Enter the verification code sent to your email"

    }
    
    func description() -> String {
        switch self {
        case .register:
            return "Email Address"
        case .verfication:
            return "Verification Code"

    }
    
    func button() -> String {
        switch self {
        case .register:
            return "Send"
        case .verfication:
            return "Confirm"

        }
    }
    
    func image() -> UIImage {
        switch self {
        case .register:
            return .icLetters
        case .verfication:
            return .icLettersBadge
        }
    }
}

enum QRCodeStep: String {
    case left = "Left"
    case right = "Right"

    
    func title() -> String {
        switch self {
        case .left:
            return "Betting Ticket Image Creation Step ①"
        case .right:
            return "Betting Ticket Image Creation Step ②"

    }
    
    func description() -> String {
        switch self {
        case .left:
            return "First, align the camera guidelines with the QR code on the left and scan it."
        case .right:
            return "Next, align the camera guidelines with the QR code on the right and scan it."

    }
    
    func button() -> String {
        switch self {
        case .left:
            return "Next"
        case .right:
            return "Create"

        }
    }
    
    func image() -> UIImage {
        switch self {
        case .left:
            return .icLeftQrGuide
        case .right:
            return .icRightQrGuide
        }
    }
    
    func isHiddenCheck() -> Bool {
        switch self {
        case .left:
            return true
        case .right:
            return false
        }
    }
    
    func attributeGuide() -> NSAttributedString {
        let attrs: NSMutableAttributedString = NSMutableAttributedString(string: "")
        let attrType = NSAttributedString(string: "\(self.rawValue)side", attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(12)])
        
        let attrQR = NSAttributedString(string: "QR", attributes: [NSAttributedString.Key.font: UIFont.appFontW7Size(12)])
        
        let attrRemain = NSAttributedString(string: "go, attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(12)])
        
        attrs.append(attrType)
        attrs.append(attrQR)
        attrs.append(attrRemain)
        
        return attrs
    }
}

enum RegisterStepType: Int {
    case service = 2
    case question = 3
    
    func page() -> String {
        let totalPage = 3
        return "\(self.rawValue)/\(totalPage)"
    }
    
    func title() -> String {
        switch self {
        case .service:
            return "Have you ever purchased betting tickets for central horse racing (IMT)? (Multiple answers allowed)"
        case .question:
            return "What motivated you to participate in central horse racing (IMT)? (Multiple answers allowed)"

        }
    }
    
    func buttonTitle() -> String {
        switch self {
        case .service:
            return "Next"
        case .question:
            return "Confirm"

        }
    }
    
    func screenTitle() -> String {
        switch self {
        case .service:
            return "Enter Registration Information (2/3)"
        case .question:
            return "Enter Registration Information (3/3)"

    }
    
    func attribute() -> NSAttributedString {
        let title = title()
        let attr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.appFontW6Size(15)])
        
        return attr
    }
    
    func items(_ addDays: Bool = false) -> [InputStepRegisterModel] {
        if addDays {
            return [
                InputStepRegisterModel(title: "Travel"),
                InputStepRegisterModel(title: "Sports, Exercise, and Walking"),
                InputStepRegisterModel(title: "Watching Sports"),
                InputStepRegisterModel(title: "Mobile Games and TV Games"),
                InputStepRegisterModel(title: "Watching TV"),
                InputStepRegisterModel(title: "Watching Movies"),
                InputStepRegisterModel(title: "Karaoke"),
                InputStepRegisterModel(title: "Zoos, Botanical Gardens, and Aquariums"),
                InputStepRegisterModel(title: "Art Museums, Museums, Shrines, and Temples"),
                InputStepRegisterModel(title: "Local Horse Racing, Bicycle Racing, Boat Racing, and Auto Racing"),
                InputStepRegisterModel(title: "Pachinko and Pachislot"),
                InputStepRegisterModel(title: "Lottery and Sports Lottery"),
                InputStepRegisterModel(title: "Others")

            ]
        } else {
            switch self {
            case .service:
                return [
                    InputStepRegisterModel(title: "Purchased with cash at racecourses or WINS"),
                    InputStepRegisterModel(title: "Purchased with UMACA (cashless) at racecourses or WINS"),
                    InputStepRegisterModel(title: "Purchased via phone or internet betting"),
                    InputStepRegisterModel(title: "Asked friends or acquaintances to purchase"),
                    InputStepRegisterModel(title: "Have never purchased")

                ]
            case .question:
                return [
                    InputStepRegisterModel(title: "Invited by family"),
                    InputStepRegisterModel(title: "Invited by friends or acquaintances"),
                    InputStepRegisterModel(title: "Horse racing games"),
                    InputStepRegisterModel(title: "Horse racing broadcasts on TV"),
                    InputStepRegisterModel(title: "Horse racing commercials or advertisements"),
                    InputStepRegisterModel(title: "Influence of celebrities"),
                    InputStepRegisterModel(title: "Interested in racehorses"),
                    InputStepRegisterModel(title: "Interested in jockeys"),
                    InputStepRegisterModel(title: "Used to enjoy horse racing in the past and wanted to start again"),
                    InputStepRegisterModel(title: "Other"),


                ]
            }
        }
    }
    
    func rawValue(_ addDays: Bool = false) -> String {
        let items = items(addDays)
        return items.map({ return "\($0.getValue())" }).joined(separator: "")
    }
}

enum RaceRemark: String {
    case voting = "Race-related"
    case race = "Voting-related"

    
    func color() -> UIColor {
        switch self {
        case .voting:
            return .teaGreen
        case .race:
            return .shampoo
        }
    }
}

enum NotificationType: String {
    case event = "Event-related"
    case race = "Race-related"
    case runningHorse = "Running horse-related"

    
    func color() -> UIColor {
        switch self {
        case .event:
            return .darkCharcoal
        case .race:
            return .wageningenGreen
        case .runningHorse:
            return .teaGreen
        }
    }
    
    func textColor() -> UIColor {
        switch self {
        case .event, .race:
            return .white
        case .runningHorse:
            return .darkCharcoal
        }
    }
    
    func font() -> UIFont {
        switch self {
        case .event, .race:
            return .appFontW3Size(13)
        case .runningHorse:
            return .appFontW7Size(13)
        }
    }
}

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case genderless = "Prefer not to say"

    
    func value() -> String {
        switch self {
        case .female:
            return "2"
        case .male:
            return "1"
        case .genderless:
            return "3"
        }
    }
    
    static func getGender(_ value: String) -> Gender? {
        return Gender.allCases.first(where: { return $0.value() == value })
    }
}

enum Progression: String, CaseIterable {
    case officeWorker = "Company Employee"
    case civilServant = "Public Servant / Organization Staff"
    case manager = "Business Owner / Executive"
    case selfEmployee = "Self-Employed"
    case freelance = "Freelancer"
    case dispatchContactEmployee = "Temporary / Contract Employee"
    case parttime = "Part-Time / Casual Worker"
    case student = "Student"
    case family = "Full-Time Homemaker"
    case unemployee = "Unemployed"
    case other = "Other"

    
    func value() -> String {
        switch self {
        case .officeWorker:
            return "01"
        case .civilServant:
            return "02"
        case .manager:
            return "03"
        case .selfEmployee:
            return "04"
        case .freelance:
            return "05"
        case .dispatchContactEmployee:
            return "06"
        case .parttime:
            return "07"
        case .student:
            return "08"
        case .family:
            return "09"
        case .unemployee:
            return "10"
        case .other:
            return "11"
        }
    }
    
    static func getProgession(_ value: String) -> Progression? {
        return Progression.allCases.first(where: { return $0.value() == value })
    }
}

enum Category: String, CaseIterable {
    case installingDeletingApps = "App Installation / Deletion"
    case registrationChangeInformation = "Registration / Registration Information Change"
    case login = "Login"
    case cooperationOnlineVoting = "Online Voting Cooperation"
    case watchingVideos = "Watching Videos"
    case bettingTicketMemorial = "Betting Ticket Memorial"
    case others = "Others"

}

enum DeviceUsing: String, CaseIterable {
    case smartPhone = "Smartphone"

}

enum OperatingSystem: String, CaseIterable {
    case iOS16 = "iOS16"
    case iOS15 = "iOS15"
    case android13 = "Android13"
    case android12 = "Android12"
    case others = "Others"
}

enum UpdatePersonInfoError: String {
    case none = ""
}

enum DirectionButtonShine: Int {
  case topToBottom
  case bottomToTop
  case leftToRight
  case rightToLeft
}

enum ShareTicket {
    case facebook
    case line
    case twitter
    
    func url() -> String {
        switch self {
        case .facebook:
            return "localhost"
        case .line:
            return "localhost"
        case .twitter:
            return "localhost"
        }
    }
    
    func content() -> String {
        switch self {
        case .facebook:
            return ""
        case .line:
            return ""
        case .twitter:
            return "Some text"
        }
    }
    
    func hashtag() -> String {
        switch self {
        case .facebook:
            return "#IMTApp"
        case .line:
            return ""
        case .twitter:
            return "#IMTApp #TicketMemorial"

        }
    }
}

protocol BaseCollectionWidget: CaseIterable {
    func image() -> UIImage
    func link() -> JMTrans?
}

enum MenuWidget: BaseCollectionWidget {
    case votingHistory
    case club
    
    func image() -> UIImage {
        switch self {
        case .votingHistory:
            return .bgMenuVotingHistory
        case .club:
            return .bgMenuClub
        }
    }
    
    func link() -> JMTrans? {
        switch self {
        case .votingHistory:
            let ipat = UserManager.share().getCurrentIpatSkipLogin()
            let userId = ipat?.siteUserId ?? ""
            let url = getURLVote(userId: userId)
            
            return (url, true)
        case .club:
            let ipat = UserManager.share().getCurrentIpatSkipLogin()
            let userId = ipat?.siteUserId ?? ""
            let parsNo = ipat?.parsNo ?? ""
            let url = getURLClub(userId: userId, parsNo: parsNo)
            
            return (url, false)
        }
        
        func getURLVote(userId: String) -> String {

            return TransactionLink.votingNote.rawValue
        }
        
        func getURLClub(userId: String, parsNo: String) -> String {

            return TransactionLink.club.rawValue
        }
    }
}

enum RecommendedFunctionsMenuWidget: String, BaseCollectionWidget {
    case pushHorseFavoriteJockey = "Favorite Horse\nFavorite Jockey"
    case memorial = "Ticket\nMemorial"

    
    func image() -> UIImage {
        switch self {
        case .pushHorseFavoriteJockey:
            return .bgPushHorseFavoriteJockey
        case .memorial:
            return .bgMemorial
        }
    }
    
    func link() -> JMTrans? {
        return nil
    }
    
    func log() {
        var logValues: FlyersActionLog?
        
        switch self {
        case .pushHorseFavoriteJockey:
            logValues = .oshiHorseJockey
        case .memorial:
            logValues = .bettingTicketMemorialBanner
        }
        
        guard let logValues = logValues else { return }
        Utils.logActionClick(logValues)
    }
}

enum ServiceWidget: String, BaseCollectionWidget {
    case refundList = "Refund List"
    case result = "Race Results\nSearch"
    case racingCalendar = "Racing\nCalendar"
    case win5 = "WIN5"
    case jockeyDirectory = "Jockey Data"
    case reading = "Leading"
    case thisWeekRaceHorseSearch = "This Week’s\nRunning Horse Search"
    case specialRace = "Special Race\nRegistered Horses"
    case all = "All"


    func image() -> UIImage {
        switch self {
        case .result:
            return .bgServiceResult
        case .thisWeekRaceHorseSearch:
            return .bgThisWeekRaceHorseSearch
        case .jockeyDirectory:
            return .bgJockeyDirectory
        case .reading:
            return .bgServiceReading
        case .refundList:
            return .bgServiceRefundList
        case .win5:
            return .bgServiceWin5
        case .specialRace:
            return .bgSpecialRace
        case .racingCalendar:
            return .bgServiceRacingCalendar
        case .all:
            return .bgServiceAll
        }
    }
    
    func disableImage() -> UIImage? {
        switch self {
        case .thisWeekRaceHorseSearch:
            return .bgServiceThisWeekRaceHorseSearchDisable
        default :
            return nil
        }
    }
    
    func link() -> JMTrans? {
        switch self {
        case .result:
            return (TransactionLink.raceResultSearch.rawValue, true)
        case .thisWeekRaceHorseSearch:
            return (TransactionLink.searchHorsesRunningThisWeek.rawValue, true)
        case .jockeyDirectory:
            return (TransactionLink.jockeyDirectory.rawValue, true)
        case .reading:
            return (TransactionLink.reading.rawValue, true)
        case .refundList:
            return (TransactionLink.refundList.rawValue, true)
        case .win5:
            return (TransactionLink.win5.rawValue, true)
        case .specialRace:
            return (TransactionLink.specialRace.rawValue, true)
        case .racingCalendar:
            return (TransactionLink.racingCalendar.rawValue, true)
        default :
            return nil
        }
    }
    
    func log() {
        var logValues: FlyersActionLog?
        
        switch self {
        case .result:
            logValues = .searchResult
            break
        case .thisWeekRaceHorseSearch:
            logValues = .searchThisWeekRuningHorse
            break
        case .jockeyDirectory:
            logValues = .jockeyDirectory
            break
        case .reading:
            logValues = .reading
            break
        case .refundList:
            logValues = .refundList
            break
        case .win5:
            logValues = .win5
            break
        case .specialRace:
            logValues = .specialRace
            break
        case .racingCalendar:
            logValues = .racingCalendar
            break
        default:
            break
        }
        
        guard let logValues = logValues else { return }
        Utils.logActionClick(logValues)
    }
}

enum HorseRaceInfoLinkWidget: BaseCollectionWidget {
    case event70th
    case IMTfun
    case IMTvan
    case gcweb
    case turfy
    case takeRV
    
    func image() -> UIImage {
        switch self {
        case .event70th:
            return .bgHorseRaceInfoLinkEvent70th
        case .IMTfun:
            return .bgHorseRaceInfoLinkIMTfun
        case .IMTvan:
            return .bgHorseRaceInfoLinkIMTVan
        case .gcweb:
            return .bgHorseRaceInfoLinkGCWeb
        case .turfy:
            return .bgHorseRaceInfoLinkTurfy
        case .takeRV:
            return .bgHorseRaceInfoLinkTakeRV
        }
    }
    
    func link() -> JMTrans? {
        switch self {
        case .event70th:
            return (TransactionLink.horseRaceInfoEvent70th.rawValue, true)
        case .IMTfun:
            return (TransactionLink.horseRaceInfoIMTFun.rawValue, false)
        case .IMTvan:
            return (TransactionLink.horseRaceInfoIMTVan.rawValue, false)
        case .gcweb:
            return (TransactionLink.horseRaceInfoGCWeb.rawValue, false)
        case .turfy:
            return (TransactionLink.horseRaceInfoTurfy.rawValue, false)
        case .takeRV:
            return (TransactionLink.horseRaceinfoTakeRV.rawValue, false)
        }
    }
}

enum MailVerificationStyle {
    case changeEmail
    case signup
    case sendCodeChangePassword
    case sendCodeForgotPassword
    
    func titleScreen() -> String {
        switch self {
        case .changeEmail:
            return "New Email Address Verification"
        case .signup:
            return "New Registration"
        case .sendCodeChangePassword, .sendCodeForgotPassword:
            return "Send Verification Code"

        }
    }
    
    func title() -> String {
        switch self {
        case .changeEmail:
            return "New Email Address Verification"
        case .signup:
            return "Enter Email Address"
        case .sendCodeChangePassword, .sendCodeForgotPassword:
            return "Verification Code Will Be Sent"

        }
    }
    
    func describe() -> String {
        switch self {
        case .changeEmail:
            return """
            Changing your email address requires two-factor authentication using the new email address.
            We will send a URL to the email address you entered, so please adjust your email settings to allow emails from “@IMT.go.jp”.
            Possible reasons for not receiving the verification email include an incorrect email address or the email being filtered into the spam folder.
            """
        case .signup:
            return """
            Using the app requires two-factor authentication via email.
            We will send a verification code to the email address you entered, so please adjust your email settings to allow emails from “@IMT.go.jp”.
            Possible reasons for not receiving the verification email include an incorrect email address or the email being filtered into the spam folder.
            """
        case .sendCodeChangePassword, .sendCodeForgotPassword:
            return "We will send a verification code to the registered email address."

        }
    }
    
    func confirmOTPStyle() -> ConfirmOTPStyle {
        switch self {
        case .changeEmail:
            return .verifyChangeEmail
        case .signup:
            return .signup
        case .sendCodeChangePassword:
            return .changePassword
        case .sendCodeForgotPassword:
            return .resetPassword
        }
    }
}

enum ConfirmUpdateUserStyle {
    
    case new
    case update
    
    func title() -> String {
        switch self {
        case .new:
            return "Confirm Registration Information"
        case .update:
            return "Confirm and Edit Registration Information"

        }
    }
}

enum ConfirmOTPStyle: CaseIterable {
    case signup
    case changePassword
    case resetPassword
    case updateUserInfo
    case verifyChangeEmail
    
    func title() -> String {
        switch self {
        case .signup:
            return "Sign Up"
        case .changePassword:
            return "Change Password"
        case .resetPassword:
            return "Forgot Password"
        case .updateUserInfo:
            return "Update User Info"
        case .verifyChangeEmail:
            return "Verify Email Change" 

            
        }
    }
    
    func button() -> String {
        switch self {
        case .signup, .verifyChangeEmail:
            return ""
        case .changePassword:
            return ""
        case .resetPassword:
            return "Send"
        case .updateUserInfo:
            return "Send"

        }
    }
}

enum RaceYoutubeLink: CaseIterable {
    case trainingRace1
    case trainingRace2
    case trainingRace3
    case trainingRace4
    case trainingRace5
    
    func url() -> JMTransAgent {
        switch self {
        case .trainingRace1:
            return ("localhost", nil)
        case .trainingRace2:
            return ("localhost", nil)
        case .trainingRace3:
            return ("localhost", nil)
        case .trainingRace4:
            return ("localhost", Constants.System.userAgentIMTA)
        case .trainingRace5:
            return ("localhost", nil)
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .trainingRace1:
            return .trainingRace1
        case .trainingRace2:
            return .trainingRace2
        case .trainingRace3:
            return .trainingRace3
        case .trainingRace4:
            return .trainingRace4
        case .trainingRace5:
            return .trainingRace5
        }
    }
}

enum ReasonDeleteApp: String, CaseIterable {
    case q1 = "Q1"
    case q2 = "Q2"
    
    func title() -> String {
        switch self {
        case .q1:
            return "Please tell us the reasons for deleting your app registration (multiple answers allowed)"
        case .q2:
            return "Please tell us what features or content you think would be good to have in the IMT app (within 250 characters)"
        }

    }
    
    func detail() -> [IReasonDelete] {
        switch self {
        case .q1:
            return [
                IReasonDelete(title: "Stopped or reduced participation in central horse racing"),
                IReasonDelete(title: "Few functions or content I want to use or interested in"),
                IReasonDelete(title: "Insufficient quality of functions or content"),
                IReasonDelete(title: "Difficult to understand how to use"),
                IReasonDelete(title: "Poor usability"),
                IReasonDelete(title: "Insufficient support system"),
                IReasonDelete(title: "No or few benefits for users"),
                IReasonDelete(title: "Switched to other horse racing apps or services")]

        case .q2:
            return []
        }
    }
    
    func feedback() -> Bool {
        switch self {
        case .q1:
            return false
        case .q2:
            return true
        }
    }
}

enum RaceColler: String{
    case A = "A"
    case B = "B"
    case C = "C"
    
    func tabDateColor() -> UIColor {
        switch self {
        case .A:
            return .darkPowderBlue
        case .B:
            return .cadmiumGreen
        case .C:
            return .patriarch80
        }
    }
    
    func tabPlaceColor() -> UIColor {
        switch self {
        case .A:
            return .darkPowderBlue
        case .B:
            return .cadmiumGreen
        case .C:
            return .patriarch80
        }
    }
    
    func rankColor() -> UIColor {
        switch self {
        case .A:
            return .darkPowderBlue
        case .B:
            return .cadmiumGreen
        case .C:
            return .patriarch80
        }
    }
    
    func backgroundColor(_ value: UIColor = .red) -> UIColor {
        switch self {
        case .A:
            return .lavender
        case .B:
            return .honeydew
        case .C:
            return .lavenderBlush
        }
    }
    
    static func tabColorOfStatuday() -> UIColor {
        return .lapisLazuli
    }
    
    static func tabColorOfSunday() -> UIColor {
        return .englishVermillion
    }
    
    static func tabColorOfHoliday() -> UIColor {
        return .darkCharcoal
    }
    
    static func tabNormalDateColor() -> UIColor {
        return .darkCharcoal
    }
}

enum BeginnerGuideRow: CaseIterable {
    case one
    case two
    case three
    
    func topics() -> [BeginnerGuideTopic] {
        switch self {
        case .one:
            return [.iWantToKnowTheBettingTicket, .youCanBuyBettingTicketsOnline]
        case .two:
            return [.youCanBuyBettingTicketsAtRacetracksAndWinds]
        case .three:
            return [.teachHorseRacing]
        }
    }
}

enum BeginnerGuideTopic: String, CaseIterable {
    case iWantToKnowTheBettingTicket = "I want to know about betting tickets!"
    case youCanBuyBettingTicketsOnline = "You can buy betting tickets online!"
    case youCanBuyBettingTicketsAtRacetracksAndWinds = "You can buy betting tickets at racetracks and WINS!"
    case teachHorseRacing = "Teach me about horse racing!"

    
    func items() -> [TopicCardModel] {
        switch self {
        case .iWantToKnowTheBettingTicket:
            return [TopicCardModel(subTitle: nil, subItems: [ITopicCardModel(.typeOfBettingTicket)])]
        case .youCanBuyBettingTicketsOnline:
            return [TopicCardModel(subTitle: nil, subItems: [ITopicCardModel(.purchasedByInternetVoting)])]
        case .youCanBuyBettingTicketsAtRacetracksAndWinds:
            return [
                TopicCardModel(subTitle: nil, subItems: [ITopicCardModel(.createAVotingQRAndPurchaseABettingTicket), ITopicCardModel(.fillInTheMarkCardAndBuyABettingTicket),
                                                         ITopicCardModel(.empty)]),
                TopicCardModel(subTitle: nil, subItems: [ITopicCardModel(.purchaseBettingTicketsCashless), ITopicCardModel(.operationOfVendingMachines),
                    ITopicCardModel(.vendingMachineOperation)])
            ]
        case .teachHorseRacing:
            return [TopicCardModel(subTitle: nil, subItems: [ITopicCardModel(.horseRacingDictionary),
                                                             ITopicCardModel(.beginnersSeminar),
                                                             ITopicCardModel(.keibaCatalog)])]
        }
    }
    
    func numItemOfRow() -> Float {
        switch self {
        case .iWantToKnowTheBettingTicket, .youCanBuyBettingTicketsOnline:
            return 2
        case .youCanBuyBettingTicketsAtRacetracksAndWinds, .teachHorseRacing:
            return 1
        }
    }
    
    func theme() -> UIColor {
        switch self {
        case .iWantToKnowTheBettingTicket:
            return .lapisLazuli
        case .youCanBuyBettingTicketsOnline:
            return .lapisLazuli
        case .youCanBuyBettingTicketsAtRacetracksAndWinds:
            return .main
        case .teachHorseRacing:
            return .cyberGrape
        }
    }
}

enum BeginnerGuide: String, CaseIterable {
    case typeOfBettingTicket = "Type of Betting Ticket"
    case purchasedByInternetVoting = "Purchased by Internet Voting"
    case createAVotingQRAndPurchaseABettingTicket = "Create a Voting QR and Purchase a Betting Ticket"
    case fillInTheMarkCardAndBuyABettingTicket = "Fill in the Mark Card and Buy a Betting Ticket"
    case vendingMachineOperation = "Operation of Vending Machine (Cash)"
    case purchaseBettingTicketsCashless = "Purchase Betting Tickets Cashlessly"
    case operationOfVendingMachines = "Operation of Vending Machine (Cashless)"
    case horseRacingDictionary = "Horse Racing Dictionary"
    case beginnersSeminar = "Beginners Seminar"
    case keibaCatalog = "Keiba Catalog"

    case empty = ""
    
    func transInfo() -> JMTransAgent {
        switch self {
        case .typeOfBettingTicket:
            return ("localhost", Constants.System.userAgentIMTA)
        case .purchasedByInternetVoting:
            return ("localhost", Constants.System.userAgentIMTA)
        case .createAVotingQRAndPurchaseABettingTicket:
            return ("localhost", Constants.System.userAgentIMTA)
        case .fillInTheMarkCardAndBuyABettingTicket:
            return ("localhost", Constants.System.userAgentIMTA)
        case .vendingMachineOperation:
            return ("localhost", Constants.System.userAgentIMTA)
        case .purchaseBettingTicketsCashless:
            return ("localhost", Constants.System.userAgentIMTA)
        case .operationOfVendingMachines:
            return ("localhost", Constants.System.userAgentIMTA)
        case .horseRacingDictionary:
            return ("localhost", Constants.System.userAgentIMTA)
        case .beginnersSeminar:
            return ("localhost", Constants.System.userAgentIMTA)
        case .keibaCatalog:
            return ("localhost", nil)
        case .empty:
            return ("", nil)
        }
    }
    
    func icon() -> UIImage? {
        switch self {
        case .typeOfBettingTicket:
            return .beginner_guide_ticket
        case .purchasedByInternetVoting:
            return .beginner_guide_mdi_monitor_cellphone_star
        case .createAVotingQRAndPurchaseABettingTicket:
            return .beginner_guide_qrcode
        case .fillInTheMarkCardAndBuyABettingTicket:
            return .begginer_guide_mdi_pencil_outline
        case .vendingMachineOperation:
            return .beginner_guide_mdi_account_cash
        case .purchaseBettingTicketsCashless:
            return .begginer_guide_mdi_credit_card_check_outline
        case .operationOfVendingMachines:
            return .beginner_guide_mdi_account_credit_card
        case .horseRacingDictionary:
            return .begginer_guide_mdi_horse_variant
        case .beginnersSeminar:
            return .begginer_guide_shield
        case .keibaCatalog:
            return .begginer_guide_simple_line_icons_book_open
        case .empty:
            return nil
        }
    }
}

enum StatusCodeNetwork: Int {
    
    case code200 = 200
    case code400 = 400
    case code401 = 401
    case code404 = 404
    case code405 = 405
    case code429 = 429
    case code500 = 500
    
    func message() -> String? {
        switch self {
        case .code200:
            return nil
        case .code400:
            return "Invalid request parameters specified"
        case .code401:
            return "API access token is invalid or lacks proper permissions"
        case .code404:
            return "Accessed a non-existent URL"
        case .code405:
            return "An issue occurred. Please try again."
        case .code429:
            return "Request limit exceeded"
        case .code500:
            return "Unknown error"

        }
    }
}

enum VotingOnlineStyle {
    case new
    case update
}

enum VotingOnlineType {
    case ipatOne
    case ipatTwo
}

enum VotingOnlineFromScreen {
    case menu
    case other
    
    func useNavigation() -> Bool {
        switch self {
        case .menu:
            return false
        case .other:
            return true
        }
    }
}

enum UpdatePersonalFromScreen {
    case menu
    case other
    
    func useNavigation() -> Bool {
        switch self {
        case .menu:
            return false
        case .other:
            return true
        }
    }
}

enum ChangePasswordFromScreen {
    case menu
    case other
    
    func useNavigation() -> Bool {
        switch self {
        case .menu:
            return false
        case .other:
            return true
        }
    }
}

enum EnterChangeEmailFromScreen {
    case menu
    case other
    
    func useNavigation() -> Bool {
        switch self {
        case .menu:
            return false
        case .other:
            return true
        }
    }
}

enum ConfirmOTPFromScreen {
    case menu
    case other
    
    func useNavigation() -> Bool {
        switch self {
        case .menu:
            return false
        case .other:
            return true
        }
    }
}

enum PasswordResetFromScreen {
    case menu
    case other
    
    func useNavigation() -> Bool {
        switch self {
        case .menu:
            return false
        case .other:
            return true
        }
    }
}

enum Enviroment: String {
    case develop = "DEVELOP"
    case product = "PRODUCT"
    case stagging = "STAGGING"
}

enum IMTWebStyle {
    case url
    case html
}

enum IMTFontWeight: String {
    case bold = "Hiragino Sans W7"
    case semiBold = "Hiragino Sans W6"
    case medium = "Hiragino Sans W5"
    case normal = "Hiragino Sans W4"
    case light = "Hiragino Sans W3"
    case extraLight = "Hiragino Sans W2"
    case thin = "Hiragino Sans W1"
}

enum IMTFontStyleSize: CGFloat {
    case largest = 25
    case larger = 19
    case large = 18
    case medium = 16
    case normal = 14
    case small = 12
    case tiny = 10
}

enum IMTTab: Int {
    case home = 0
    case race = 1
    case onlineVote = 2
    case live = 3
    case menu = 4
}

enum WaringMemorial {
    case waringQR
    case waringListTicket
}

enum IMTNotificationType: Int {
    case automatic = 1
    case manual = 0
    
    func tab() -> IMTTab? {
        switch self {
        case .automatic:
            return .home
        case .manual:
            guard let _ = Constants.incomingNotification else { return nil }
            return .menu
        }
    }
    
    func needToPushScreen(_ controller: BaseViewController) -> Bool {
        switch self {
        case .automatic:
            return controller.isKind(of: HomeVC.self)
        case .manual:
            guard let _ = Constants.incomingNotification else { return false }
            return controller.isKind(of: MenuVC.self)
        }
    }
}

enum IMTNotificationCategory: Int {
    case thisWeekHighLights = 60
    case deals = 61
    case emergency = 62
}

enum FlyersActionLog: String {
    case internetVoting = "Internet Voting"
    case createVotingQR = "Smappy"
    case searchResult = "Race Result Search"
    case searchRaceHorse = "Racehorse Search"
    case searchThisWeekRuningHorse = "This Week’s Running Horse Search"
    case jockeyDirectory = "Jockey Directory"
    case trainerDirectory = "Trainer Directory"
    case reading = "Leading"
    case raceCourseInformation = "Racecourse Guide"
    case firseHorseRacingGuide = "Beginner’s Guide to Horse Racing"
    case bettingTicketMemorialBanner = "Betting Ticket Memorial"
    case refundList = "Payout List"
    case win5 = "WIN5"
    case specialRace = "Special Race Registered Horses"
    case racingCalendar = "Racing Calendar"
    case raceTab = "Training & Race Tab"
    case liveTab = "Race Live Tab"
    case logout = "App Logout"
    case newOnlineVotingRegistration = "New Online Voting Registration"
    case windsInformation = "WINS Guide"
    case umacaSmart = "UMACA Smart"
    case oshiHorseJockey = "Favorite Horse & Jockey"
    case blueInternetVoting = "Blue: Internet Voting"
    case greenUmacaSmart = "Green: UMACA Smart"

    
    func values() -> [String: Any] {
        let key = "value"
        let value = "1"
        
        return [key: value]
    }
}

enum BiometricAuthenticationStyle {
    case faceId
    case touchId
    case none
    
    func title() -> String? {
        switch self {
        case .faceId:
            return "Face ID is available"
        case .touchId:
            return "Touch ID is available"

        case .none:
            return nil
        }
    }
    
    func description() -> NSAttributedString? {
        var desciption = ""
        
        switch self {
        case .faceId:
            description = "By using Face ID,\nyou can log in to the app\nwithout entering a password."
            break
        case .touchId:
            description = "By using Touch ID,\nyou can log in to the app\nwithout entering a password."

            break
        case .none:
            return nil
        }
        
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        style.lineSpacing = 5
        
        return NSAttributedString(string: desciption, attributes: [NSAttributedString.Key.font: UIFont.appFontW4Size(14), NSAttributedString.Key.paragraphStyle: style])
    }
    
    func image() -> UIImage? {
        switch self {
        case .faceId:
            return .icFaceId
        case .touchId:
            return .icTouchId
        case .none:
            return nil
        }
    }
    
    func loginImage() -> UIImage? {
        switch self {
        case .faceId:
            return .icLoginFaceId
        case .touchId:
            return .icLoginTouchId
        case .none:
            return nil
        }
    }
    
    func loginTitle() -> String? {
        switch self {
        case .faceId:
            return "Log in with Face ID"
        case .touchId:
            return "Log in with Touch ID"

        case .none:
            return nil
        }
    }
}

enum UserRole: String {
    case test = "9"
    case manual = "0"
}

enum PostCode: String {
    case overseas = "0009999"
}

enum AccessLinkPrefix: String, CaseIterable {
    case d = "localhost.html?CNAME"
    case t = "localhost.html?CNAME"
    case s = "localhost.html?CNAME"
    case i = "localhost.html?CNAME"
    case k = "localhost.html?CNAME"
    case r = "localhost.html?CNAME"
    case c = "localhost.html?CNAME"
}

enum WarningType {
    case legalAge
    case limitUpdate
    case errorReadingQR
    case limitTicket(_ limit: Int)
    case requestUpgrade
    case forceUpgrade
    case deleteSingleTicket
    case deleteMultipleTicket(numberOfItem: Int?)
    case cancelThePushHorse(_ horse: String)
    case pushHorseHasBeenReleased(_ horse: String)
    case cancelMultipleThePushHorse(numberOfItems: Int)
    case cancelThePushJockey(_ person: String)
    case favoriteJockeyHasBeenReleased(_ person: String)
    case cancelMultipleTheFavoriteJockey(numberOfItems: Int)
    case custom(_ desc: String)
    case addListRecommended(_ horse: String)
    case removeListRecommened(_ horse: String)
    case limitListRecommendedHorses(_ limit: Int)
    case addListFavorite(_ person: String)
    case removeListFavorite(_ person: String)
    case listOfFavoriteJockeys(_ person: String)
    case limitListFavoriteJockeys(_ limit: Int)
    
    func title() -> NSAttributedString {
        switch self {
        case .errorReadingQR:
            return NSMutableAttributedString(
                string: "QR reading error",
                attributes: [.font: UIFont.appFontW6Size(18), .foregroundColor: UIColor(hex: "#EA6503")]
            )

        case .requestUpgrade, .forceUpgrade:
            return NSAttributedString(
                string: "IMT App Update",
                attributes: [.font: UIFont.appFontW6Size(18)]
            )

        case .deleteMultipleTicket(let numberOfItem):
            let count = numberOfItem ?? 0
            let value = "Selected \(count) items"
            return NSMutableAttributedString(
                string: value,
                attributes: [.font: UIFont.appFontW6Size(18), .foregroundColor: UIColor.darkCharcoal]
            )

        case .addListFavorite(let person):
            return NSAttributedString(
                string: "\(person)\nRegister as your favorite jockey?",
                attributes: [.font: UIFont.appFontW6Size(14), .paragraphStyle: getLineSpace(6)]
            )

        case .removeListFavorite(let person):
            return NSAttributedString(
                string: "\(person)\nRemove from favorite jockeys?",
                attributes: [.font: UIFont.appFontW6Size(14), .paragraphStyle: getLineSpace(6)]
            )

        case .addListRecommended(let horse):
            return NSAttributedString(
                string: "\(horse)\nRegister as your favorite horse?",
                attributes: [.font: UIFont.appFontW6Size(14), .paragraphStyle: getLineSpace(6)]
            )

        case .removeListRecommened(let horse):
            return NSAttributedString(
                string: "\(horse)\nRemove from favorite horses?",
                attributes: [.font: UIFont.appFontW6Size(14), .paragraphStyle: getLineSpace(6)]
            )

        default:
            return NSAttributedString(string: "")
        }
        
        func getLineSpace(_ space: CGFloat? = nil, alignment: NSTextAlignment = .center) -> NSMutableParagraphStyle {
            let paragraphStyle = NSMutableParagraphStyle()
            
            if let space = space {
                paragraphStyle.lineSpacing = space
            }
            paragraphStyle.alignment = alignment
            
            return paragraphStyle
        }
    }
    
    static func compile(_ value: String) -> WarningType? {
        switch value {
        case WarningType.legalAge.description():
            return .legalAge
        case "Changes can be made once per day.\nPlease try again tomorrow."

            return .limitUpdate
        case WarningType.errorReadingQR.description():
            return .errorReadingQR
        default:
            return nil
        }
    }
    
    func description() -> String {
        switch self {
        case .legalAge:
            return "This feature is not available for users under 20 years old."
        case .limitUpdate:
            return "Changes can be made once per day.\nPlease try again tomorrow."
        case .errorReadingQR:
            return "Failed to read the QR code. Please try again."
        case .limitTicket(let limit):
            return "You have reached the registration limit of \(limit) items.\nPlease delete some betting ticket images to free up space."
        case .requestUpgrade, .forceUpgrade:
            return "A new version of the app is available.\nPlease update to the latest version from the App Store."
        case .deleteSingleTicket:
            return "Once deleted, it cannot be restored.\nDo you want to delete?"
        case .deleteMultipleTicket:
            return "Once deleted, all cannot be restored.\nDo you want to delete?"
        case .cancelThePushHorse(let horse):
            return "Do you want to remove \(horse) from your favorite horses?"
        case .pushHorseHasBeenReleased(let horse):
            return "\(horse) has been removed from your favorite horses."
        case .cancelMultipleThePushHorse(let numberOfItems):
            return "Selected \(numberOfItems) items\nDo you want to remove them from your favorite horses?"
        case .cancelThePushJockey(let person):
            return "Do you want to remove \(person) from your favorite jockeys?"
        case .favoriteJockeyHasBeenReleased(let person):
            return "\(person) has been removed from your favorite jockeys."
        case .cancelMultipleTheFavoriteJockey(let numberOfItems):
            return "Selected \(numberOfItems) items\nDo you want to remove them from your favorite jockeys?"
        case .limitListFavoriteJockeys(let limit):
            return "You have reached the registration limit of \(limit) favorite jockeys.\nPlease remove some before adding new ones."
        case .limitListRecommendedHorses(let limit):
            return "You have reached the registration limit of \(limit) favorite horses.\nPlease remove some before adding new ones."

        case .custom(let desc):
            return desc
        default:
            return ""
        }
    }
    
    func attributedString() -> NSAttributedString {
        let description = description()
        
        switch self {
        case .legalAge, .limitUpdate, .deleteSingleTicket, .deleteMultipleTicket, .cancelThePushHorse, .pushHorseHasBeenReleased, .cancelMultipleThePushHorse, .cancelThePushJockey, .favoriteJockeyHasBeenReleased, .cancelMultipleTheFavoriteJockey:
            let attributedString = NSMutableAttributedString(string: description)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 12
            paragraphStyle.alignment = .center
            attributedString.addAttributes([.paragraphStyle: paragraphStyle, .font: UIFont.appFontW6Size(14)], range:NSMakeRange(0, attributedString.length))
            return attributedString
        case .errorReadingQR:
            let attributedString = NSMutableAttributedString(string: description)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 12
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont.appFontW6Size(14)], range: NSMakeRange(0, attributedString.length))
            return attributedString
        case .limitTicket(let limit):
            let attributedString = NSMutableAttributedString(string: description)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 12
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont.appFontW6Size(14)], range: NSMakeRange(0, attributedString.length))
            attributedString.highlight(substring: "\(limit)item", with: [.foregroundColor: UIColor.redHighlight])
            return attributedString
        case .requestUpgrade, .forceUpgrade:
            let attributedString = NSMutableAttributedString(string: description)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 12
            attributedString.addAttributes([.paragraphStyle: paragraphStyle, .font: UIFont.appFontW4Size(14)], range: NSMakeRange(0, attributedString.length))
            return attributedString
        case .limitListFavoriteJockeys(let limit) ,.limitListRecommendedHorses(let limit):
            let attributedString = NSMutableAttributedString(string: description)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont.appFontW6Size(14)], range: NSMakeRange(0, attributedString.length))
            attributedString.highlight(substring: "\(limit)item", with: [.foregroundColor: UIColor.redHighlight])
            return attributedString
        default:
            return NSAttributedString(string: description)
        }
    }
    
    func textBorderedButton() -> NSAttributedString {
        switch self {
        case .errorReadingQR:
            return NSAttributedString(string: "Back", attributes: [.font: UIFont.appFontW6Size(14)])
        case .requestUpgrade:
            return NSAttributedString(string: "Later", attributes: [.font: UIFont.appFontW6Size(14)])
        case .forceUpgrade:
            return NSAttributedString(string: "")
        case .deleteSingleTicket, .deleteMultipleTicket, .cancelMultipleThePushHorse, .cancelThePushHorse, .cancelThePushJockey, .cancelMultipleTheFavoriteJockey, .removeListRecommened, .removeListFavorite, .addListRecommended, .addListFavorite:
            return NSAttributedString(string: "Cancel", attributes: [.font: UIFont.appFontW6Size(14)])
            default:
                return NSAttributedString(string: "Close", attributes: [.font: UIFont.appFontW6Size(14)])

        }
    }
    
    func textFilledButton() -> NSAttributedString {
        switch self {
        case .requestUpgrade, .forceUpgrade:
            return NSAttributedString(string: "Update Now", attributes: [.font: UIFont.appFontW6Size(14)])
        case .deleteSingleTicket, .deleteMultipleTicket:
            return NSAttributedString(string: "Delete", attributes: [.font: UIFont.appFontW6Size(14)])
        case .cancelThePushHorse, .cancelMultipleThePushHorse, .cancelThePushJockey, .cancelMultipleTheFavoriteJockey, .removeListRecommened, .removeListFavorite:
            return NSAttributedString(string: "Unregister", attributes: [.font: UIFont.appFontW6Size(14)])
        case .addListRecommended, .addListFavorite:
            return NSAttributedString(string: "Register", attributes: [.font: UIFont.appFontW6Size(14)])

        default:
            return NSAttributedString(string: "")
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .deleteSingleTicket, .deleteMultipleTicket:
            return .icDelete
        case .addListRecommended:
            return .icUnRecommendedHorse
        case .removeListRecommened:
            return .icRecommendedHorse
        case .addListFavorite:
            return .icUnFavoritePerson
        case .removeListFavorite:
            return .icFavoritePerson
        case .cancelThePushHorse, .cancelMultipleThePushHorse:
            return .icRecommendedHorse
        case .pushHorseHasBeenReleased:
            return .icUnRecommendedHorse
        case .cancelThePushJockey, .cancelMultipleTheFavoriteJockey:
            return .icFavoritePerson
        case .favoriteJockeyHasBeenReleased:
            return .icUnFavoritePerson
        default:
            return .icWarningQRCode
        }
    }
    
    func theme() -> [UIColor] {
        switch self {
        case .deleteSingleTicket, .deleteMultipleTicket:
            return [.lapisLazuli]
        case .addListFavorite, .removeListFavorite, .addListRecommended, .removeListRecommened, .cancelThePushHorse, .cancelMultipleThePushHorse, .cancelThePushJockey, .cancelMultipleTheFavoriteJockey:
            return [.spanishOrange, .darkCharcoal]
        case .limitListFavoriteJockeys, .limitListRecommendedHorses,  .pushHorseHasBeenReleased, .favoriteJockeyHasBeenReleased:
            return [.darkCharcoal]
        default:
            return [.spanishOrange]
        }
    }
    
    func imageHeight() -> CGFloat {
        switch self {
        case .deleteSingleTicket, .deleteMultipleTicket:
            return 55.0
        default:
            return 70.0
        }
    }
    
    func space() -> CGFloat? {
        switch self {
        case .addListFavorite, .removeListFavorite, .addListRecommended, .removeListRecommened, .cancelThePushHorse, .pushHorseHasBeenReleased, .cancelMultipleThePushHorse, .cancelThePushJockey, .favoriteJockeyHasBeenReleased, .cancelMultipleTheFavoriteJockey:
            return 12
        default:
            return nil
        }
    }
}

enum WarningAction: Int {
    case ok = 1
    case cancel = 0
}

enum WarningTypeV2 {
    case listOfFavoriteJockeys(_ person: String)
    case listOfRecommendedHorses(_ horse: String)
    case wouldYouLikeToRegisterAsAFavoriteHorse(_ horse: String)
    case iHaveRegisteredAsAFavoriteHorse(_ horse: String)
    case alreadyRegisteredAsAFavoriteHorse(_ horse: String)
    case wouldYouLikeToRegisterAsAFavoriteJockey(_ person: String)
    case iHaveRegisteredAsAFavoriteJockey(_ person: String)
    case iAmRegisteredAsAFavoriteJockey(_ person: String)
    case didRemoveAllPreferenceComplete(_ numberOfItem: Int,_ segment: ListHorsesAndJockeysSegment)
    
    func title() -> NSAttributedString {
        switch self {
        case .listOfFavoriteJockeys(let person):
            let value = "\(person) \nhas been added to your favorite jockeys!"
            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        case .listOfRecommendedHorses(let horse):
            let value = "\(horse) \nhas been added to your favorite horses!"
            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        case .wouldYouLikeToRegisterAsAFavoriteHorse(let horse):
            let value = "\(horse) \nWould you like to add to your favorite horses?"
            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        case .iHaveRegisteredAsAFavoriteHorse(let horse):
            let value = "\(horse) \nhas been added to your favorite horses!"
            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        case .alreadyRegisteredAsAFavoriteHorse(let horse):
            let value = "\(horse) \nis already in your favorite horses"
            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        case .wouldYouLikeToRegisterAsAFavoriteJockey(let person):
            let value = "\(person) \nWould you like to add to your favorite jockeys?"
            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        case .iHaveRegisteredAsAFavoriteJockey(let person):
            let value = "\(person) \nhas been added to your favorite jockeys!"
            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        case .iAmRegisteredAsAFavoriteJockey(let person):
            let value = "\(person) \nis already in your favorite jockeys"
            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        case .didRemoveAllPreferenceComplete(let numberOfItem, let segment):
            let value = "\(numberOfItem) selected\nRemoved from your favorite \(segment == .favoriteJockeys ? "jockeys" : "horses")."

            return NSAttributedString(string: value, attributes: [.font: font(), .paragraphStyle: paragraphStyle()])
        }
    }
    
    func description() -> NSAttributedString? {
        switch self {
        default:
            return nil
        }
    }
    
    func image() -> UIImage {
        switch self {
        case .listOfFavoriteJockeys, .iHaveRegisteredAsAFavoriteJockey, .iAmRegisteredAsAFavoriteJockey:
            return .icFavoritePerson
        case .listOfRecommendedHorses, .iHaveRegisteredAsAFavoriteHorse, .alreadyRegisteredAsAFavoriteHorse:
            return .icRecommendedHorse
        case .wouldYouLikeToRegisterAsAFavoriteHorse:
            return .icUnRecommendedHorse
        case .wouldYouLikeToRegisterAsAFavoriteJockey:
            return .icUnFavoritePerson
        case .didRemoveAllPreferenceComplete(_, let segment):
            return segment == .favoriteJockeys ? .icUnFavoritePerson : .icUnRecommendedHorse
        }
    }
    
    func imageHeight() -> CGFloat {
        return 70
    }
    
    func titleButtons() -> [NSAttributedString] {
        switch self {
        case .listOfFavoriteJockeys:
            let fgColor1: UIColor = .spanishOrange
            let fgColor2: UIColor = .darkCharcoal
            
            let attrButton1 = NSAttributedString(string: "Favorite Jockey List", attributes: [.font: font(), .foregroundColor: fgColor1])
            let attrButton2 = NSAttributedString(string: "Close", attributes: [.font: font(), .foregroundColor: fgColor2])
            
            return [attrButton1, attrButton2]

        case .listOfRecommendedHorses:
            let fgColor1: UIColor = .spanishOrange
            let fgColor2: UIColor = .darkCharcoal
            
            let attrButton1 = NSAttributedString(string: "Favorite Horse List", attributes: [.font: font(), .foregroundColor: fgColor1])
            let attrButton2 = NSAttributedString(string: "Close", attributes: [.font: font(), .foregroundColor: fgColor2])
            
            return [attrButton1, attrButton2]

        case .wouldYouLikeToRegisterAsAFavoriteHorse(_):
            let fgColor1: UIColor = .white
            let fgColor2: UIColor = .spanishOrange
            let fgColor3: UIColor = .darkCharcoal
            
            let attrButton1 = NSAttributedString(string: "Register", attributes: [.font: font(), .foregroundColor: fgColor1])
            let attrButton2 = NSAttributedString(string: "View Horse Info", attributes: [.font: font(), .foregroundColor: fgColor2])
            let attrButton3 = NSAttributedString(string: "Cancel", attributes: [.font: font(), .foregroundColor: fgColor3])
            
            return [attrButton1, attrButton2, attrButton3]

        case .iHaveRegisteredAsAFavoriteHorse:
            let fgColor1: UIColor = .spanishOrange
            let fgColor2: UIColor = .darkCharcoal
            
            let attrButton1 = NSAttributedString(string: "Favorite Horse List", attributes: [.font: font(), .foregroundColor: fgColor1])
            let attrButton2 = NSAttributedString(string: "Close", attributes: [.font: font(), .foregroundColor: fgColor2])
            
            return [attrButton1, attrButton2]

        case .alreadyRegisteredAsAFavoriteHorse:
            let fgColor1: UIColor = .spanishOrange
            let fgColor2: UIColor = .darkCharcoal
            
            let attrButton1 = NSAttributedString(string: "View Horse Info", attributes: [.font: font(), .foregroundColor: fgColor1])
            let attrBu

            return [attrButton1];
        }
    }
    
    func borderColorButtons() -> [UIColor?] {
        switch self {
        case .listOfFavoriteJockeys, .listOfRecommendedHorses:
            return [.spanishOrange, .darkCharcoal]
        case .wouldYouLikeToRegisterAsAFavoriteHorse, .wouldYouLikeToRegisterAsAFavoriteJockey:
            return [nil, .spanishOrange, .darkCharcoal]
        case .iHaveRegisteredAsAFavoriteHorse, .alreadyRegisteredAsAFavoriteHorse, .iHaveRegisteredAsAFavoriteJockey, .iAmRegisteredAsAFavoriteJockey:
            return [.spanishOrange, .darkCharcoal]
        case .didRemoveAllPreferenceComplete:
            return [.darkCharcoal]
        }
    }
    
    func backgroundColorButtons() -> [UIColor?] {
        switch self {
        case .wouldYouLikeToRegisterAsAFavoriteHorse, .wouldYouLikeToRegisterAsAFavoriteJockey:
            return [.spanishOrange, nil, nil]
        default:
            return [nil, nil]
        }
    }
    
    func space() -> CGFloat {
        return 12
    }
    
    /*-------------------------------------------------------------------------------------*/
    private func font() -> UIFont {
        return UIFont.appFontW6Size(14)
    }
    
    private func paragraphStyle() -> NSParagraphStyle {
        return Utils.getLineSpace(6)
    }
    /*-------------------------------------------------------------------------------------*/
}

enum RacecourseWindsTools: Int {
    case reservedSeatsAdmissionTickets = 0
    case createVotingQR = 1
    case wellCome = 2
    case racecourseInformation = 3
    case windsInformation = 4
    case umaca = 5
    case eventRace = 6
    case IMTFun = 7
    
    func link() -> JMTrans? {
        switch self {
        case .reservedSeatsAdmissionTickets:
            return (TransactionLink.contentLanding.rawValue, false)
        case .createVotingQR:
            return (TransactionLink.qrCode.rawValue, false)
        case .wellCome:
            return (TransactionLink.horseRaceInfoIMTWellcome.rawValue, false)
        case .racecourseInformation:
            return (TransactionLink.racecourseInformation.rawValue, true)
        case .windsInformation:
            return (TransactionLink.windsInformation.rawValue, true)
        case .umaca:
            return nil
        case .eventRace:
            return (TransactionLink.horseRaceInfoIMTEvent.rawValue, false)
        case .IMTFun:
            return (TransactionLink.horseRaceInfoIMTFunEventList.rawValue, false)
        }
    }
    
    func log() {
        var logAction: FlyersActionLog?
        switch self {
        case .createVotingQR:
            logAction = .createVotingQR
            break
        case .windsInformation:
            logAction = .windsInformation
            break
        case .umaca:
            logAction = .umacaSmart
            break
        case .racecourseInformation:
            logAction = .raceCourseInformation
        default:
            break
        }
        
        guard let logAction = logAction else { return }
        Utils.logActionClick(logAction)
    }
}

enum ShareSNSHome: Int {
    case youtube = 0
    case facebook = 1
    case instagam = 2
    case twitter = 3
    
    func link() -> JMTrans? {
        switch self {
        case .youtube:
            return (TransactionLink.horseRaceInfoYoutube.rawValue, false)
        case .facebook:
            return (TransactionLink.horseRaceInfoFacebook.rawValue, false)
        case .instagam:
            return (TransactionLink.horseRaceInfoInstagram.rawValue, false)
        case .twitter:
            return (TransactionLink.horseRaceInfoTwitter.rawValue, false)
        }
    }
}

enum BiometricAuthenticationScreenStyle {
    case signup
    case login
}

enum ApplicationState {
    case foreground
    case background
    case active
    case inactive
}

enum AppVersionUpdateState {
    case none
    case optional
    case force
    
    func message() -> String? {
        switch self {
        case .none, .optional:
            return nil
        case .force:
            return "Force update version"
        }
    }
}

enum CheckVersionFromSituation {
    case separately //Handle the version on this screen.
    case foreground //Handle when it become foreground
    case autoLogin  //Hanele after login
}

enum WarningTopicType: String {
    case show = "0"
    case hide = "1"
}

enum SysEnvCode: String {
    case titleColorCode = "0011"
    case captionColorCode = "0010"
    case captionBgColorCode = "0009"
    case isEnableBtnCode = "0008"
    case forceUpdateCode = "0013"
    case iOSVerUpdateCode = "0014"
    case iOSVerLastUpdateCode = "0016"
    case maximumNumberOfHorsesToBeGuessed = "0018"
    case maximumNumberOfGuessedRiders = "0019"
    case guessHorseRanking = "0020"
    case maximumNumberOfMemorial = "0002"
    case maximumNumberOfNews = "0003"
}

enum DeleteTicketMode {
    case single
    case multiple
    
    func title() -> String {
        switch self {
        case .single:
            return "Delete Selected"
        case .multiple:
            return "Select All"

    }
    
    func swipeToDelete() -> Bool {
        switch self {
        case .single:
            return true
        case .multiple:
            return false
        }
    }
    
    func titleSwipeToDelete() -> String? {
        switch self {
        case .single:
            return "Delete"
        case .multiple:
            return nil
        }
    }
}

enum PreferredDisplayType: String, CaseIterable {
    case east = "A"
    case west = "B"
    case scene3 = "C"
    
    func description() -> String {
        switch self {
        case .east:
            return "Eastern Main Track"
        case .west:
            return "Western Main Track"
        case .scene3:
            return "Third Track"

        }
    }
}

enum MenuSectionType: String, CaseIterable {
    case refund = "Payout"
    case species = "Race"
    case racehorse = "Racehorse"
    case horseRacingAndTrainer = "Jockey & Trainer"
    case reading = "Standings"
    case rulesForHorseRacingAndHorseRacing = "Betting & Racing Rules"
    case facilityInformation = "Facility Information"

    
    func menuItems() -> [MenuItemType] {
        switch self {
        case .refund:
            return [.refundList, .resultAndSearch, .win5]
        case .species:
            return [.racingCalendar, .papaInfo, .featuredRaces, .overseasHorseRacing]
        case .racehorse:
            return [.thisWeekRaceHorseSearch, .raceHorseSearch, .specialRace]
        case .horseRacingAndTrainer:
            return [.jockeyDirectory, .trainerDirectory, .almostAchievedRecord, .newJockeyData]
        case .reading:
            return [.jockeyReading, .trainerReading, .stallionReading]
        case .rulesForHorseRacingAndHorseRacing:
            return [.horseRacingFirstTimeGuide, .horseRacingTicketRule, .whatIsWin5]
        case .facilityInformation:
            return [.raceCourseInformation, .windsInformation]
        }
    }
}

enum MenuItemType: String {
    case refundList = "Payout List"
    case resultAndSearch = "Race Results\nSearch"
    case win5 = "WIN5"
    case racingCalendar = "Racing\nCalendar"
    case papaInfo = "Track Condition Info"
    case featuredRaces = "Featured Races"
    case overseasHorseRacing = "Overseas Horse Racing"
    case thisWeekRaceHorseSearch = "This Week's\nRacehorse Search"
    case raceHorseSearch = "Racehorse Search"
    case specialRace = "Special Races\nRegistered Horses"
    case jockeyDirectory = "Jockey Data"
    case trainerDirectory = "Trainer Data"
    case almostAchievedRecord = "Records\nNear Achievement"
    case newJockeyData = "New Jockey\nData"
    case jockeyReading = "Jockey\nStandings"
    case trainerReading = "Trainer\nStandings"
    case stallionReading = "Stallion\nStandings"
    case horseRacingFirstTimeGuide = "Horse Racing\nBeginner's Guide"
    case horseRacingTicketRule = "Betting\nRules"
    case whatIsWin5 = "What is WIN5"
    case raceCourseInformation = "Racecourse Guide"
    case windsInformation = "WINS Facility Guide"

    
    func image() -> UIImage {
        switch self {
        case .refundList:
            return .bgServiceRefundList
        case .resultAndSearch:
            return .bgServiceResult
        case .win5:
            return .bgServiceWin5
        case .racingCalendar:
            return .bgServiceRacingCalendar
        case .papaInfo:
            return .bgServicePapaInfo
        case .featuredRaces:
            return .bgServiceFeaturedRacing
        case .overseasHorseRacing:
            return .bgServiceOverseasHorseRacing
        case .thisWeekRaceHorseSearch:
            return Constants.allowSearchHorsesRunningThisWeek ? .bgThisWeekRaceHorseSearch : .bgServiceThisWeekRaceHorseSearchDisable
        case .raceHorseSearch:
            return .bgServiceRaceHorseSearch
        case .specialRace:
            return .bgSpecialRace
        case .jockeyDirectory:
            return .bgJockeyDirectory
        case .trainerDirectory:
            return .bgServiceTrainerDirectory
        case .almostAchievedRecord:
            return .bgAlmostAchievedRecord
        case .newJockeyData:
            return .bgNewJockeyData
        case .jockeyReading:
            return .bgJockeyReading
        case .trainerReading:
            return .bgTrainerReading
        case .stallionReading:
            return .bgStallionReading
        case .horseRacingFirstTimeGuide:
            return .bgHorseRacingFirstTimeGuide
        case .horseRacingTicketRule:
            return .bgHorseRacingTicketRule
        case .whatIsWin5:
            return .bgWhatIsWin5
        case .raceCourseInformation:
            return .bgRaceCourseInformation
        case .windsInformation:
            return .bgWindsInformation
        }
    }
    
    func link() -> JMTrans? {
        switch self {
        case .refundList:
            return (TransactionLink.refundList.rawValue, true)
        case .resultAndSearch:
            return (TransactionLink.raceResultSearch.rawValue, true)
        case .win5:
            return (TransactionLink.win5.rawValue, true)
        case .racingCalendar:
            return (TransactionLink.racingCalendar.rawValue, true)
        case .papaInfo:
            return (TransactionLink.papaInfo.rawValue, true)
        case .featuredRaces:
            return (TransactionLink.featuredRacesOfTheWeek.rawValue, true)
        case .overseasHorseRacing:
            return (TransactionLink.featuredRacesOverseas.rawValue, true)
        case .thisWeekRaceHorseSearch:
            return Constants.allowSearchHorsesRunningThisWeek ? (TransactionLink.searchHorsesRunningThisWeek.rawValue, true) : nil
        case .raceHorseSearch:
            return (TransactionLink.raceHorseSearch.rawValue, true)
        case .specialRace:
            return (TransactionLink.specialRace.rawValue, true)
        case .jockeyDirectory:
            return (TransactionLink.jockeyDirectory.rawValue, true)
        case .trainerDirectory:
            return (TransactionLink.trainerDirectory.rawValue, true)
        case .almostAchievedRecord:
            return (TransactionLink.almostAchievedRecord.rawValue, true)
        case .newJockeyData:
            return (TransactionLink.newJockeyData.rawValue, true)
        case .jockeyReading:
            return (TransactionLink.jockeyReading.rawValue, true)
        case .trainerReading:
            return (TransactionLink.trainerReading.rawValue, true)
        case .stallionReading:
            return (TransactionLink.stallionReading.rawValue, true)
        case .horseRacingTicketRule:
            return (TransactionLink.horseRacingTicketRule.rawValue, true)
        case .whatIsWin5:
            return (TransactionLink.whatIsWin5.rawValue, true)
        case .raceCourseInformation:
            return (TransactionLink.racecourseInformation.rawValue, true)
        case .windsInformation:
            return (TransactionLink.windsInformation.rawValue, true)
        default :
            return nil
        }
    }
}

enum ListFavoriteSearchResultType {
    case favorite
    case recommended
    
    func legend() -> String {
        switch self {
        case .favorite:
            return ""
        case .recommended:
            return ""
        }
    }
    
    func title(_ search: String, _ number: Int) -> String {
        switch self {
        case .favorite:
            return "Search results for \"\(search)\" \n\(number) people"
        case .recommended:
            return "Search results for \"\(search)\" \n\(number) horses"

        }
    }
    
    func label() -> String {
        switch self {
        case .favorite:
            return ""
        case .recommended:
            return "Select the horse you want to add as a favorite"

        }
    }
    
    func limitError() -> String {
        switch self {
        case .favorite:
            return "The number of results exceeds 50.\nPlease narrow your search criteria and try again."
        case .recommended:
            return "You have reached the limit of 30 favorite horses.\nPlease remove another favorite horse before adding a new one."

        }
    }
    
    func limitErrorTextAlignment() -> NSTextAlignment {
        switch self {
        case .favorite:
            return .center
        case .recommended:
            return .left
        }
    }
    
    func itemLabel() -> String {
        switch self {
        case .favorite:
            return "Select the jockey you want to add as a favorite"
        case .recommended:
            return "Select the horse you want to add as a favorite"

        }
    }
    
    func isFavorite() -> Bool {
        return self == .favorite
    }
}

enum TopFavorite: Int {
    case top1 = 1
    case top2 = 2
    case top3 = 3
    
    func crownImage() -> UIImage? {
        switch self {
        case .top1:
            return .icCrown1
        case .top2:
            return .icCrown2
        case .top3:
            return .icCrown3
        }
    }
}

enum FilterSectionType: String, CaseIterable {
    case affiliation = "Affiliation"
    case sex = "Gender"
    case activeOrCancelled = "Status (Active/Retired)"

    
    func filterItems() -> [FilterItemType] {
        switch self {
        case .affiliation:
            return [.miura, .ritto]
        case .sex:
            return [.stallion, .mare, .geldingHorse]
        case .activeOrCancelled:
            return [.activeDuty, .deletion]
        }
    }
}

enum FavoritePageState {
    case favorite
    case unfavorite
    case none
}

enum FilterItemType: String {
    case miura = "Miho"              // Training center name
    case ritto = "Ritto"             // Training center name
    case stallion = "Colt/Stallion"  // Male horse
    case mare = "Filly/Mare"         // Female horse
    case geldingHorse = "Gelding"    // Castrated male horse
    case activeDuty = "Active"
    case deletion = "Retired"

    
    func defaultValue() -> Bool {
        switch self {
        case .deletion:
            return false
        default:
            return true
        }
    }
    
    func value() -> String {
        switch self {
        case .miura:
            return "1"
        case .ritto:
            return "2"
        case .stallion:
            return "1"
        case .mare:
            return "2"
        case .geldingHorse:
            return "3"
        case .activeDuty:
            return "0"
        case .deletion:
            return "1"
        }
    }
}

enum RoutineHorseSegment: Int, CaseIterable {
    case cumulative
    case weekly
    
    func text() -> String {
        switch self {
        case .cumulative:
            return "Cumulative"
        case .weekly:
            return "Weekly"

        }
    }
    
    func title() -> String {
        switch self {
        case .cumulative:
            return "Top 10 Favorite Horse Rankings"
        case .weekly:
            return "Top 10 Favorite Horse Rankings"

        }
    }
}

enum ListFavoriteSearchResultPopupType {
    case wouldYouLikeToRegisterAsAFavorite
    case iHaveRegisteredAsAFavorite
    case alreadyRegisteredAsAFavorite
}

enum ListFavoriteSearchResultErrorType: Equatable {
    case moreThan50OfItem
    case maximumLimitOfRaceHorse(_ limit: Int)
    case maximumLimitOfJockey(_ limit: Int)
    case none
    
    func message() -> String? {
        switch self {
        case .moreThan50OfItem:
            return "The number of matching results exceeds 50.\nPlease narrow your search criteria and try again."

        case .maximumLimitOfRaceHorse(let limit):
            return "You have reached the maximum limit of \(limit) registered favorite horses.\nPlease remove another favorite horse before adding a new one."

        case .maximumLimitOfJockey(let limit):
            return "You have reached the maximum limit of \(limit) registered favorite jockeys.\nPlease remove another favorite jockey before adding a new one."

        case .none:
            return nil
        }
    }
    
    static func == (lhs: ListFavoriteSearchResultErrorType, rhs: ListFavoriteSearchResultErrorType) -> Bool {
        return lhs.message() == rhs.message()
    }
}

enum W04JOEWKB: String {
    case miho = "1"
    case ritto = "2"

    
    var color: UIColor {
        switch self {
        case .miho:
            return .lapisLazuli
        case .ritto:
            return .internationalOrange
        }
    }
    
    var string: String {
        return "\(self)"
    }
}

enum J01SEXCOD: String {
    case male = "1"
    case female = "2"
    case sen = "3"
    
    func text() -> String {
        switch self {
        case .male:
            return "Colt/Stallion"   // "牡" (depending on age: Colt if young, Stallion if mature)
        case .female:
            return "Filly/Mare"      // "牝" (Filly if young, Mare if mature)
        case .sen:
            return "Gelding"         // "せん" (a castrated male horse)

        }
    }
}

enum Abbreviations: String, CaseIterable {
    case a
    case ka
    case sa
    case ta
    case na
    case ha
    case ma
    case ya
    case ra
    case wa

    
    func value() -> String {
        switch self {
        case .a:
            return "A"
        case .ka:
            return "K"
        case .sa:
            return "S"
        case .ta:
            return "T"
        case .na:
            return "N"
        case .ha:
            return "H"
        case .ma:
            return "M"
        case .ya:
            return "Y"
        case .ra:
            return "R"
        case .wa:
            return "W"
        }
    }
}

enum IMTTag: Int {
    case maskView = 999
}
