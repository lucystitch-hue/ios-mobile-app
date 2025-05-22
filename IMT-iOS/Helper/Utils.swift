//
//  Utils.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation
import UIKit
import KeychainSwift
import SVProgressHUD
import AVFoundation
import AppsFlyerLib
import Firebase
import Toast_Swift

class Utils {
    static let infoDict: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist is not found")
        }
        return dict
    }()
    
    static func loadJson<T: BaseResponse>(filename fileName: String, type: T.Type) -> T? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
    
    static func showProgress(_ priority: Bool = true) {
        if(priority) {
            if(!SVProgressHUD.isVisible()) {
                SVProgressHUD.setDefaultMaskType(.black)
                SVProgressHUD.show()
            }
        } else {
            SVProgressHUD.show()
        }
    }
    
    static func hideProgress() {
        SVProgressHUD.dismiss()
    }
    
    static func inprogress() -> Bool {
        return SVProgressHUD.isVisible()
    }
    
    static func pushDetailScreenAt(_ tab: IMTTab) {
        Utils.postObserver(.openScreenFromNotify, object: tab)
    }
    
    static func pushTab(_ tab: IMTTab) {
        Utils.postObserver(.openTab, object: tab)
    }
    
    static func pushTabAndMessage(_ tab: JTabAndMessage) {
        Utils.postObserver(.openTabAndMessage, object: tab)
    }
    
    static func gotoHome(_ needDelay: Bool = false) {
        if(needDelay) {
            Utils.showProgress()
            
            Utils.mainAsyncAfter {
                Utils.hideProgress()
                Utils.postObserver(.didLoginSuccessfully, object: true)
            }
        } else {
            Utils.postObserver(.didLoginSuccessfully, object: true)
        }
    }
}

//MARK: Notification
extension Utils {
    static func hasNotification() -> Bool {
        return Constants.countNotification != 0
    }
    
    static func updateCountNotification(_ value: Int) {
        Constants.countNotification = value
        UIApplication.shared.applicationIconBadgeNumber = value
        Utils.postObserver(.onCountNotification, object: value)
    }
    
    static func hasIncommingNotification() -> Bool {
        return Constants.incomingNotification != nil
    }
    
    static func clearDataIncommingNotification() {
        Constants.incomingNotification = nil
    }
}

//MARK: Constraint
extension Utils {
    static func constraintFull(parent: UIView, child: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: parent.topAnchor),
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
    }
    
    static func constraintFullWithBottomSafeArea(parent: UIView, child: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        let guide = parent.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: parent.topAnchor),
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            child.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor)
        ])
    }
}

//MARK: Device
extension Utils {
    static func scaleDesign() -> Double {
        // on Iphone 14 Pro
        let hDesign = 1624.0
        let wDesign = 750.0
        let rDesign = hDesign / wDesign
        
        let isLandscape = UIScreen.main.bounds.width > UIScreen.main.bounds.height
        let hScreen = isLandscape ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
        let wScreen = isLandscape ? UIScreen.main.bounds.height : UIScreen.main.bounds.width
        let rScreen = hScreen / wScreen
        
//        let isIphoneSE1 = UIScreen.main.bounds.height == Constants.hScreenSE1
        
        let scale = rScreen / rDesign
//        let deviceScale = (UIScreen.main.scale - UIScreen.main.nativeScale) / UIScreen.main.scale
        
        return scale
    }
    
    static func scaleWithHeight(_ height: Double) -> Double {
        let scale = Utils.scaleDesign()
        let autoHeight = height * scale
        
        return autoHeight
    }
    
    static func permissionCamera(completion:@escaping(Bool) -> Void) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            completion(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    if granted {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            })
        }
    }
    
    static func smallScreen() -> Bool {
        return UIScreen.main.bounds.size.width <= Constants.hScreenSE1
    }
}

