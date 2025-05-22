//
//  SizeExtension.swift
//  IMT-iOS
//
//  Created by dev on 08/03/2023.
//

import Foundation

extension CGSize {
    func autoScale() -> CGSize {
        let scale = Utils.scaleDesign()
        let height = self.height * scale
        let width = self.width * scale
        
        return CGSize(width: width, height: height)
    }
}
