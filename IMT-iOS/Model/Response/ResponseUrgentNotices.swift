//
//  ResponseUrgentNotices.swift
//  IMT-iOS
//
//  Created by dev on 20/06/2023.
//

import UIKit

struct UrgentNoticesDataModel: DataModel {
    var titleColor: String?
    var caption: String?
    var captionColor: String?
    var captionBgColor: String?
    var title: String?
    var info: String?
    
    func convertToWaringViewConfiguration() -> WarningViewConfiguration {
        var configuration = WarningViewConfiguration()
        configuration.title = title
        
        if let titleColor = titleColor {
            configuration.titleColor = titleColor.toRGB()
        }
        
        configuration.caption = caption
    
        if let captionColor = captionColor {
            configuration.captionColor = captionColor.toRGB()
        }
        
        if let captionBgColor = captionBgColor {
            configuration.captionBgColor = captionBgColor.toRGB()
        }
        
        configuration.content = info
        
        return configuration
    }
}

struct ResponseUrgentNotices: BaseResponse {
    typealias R = ResponseUrgentNotices
    
    var success: Bool
    var message: String?
    var data: [UrgentNoticesDataModel]?
}