//MARK: Observer
extension Utils {
    static func postObserver(_ notificationName: NotificationName, object: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationName.rawValue), object: object);
    }
    
    static func onObserver(_ observer: Any, selector: Selector, name: NotificationName, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(name.rawValue), object: object)
    }
    
    static func removeObserver(_ observer: Any,name: NotificationName) {
        NotificationCenter.default.removeObserver(observer, name: Notification.Name(name.rawValue), object: nil)
    }
    
    static func postLogout() {
        Constants.firstLogin = false
        UserManager.share().removeUser()
        NotificationManager.share().unsubscribeTopics()
        Utils.refreshDataOfSession()
        Messaging.messaging().deleteToken { temp in }
        Utils.postObserver(.didLoginSuccessfully, object: true)
        UserManager.share().clearAccessDate()
        Utils.updateCacheCheckAppVersion("")
    }
    
    static func refreshDataOfSession() {
        Constants.flagFutureRace = false
        Constants.needToCheckFutureRace = false
        Constants.displayDefaultPreferredSetting = false
//        Utils.deleteUserDefault(key: .userId)
    }
}

//MARK: String
extension Utils {
    static func attributeLineBreak(strings: [String], space: CGFloat = 0.5) -> NSAttributedString {
        let attrs = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        
        strings.enumerated().forEach { (index, string) in
            var attr = NSAttributedString()
            
            if(index != strings.count - 1) {
                attr = NSAttributedString(string: "\(string)\n", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
            } else {
                attr = NSAttributedString(string: "\(string)")
            }
            
            attrs.append(attr)
        }
        
        return attrs
    }
    
    static func getLineSpace(_ space: CGFloat? = nil, alignment: NSTextAlignment = .center) -> NSMutableParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()
        
        if let space = space {
            paragraphStyle.lineSpacing = space
        }
        paragraphStyle.alignment = alignment
        
        return paragraphStyle
    }
}

//MARK: Keychain
extension Utils {
    static func existKeyChain(key: KeyChain) -> Bool{
        let keyChain = KeychainSwift()
        return keyChain.get(key.rawValue) != nil
    }
    
    static func getKeyChain(key: KeyChain) -> String? {
        let keyChain = KeychainSwift()
        return keyChain.get(key.rawValue)
    }
    
    static func setKeyChain(value: String, forKey key: KeyChain) {
        let keyChain = KeychainSwift()
        keyChain.set(value, forKey: key.rawValue)
    }
    
    static func deleteKeyChain(key: KeyChain) {
        let keyChain = KeychainSwift()
        keyChain.delete(key.rawValue)
    }
}

//MARK: UserDefault
extension Utils {
    static func existUserDefault(key: KeyUserDefaults) -> Bool{
        return Utils.getUserDefault(key: key) != nil
    }
    
    static func getUserDefault(key: KeyUserDefaults) -> String? {
        let userDefault = UserDefaults.standard
        guard let value = userDefault.object(forKey: key.rawValue) as? String else { return nil }
        return value
    }
    
    static func getDictUserDefault(key: KeyUserDefaults) -> [String: Any]? {
        let userDefault = UserDefaults.standard
        guard let value = userDefault.object(forKey: key.rawValue) as? [String: Any] else { return nil }
        return value
    }
    
    static func setUserDefault(value: String, forKey key: KeyUserDefaults) {
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key.rawValue)
    }
    
    static func setDictUserDefault(value: [String: Any], forKey key: KeyUserDefaults) {
        let userDefault = UserDefaults.standard
        userDefault.set(value, forKey: key.rawValue)
    }
    
    static func deleteUserDefault(key: KeyUserDefaults) {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: key.rawValue)
    }
    
    static func setPreferredDisplaySetting(value: PreferredDisplayType = .east ) {
        let key = Utils.getKeyPrefferedDisplaySetting()
        UserDefaults.standard.set(value.rawValue, forKey: key)
    }
    
    static func getPreferredDisplaySetting() -> String {
        let key = Utils.getKeyPrefferedDisplaySetting()
        guard let value = UserDefaults.standard.value(forKey: key) as? String else { return PreferredDisplayType.east.rawValue }
        return value
    }
}

