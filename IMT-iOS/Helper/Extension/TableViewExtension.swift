//
//  TableViewExtension.swift
//  IMT-iOS
//
//  Created by dev on 08/03/2023.
//

import Foundation
import UIKit

extension UITableView {
    func register(identifier: String) {
        let nibCell = UINib(nibName: identifier, bundle: nil)
        self.register(nibCell, forCellReuseIdentifier: identifier)
    }
}
