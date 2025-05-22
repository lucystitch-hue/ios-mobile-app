//
//  UIScreenExtension.swift
//  IMT-iOS
//
//  Created on 07/03/2024.
//
    

import Foundation
import UIKit

extension UIScreen {
    static var isZoomed: Bool {
        return UIScreen.main.scale < UIScreen.main.nativeScale
    }
}