//MARK: Enviroment
extension Utils {
    static func getEnviroment() -> Enviroment {
        guard let info = Utils.infoDict["ENVIROMENT"] as? String,
              let env = Enviroment(rawValue: info) else { return .develop }
        
        return env
    }
}

//MARK: Async
extension Utils {
    static func mainAsync(_ completion:@escaping(JVoid)) {
        DispatchQueue.main.async {
            completion()
        }
    }
    
    static func mainAsyncAfter(_ delay: CGFloat = Constants.System.delayAPI, completion:@escaping(JVoid)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: completion)
    }
    
    static func backgroundAsync(_ completion:@escaping(JVoid)) {
        DispatchQueue.global().async {
            completion()
        }
    }
}

//MARK: Logs
extension Utils {
    static func flyersAppDevKey() -> String {
        guard let key = Utils.infoDict["FLYERS_APP_DEV_KEY"] as? String else {
            fatalError("APP_FLYERS_DEV_ID is not found")
        }
        return key
    }
    
    static func appleAppId() -> String {
        guard let id = Utils.infoDict["APPLE_APP_ID"] as? String else {
            fatalError("APPLE_APP_ID is not found")
        }
        return id
    }
    
    static func log(_ eventName: String, values: [String: Any]) {
        AppsFlyerLib.shared().logEvent(name: eventName, values: values, completionHandler: {dict, error in
            if let error = error {
                dump("AppFlyers error description: \(error)")
            } else {
                guard let dict = dict else { return }
                dump("AppFlyers return data: \(dict)")
            }
        })
    }
    
    static func logActionClick(_ log: FlyersActionLog) {
        let eventName = log.rawValue
        let eventValues = log.values()
        Utils.log(eventName, values: eventValues)
    }
}

//MARK: Others
extension Utils {
    static func getLinkFaqMail() -> String {
        guard var email = UserManager.share().user?.email.decrypt() else { return "" }
        email = email.replacingOccurrences(of: "+", with: "%2B")
        let `protocol` = NetworkManager.protocolMain
        let domain = NetworkManager.domainMain
        let version = (Bundle.main.releaseVersionNumberPretty)
        return "\(TransactionLink.faqMail.rawValue)?email=\(email)&ver=\(version)"
    }
    
    static func loadUrl(_ url: URL?, successCompletion: @escaping(JVoid), failureCompletion:(JVoid?) = nil) {
        if let url = url {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) {data, response, error in
                if let data = data,
                   let _ = String(data: data, encoding: .utf8) {
                    successCompletion()
                } else {
                    failureCompletion?()
                }
            }.resume()
        } else {
            failureCompletion?()
        }
    }
    
    static func updateCacheCheckAppVersion(_ value: String) {
        Constants.lastVersionCheck = value
    }
    
    static func compareVersion(_ version1: String, _ version2: String) -> ComparisonResult {
        return version1.compare(version2, options: .numeric)
    }
    
    static func getToastStyle(_ useImage: Bool = false) -> ToastStyle {
        var style = ToastStyle()
        
        style.messageFont = UIFont.appFontW4Size(12)
        style.messageColor = UIColor.black
        style.messageAlignment = .center
        style.backgroundColor = UIColor.white
        style.shadowRadius = CGFloat(15.0)
        style.shadowOffset = CGSize(width: 6.0, height: 6.0)
        if(useImage) {
            style.imageSize = CGSize(width: 20.0, height: 15.0)
        }
        
        return style
    }
    
    private static func getKeyPrefferedDisplaySetting() -> String {
        guard let email = Utils.getUserDefault(key: .email) else { return "" }
        return "\(KeyUserDefaults.preferredDisplaySetting.rawValue)_\(email)"
    }
}

//MARK: Subscribe topic
extension Utils {
    static func getTopic(_ sendkbn: String, cname: String?) -> String {
        let cnameValue = Int(cname ?? "") ?? 0
        return String(format: "\(sendkbn)%010d", cnameValue)
    }
}
