//
//  CollectionViewExtension.swift
//  IMT-iOS
//
//  Created by dev on 08/03/2023.
//

import Foundation
import UIKit

extension UICollectionView {
    func register(identifer: String) {
        let nibCell = UINib(nibName: identifer, bundle: nil)
        self.register(nibCell, forCellWithReuseIdentifier: identifer)
    }
}
