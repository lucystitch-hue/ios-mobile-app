//
//  HorseAndJockeyCellViewModel.swift
//  IMT-iOS
//
//  Created on 19/03/2024.
//
    

import Foundation
import UIKit

class HorseAndJockeyCellViewModel: BaseCellViewModel {
    override var nibName: String {
        return HorseAndJockeyCell.nameOfClass
    }
    
    override var cellIdentifier: String {
        return HorseAndJockeyCell.nameOfClass
    }
    
    var title: String?
    var sex: String?
    var badge: [(text: String, color: UIColor)] = []
    var selected: Bool?
    var leftPadding: Float = 0
    var maximumBadge: Int = 3
    
    override init() {
        super.init()
    }
}
