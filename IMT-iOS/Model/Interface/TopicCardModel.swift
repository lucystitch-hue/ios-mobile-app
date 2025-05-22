//
//  IBeginnerGuideSection.swift
//  IMT-iOS
//
//  Created by dev on 05/06/2023.
//

import Foundation
import UIKit

struct TopicCardModel {
    let subTitle: String?
    let subItems: [ITopicCardModel]!
}

struct ITopicCardModel {
    var label: String!
    var icon: UIImage!
    
    init(_ beginner: BeginnerGuide) {
        self.label = beginner.rawValue
        self.icon = beginner.icon()
    }
}
