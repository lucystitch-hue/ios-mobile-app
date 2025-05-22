//
//  IMTTypeAlias.swift
//  IMT-iOS
//
//  Created by dev on 05/05/2023.
//

import Foundation
import UIKit
import LocalAuthentication

//MARK: Closure type
typealias JVoid = (() -> Void)
typealias JBool = ((Bool) -> Void)
typealias JColor = ((UIColor) -> Void)
typealias JTrans = ((JMTrans) -> Void)
typealias JLinks = ((JMLink) -> Void)
typealias JTransAgent = ((JMTransAgent) -> Void)
typealias JString = ((String) -> Void)
typealias JView = ((UIView) -> Void)
typealias JDouble = ((Double) -> Void)
typealias JAny = ((Any?) -> Void)
typealias JBundle = (([String: Any]?) -> Void)
typealias JTabScreenInfo = ((JTabInfo) -> Void)
typealias JTabScreen = ((IMTTab) -> Void)
typealias JTabScreenAndMessage = ((JTabAndMessage) -> Void)
typealias JBiometricError = ((JMBiometricError) -> Void)
typealias JInt = ((Int) -> Void)

//MARK: Normal type
typealias IMTceData = (races: [RaceInfoModel], holidays: [String])
typealias JMTrans = (url: String, useWebView: Bool) ///Abbreviation: Method of transition. If useWebView is no, It uses the Safari browser.
typealias JMTransAgent = (url: String, userAgent: String?) ///It use webView
typealias JMLink = (url: String, post: Bool)
typealias JValidate = (message: IMTErrorMessage?, valid: Bool)
typealias JSettingNotification = [SettingsNotificationSection: [ISettingNotificationModel]]
typealias JTabInfo = (tab: IMTTab, data: FIRNotificationModel)
typealias JMBiometricError = (errorCode: LAError.Code, message: String)
typealias JTabAndMessage = (tab: IMTTab, message: String?)
