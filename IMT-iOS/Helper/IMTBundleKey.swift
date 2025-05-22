//
//  IMTBundleKey.swift
//  IMT-iOS
//
//  Created by dev on 05/05/2023.
//

import Foundation

enum HomeBundleKey: String {
    case object = "object"
    case listQRModel = "listQRModel"
    case openScanQR = "openScanQR"
    case transInfo = "transInfo"
    case votingOnlineType = "votingOnlineType"
    case preferenceFeature = "preferenceFeature"
}

enum RaceBundleKey: String {
    case object = "object"
    case votingOnlineType = "votingOnlineType"
    case transInfo = "transInfo"
}

enum MenuBundleKey: String {
    case object = "object"
    case votingOnlineType = "votingOnlineType"
    case updatePersonalInfo = "updatePersonalInfo"
    case detailNotification = "detailNotification"
    case detailNotificationURL = "detailNotificationURL"
    case oldAccount = "oldAccount"
    case confirmOtp = "confirmOtp"
    case resetPassword = "resetPassword"
    case message = "message"
    case email = "email"
    case password = "password"
    case umacaTicket = "umacaTicket"
    case preferenceFeature = "preferenceFeature"
}

enum LiveBundleKey: String {
    case object = "object"
    case votingOnlineType = "votingOnlineType"
}

enum ConfirmOTPBundleKey: String {
    case email = "email"
    case newEmail = "newEmail"
    case userId = "userId"
    case checkMailData = "checkMailData"
    case sendOTPData = "sendOTPData"
    case changeEmailData = "changeEmailData"
}

enum NotificationBundleKey: String {
    case detail = "dataDetail"
}

enum ResultChangeEmailBundleKey: String {
    case result = "result"
    case errorMessage = "errorMessage"
    case email = "email"
    case password = "password"
}
