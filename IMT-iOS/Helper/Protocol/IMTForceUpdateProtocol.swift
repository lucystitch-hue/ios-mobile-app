//
//  IMTForceUpdateProtocol.swift
//  IMT-iOS
//
//  Created by dev on 17/11/2023.
//

import Foundation

protocol IMTForceUpdateProtocol {
    //MARK: Properties
    /**
     - Description: Handle on controller after it checked app version.
     */
    var onDidResultCheckVerion:((AppVersionUpdateState) -> Void) { get set }
    
    //MARK: Functions
    /**
     - Description: Check version adopt api sysEnv since build version January 2024.
     - parameter continue: Handle when none upgrade
     - parameter situation: It is situation when check force upate
     - returns:onDidResultCheckVerion.
     */
    func checkVersion(continue:(JVoid?), situation: CheckVersionFromSituation)
    
    /**
     - Description: Check version adopt api sysEnv since build version January 2024.
     - parameter continue: Handle when none upgrade
     - parameter situation: It is situation when check force upate. **Includes: separately
     - returns:completion.
     */
    func checkVersion(continue:JVoid?, situation: CheckVersionFromSituation, completion:@escaping((_ state: AppVersionUpdateState) -> Void))
    func checkVersionBecomeForeground() -> Bool
    func checkVersionWhenRunApp() -> Bool
    
    /**
     - Description: Update value after the app is new version.
     */
    func updateCacheCheckAppVersion(_ value: String)
    
    /**
     - Description: Show optional or require popup when current app version smaller than last version.
     - parameter controller: parent controller.
     - parameter state: state after check app version.
     - parameter cancelHandler: closure when touch button cancle on popup **Not nil: Handle on controller. Nil: Handle on viewModel
     */
    func showPopupUpgrade(_ controller: BaseViewController?, state: AppVersionUpdateState, cancelHandler cancel:JVoid?)
    
    /**
     - Description: Handle when touch cancel on optional popup. Only handle when agrument cancelHandler equal nil
     */
    func continueWhenCancelUpgrade(_ controller: BaseViewController?)
}

extension IMTForceUpdateProtocol {
    
    func checkVersion(continue: (JVoid?) = nil, situation: CheckVersionFromSituation = .separately) {
        let check = shouldCheck(situation)
        
        if(check) {
            NetworkManager.share().call(endpoint: .sysEnv, showLoading: false, completion: response)
            
            func response(_ response: ResponseSysEnv?, success: Bool) {
                responseSysEnv(response, success: success, continue: `continue`)
            }
        }
    }
    
    func checkVersion(continue:JVoid?, situation: CheckVersionFromSituation = .separately, completion:@escaping((_ state: AppVersionUpdateState) -> Void)) {
        let check = shouldCheck(situation)
        
        if(check) {
            NetworkManager.share().call(endpoint: .sysEnv, showLoading: false, completion: response)
            
            func response(_ response: ResponseSysEnv?, success: Bool) {
                responseSysEnv(response, success: success, continue: `continue`, completion)
            }
        }
    }
    
    func checkVersionBecomeForeground() -> Bool {
        return true
    }
    
    func checkVersionWhenRunApp() -> Bool {
        return false
    }
    
    func updateCacheCheckAppVersion(_ value: String) {
        Utils.updateCacheCheckAppVersion(value)
    }
    
    func showPopupUpgrade(_ controller: BaseViewController?, state: AppVersionUpdateState, cancelHandler cancel:JVoid? = nil) {
        guard let controller = controller else { return }
        execute()
        
        /*----------------------------------------------------------------------------------------------*/
        func execute() {
            switch state {
            case .none:
                break
            case .optional:
                actionOptionalUpgrade()
                break
            case .force:
                actionForceUpgrade()
                break
            }
        }
        
        func actionOptionalUpgrade() {
            controller.showWarningRequestUpgrade({ action, warnVC in
                if(action == .cancel) {
                    if let cancel = cancel {
                        cancel()
                    } else {
                        continueWhenCancelUpgrade(controller)
                    }
                    
                    self.updateCacheCheckAppVersion("")//Bỏ dòng này nếu muốn khi có version mới thì mới showpopup ở lần tiếp.
                    warnVC?.close()
                } else {
                    gotoAppStore()
                }
            })
        }
        
        func actionForceUpgrade() {
            controller.showWarningForceUpgrade({ action, warnVC in
                gotoAppStore()
            })
        }
        
        func gotoAppStore() {
            let trans = (TransactionLink.myApp.rawValue, false)
            controller.transition(info: trans)
        }
        /*----------------------------------------------------------------------------------------------*/
    }
}

