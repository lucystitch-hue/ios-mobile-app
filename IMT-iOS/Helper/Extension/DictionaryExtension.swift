//
//  DictionaryExtension.swift
//  IMT-iOS
//
//  Created by dev on 19/06/2023.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key: Key, value: Value) {
        return self[index(startIndex, offsetBy: i)]
    }
}
