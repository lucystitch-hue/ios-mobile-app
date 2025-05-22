//
//  DispatchGroupExtension.swift
//  IMT-iOS DEV
//
//  Created by dev on 26/07/2023.
//

import Foundation

extension DispatchGroup {
    public func leaveOptional() {
        let count = self.debugDescription.components(separatedBy: ",").filter({$0.contains("count")}).first?.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap{Int($0)}.first
        if(count != 0) {
            self.leave()
        }
    }
}
