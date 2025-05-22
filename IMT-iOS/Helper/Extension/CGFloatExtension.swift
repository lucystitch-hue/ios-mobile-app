//
//  CGFloatExtension.swift
//  IMT-iOS
//
//  Created by dev on 11/03/2023.
//

import Foundation

extension CGFloat {
    func autoScale() -> CGFloat {
        return Utils.scaleWithHeight(self)
    }
}
