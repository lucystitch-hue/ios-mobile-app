//
//  IMTActivityItemSource.swift
//  IMT-iOS
//
//  Created by dev on 04/05/2023.
//

import Foundation
import UIKit
import LinkPresentation

class MessageActivityItemSource: NSObject, UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return NSObject()
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        
        if activityType == .postToTwitter  {
            return ShareTicket.twitter.hashtag()
        } else if (activityType == .postToFacebook ){
            return ShareTicket.facebook.hashtag()
        } else if activityType == UIActivity.ActivityType.line {
            return ShareTicket.line.hashtag()
        } 
        return nil
    }
    
    @available(iOS 13.0, *)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = "IMT"
        metadata.iconProvider = NSItemProvider(object: UIImage.icCircleApp)
        metadata.originalURL = URL(fileURLWithPath: "share image")
        return metadata
    }
}

class ImageActivityItemSource: NSObject, UIActivityItemSource {
    
    var image: UIImage
    
    init(_ image: UIImage) {
        self.image = image
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        image
    }
}

extension UIActivity.ActivityType {
    
    static let discord = UIActivity.ActivityType(rawValue: "")
    static let viber = UIActivity.ActivityType(rawValue: "")
    static let telegram = UIActivity.ActivityType(rawValue: "")
    static let line = UIActivity.ActivityType(rawValue: "")
    static let reminders = UIActivity.ActivityType(rawValue: "")
    static let notes = UIActivity.ActivityType(rawValue: "")
    static let saveToFile = UIActivity.ActivityType(rawValue: "")
    static let instagram = UIActivity.ActivityType(rawValue: "")
    static let zalo = UIActivity.ActivityType(rawValue: "")
    static let capcut = UIActivity.ActivityType(rawValue: "")
}
