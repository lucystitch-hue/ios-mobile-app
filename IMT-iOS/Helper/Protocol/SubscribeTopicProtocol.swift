//
//  SubcribeTopicProtocol.swift
//  IMT-iOS
//
//  Created on 24/04/2024.
//
    

import Foundation
import Firebase

protocol SubscribeTopicProtocol {
    func subscribeBy(_ topic: String)
    func unsubscribeBy(_ topic: String)
    func getNotificationSetting() async throws -> NotificationsSettingDataModel
}

extension SubscribeTopicProtocol {
    func subscribeBy(_ topic: String) {
        Messaging.messaging().subscribe(toTopic: topic) { error in print("### subscribe topic: \(topic)") }
    }
    
    func unsubscribeBy(_ topic: String) {
        Messaging.messaging().unsubscribe(fromTopic: topic) { error in print("### unsubscribe topic: \(topic)") }
    }
    
    func getNotificationSetting() async throws -> NotificationsSettingDataModel {
        try await withCheckedThrowingContinuation { continuation in
            NetworkManager.share().call(endpoint: .setting, showLoading: false, completion: response)
            
            func response(_ response: ResponseNotificationsSetting?, success: Bool) {
                if let response = response,
                   let data = response.data {
                    continuation.resume(returning: data)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
}

protocol SubscribePreferenceTopic: SubscribeTopicProtocol {
    func getListOshiUma() async throws -> [OshiUma]
    func getListOshiKishu() async throws -> [OshiKishu]
}

extension SubscribePreferenceTopic {
    func getListOshiUma() async throws -> [OshiUma] {
        try await withCheckedThrowingContinuation { continuation in
            NetworkManager.share().call(endpoint: .getOshiUmaList, showLoading: false, completion: response)
            
            func response(_ response: ResponseOshiUma?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
    
    func getListOshiKishu() async throws -> [OshiKishu] {
        try await withCheckedThrowingContinuation { continuation in
            NetworkManager.share().call(endpoint: .getOshiKishuList, showLoading: false, completion: response)
            
            func response(_ response: ResponseOshiKishu?, success: Bool) {
                if let response = response {
                    continuation.resume(returning: response.items)
                } else {
                    continuation.resume(throwing: IMTError.noMessages)
                }
            }
        }
    }
}
