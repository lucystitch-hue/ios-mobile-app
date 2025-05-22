//
//  JockeyCellViewModel.swift
//  IMT-iOS
//
//  Created on 02/04/2024.
//
    

import Foundation
import UIKit

class JockeyCellViewModel: HorseAndJockeyCellViewModel {
    
    private(set) var jockey: OshiKishu
    
    init(jockey: OshiKishu) {
        self.jockey = jockey
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.title = jockey.jon
        if (jockey.masflg == "1") {
            self.badge.append((text: "Retired or Returned Home", color: .darkCharcoal))
        }
        self.leftPadding = 54
        self.maximumBadge = 1
    }
}