//MARK: Private
extension IMTForceUpdateProtocol {
    private func responseSysEnv(_ response: ResponseSysEnv?, success: Bool, continue: JVoid?, _ completion:((_ state: AppVersionUpdateState) -> Void)?) {
        guard let aysy01 = response?.aysy01 else { return }
        //        guard let iAysy02 = response?.aysy02?.first else { return }
        
        var optionalVerion: String?
        var forceVersion: String?
        var forceUpdateValue: String?
        
        for i in 0..<aysy01.count {
            let item = aysy01[i]
            
            let code = item.sys01keycode
            let value = item.sys01value
            let type = SysEnvCode(rawValue: code)
            
            switch type {
            case .forceUpdateCode:
                forceUpdateValue = value
                break
            case .iOSVerUpdateCode:
                forceVersion = value
                break
            case .iOSVerLastUpdateCode:
                optionalVerion = value
                break
            default:
                break
            }
            
            if let _ = optionalVerion,
               let _ = forceVersion,
               let _ = forceUpdateValue {
                break
            }
        }
        
        //MARK: Return update state
        /**True: show adopt ugrentNoticeView, False: show adopt popup */
        //        let isUpgradeByUgentNotice = iAysy02.yukoFlg == "1" && forceUpdateValue == "1"
        let state = checkVersionState(urgentNoticeKind: false, optionalVersion: optionalVerion, forceVersion: forceVersion)
        
        //MARK: Handle state
        if let `continue` = `continue`, state == .none {
            `continue`()
        }
        
        if let completion = completion {
            completion(state)
        } else {
            self.onDidResultCheckVerion(state)
        }
    }
    
    private func responseSysEnv(_ response: ResponseSysEnv?, success: Bool, continue: JVoid?) {
        self.responseSysEnv(response, success: success, continue: `continue`, nil)
    }
    
    /**
     - Description  : Compare between current and new versions.
     
     - parameter urgentNoticeKind: True: For build December 2023, False: Since build January 2024.
     - parameter optionalVersion: get optional version from api sysEnv.
     - parameter forceVersion: get force version from api sysEnv.
     
     - returns: AppVersionUpdateState
     */
    private func checkVersionState(urgentNoticeKind: Bool,
                                   optionalVersion: String?,
                                   forceVersion: String?) -> AppVersionUpdateState {
        if(!urgentNoticeKind) {
            guard let optionalVersion = optionalVersion,
                  let forceVersion = forceVersion else { return .none }
            
            let currentVersion = Bundle.main.releaseVersionNumberPretty
            let forceCompare = Utils.compareVersion(currentVersion, forceVersion)
            
            if(forceCompare == .orderedAscending) {
//                let needCheckVersion = self.checkVersionIfNeed(forceVersion)
//                self.updateCacheCheckAppVersion(forceVersion)
//                return needCheckVersion ? .force : .none
                return .force
            } else {
                let optionalCompare = Utils.compareVersion(currentVersion, optionalVersion)
                if((forceCompare == .orderedDescending || forceCompare == .orderedSame) && optionalCompare == .orderedAscending) {
//                    let needCheckVersion = self.checkVersionIfNeed(optionalVersion)
//                    self.updateCacheCheckAppVersion(optionalVersion)
//                    return needCheckVersion ? .optional : .none
                    return .optional
                }
            }
        }
        
        return .none
    }
    
    private func checkVersionIfNeed(_ lastVersion: String) -> Bool {
        return lastVersion != Constants.lastVersionCheck
    }
    
    private func shouldCheck(_ situation: CheckVersionFromSituation) -> Bool {
        let flagBecomeForeground = checkVersionBecomeForeground() && situation == .foreground
        let flagRunApp = checkVersionWhenRunApp() && situation == .autoLogin
        let flagSeparately = situation == .separately
        
        return flagBecomeForeground || flagRunApp || flagSeparately
    }
}
