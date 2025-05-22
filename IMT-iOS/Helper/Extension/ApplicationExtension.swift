//
//  ApplicationExtension.swift
//  IMT-iOS
//
//  Created on 28/03/2024.
//
    

import Foundation
import UIKit

extension UIApplication {
    func canOpen(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else { return false }
        return UIApplication.shared.canOpen(url)
    }
}
