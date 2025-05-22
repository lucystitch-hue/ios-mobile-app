//
//  NotificationManager.swift
//  IMT-iOS
//
//  Created by dev on 05/07/2023.
//

import Foundation
import UIKit
import Firebase

class NotificationManager: NSObject {
    
    private static var notificationManager: NotificationManager!
    
    static func share() -> NotificationManager {
        if(notificationManager == nil) {
            notificationManager = NotificationManager()
        }
        
        return notificationManager
    }
    
    private lazy var networkManager: NetworkManager = NetworkManager()
}

extension NotificationManager {
    public func updateBadge() {
        networkManager.call(endpoint: .notificationsCount, showLoading: false, completion: responseNotificationCount)
    }
    
    public func markAll(_ completion: @escaping(([NotificationModel]?) -> Void)) {
        let showLoading = Utils.hasIncommingNotification()
        networkManager.call(endpoint: .notificationRead, showLoading: showLoading, completion: responseReadNotification)
        
        func responseReadNotification(_ response: ReponseReadNotification?, success: Bool) {
            self.response(response) { res in
                Utils.updateCountNotification(0)
                completion(response?.data)
            }
        }
    }
    
    public func mark(code messageCode: String, completion: @escaping(([DetailNotificationModel]?) -> Void)) {
        let showLoading = Utils.hasIncommingNotification()
        networkManager.call(endpoint: .notificationDetail(messageCode: messageCode.replacingOccurrences(of: " ", with: "%20")), showLoading: showLoading, completion: responseDetail)
        
        func responseDetail(_ response: ReponseDetailNotification?, success: Bool) {
            self.response(response) { res in
                NotificationManager.share().updateBadge()
                completion(res.data)
            }
        }
    }
    
    public func unsubscribeTopics() {
        if let userIdTopic = UserManager.share().user?.userId {
            Messaging.messaging().unsubscribe(fromTopic: userIdTopic)
        }
        
        let topics = SettingsNotificationItem.allCases.map({ return $0.topic() })
        topics.forEach { topic in
            Messaging.messaging().subscribe(toTopic: topic)
        }
    }
}

extension NotificationManager {
    private func response<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void), failureCompletion:@escaping(JVoid) = {}) {
        guard let response = response else { return }
        if(response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            dump("### Error notification: \(message)")
            failureCompletion()
        }
    }
    
    private func responseNotificationCount(_ response: ResponseCountNotification?, success: Bool) {
        self.response(response) { res in
            let count = res.data?.count ?? 0
            Utils.updateCountNotification(count)
        }
    }
}
