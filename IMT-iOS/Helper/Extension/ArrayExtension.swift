//
//  ArrayExtension.swift
//  IMT-iOS
//
//  Created by dev on 30/10/2023.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}

extension Array {
    
    var lastIndex: Int {
        return isEmpty ? 0 : count - 1
    }
    
    mutating func safeRemoveFirst() -> Element? {
        guard !isEmpty else { return nil}
        return removeFirst()
    }
    
    func safeObjectForIndex(index: Int) -> Element? {
        if self.count > index, index >= 0 {
            return self[index]
        }
        
        return nil
    }
    
    func shuffled() -> [Element] {
        guard count > 1 else {
            return self
        }
        var list = self
        for i in 0..<(list.count - 1) {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            if i != j {
                list.swapAt(i, j)
            }
        }
        return list
    }
    
    func splitBy(subSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: subSize).map({ (startIndex) -> [Element] in
            let endIndex = (startIndex.advanced(by: subSize) > self.count) ? self.count - startIndex : subSize
            return Array(self[startIndex..<startIndex.advanced(by: endIndex)])
        })
    }
    
    func dictionary<KeyType>(key: (Element) -> KeyType) -> [KeyType: Element] {
        var result = [KeyType: Element]()
        
        for item in self {
            result[key(item)] = item
        }
        
        return result
    }
    
    func groupBy<KeyType>(key: (Element) -> KeyType) -> Dictionary<KeyType, [Element]> {
        var result: Dictionary<KeyType, [Element]> = [:]
        
        for item in self {
            let key0 = key(item)
            if var value = result[key0] {
                value.append(item)
                result[key0] = value
            } else {
                result[key0] = [item]
            }
        }
        return result
    }

    func mapIndex<T>(_ transform: (Int, Element) throws -> T) rethrows -> [T] {
        var result: [T] = [T]()
        
        for (index, item) in self.enumerated() {
            guard let transformObj = try? transform(index, item) else { continue }
            result.append(transformObj)
        }
        
        return result
    }
}

extension Array where Element: Equatable {
    
    func next(item: Element, infiniteLoop: Bool) -> Element? {
        if let index = self.firstIndex(of: item), index + 1 <= self.count {
            if infiniteLoop {
                return index + 1 == self.count ? self[0] : self[index + 1]
            } else {
                return index + 1 == self.count ? nil : self[index + 1]
            }
        }
        
        return nil
    }
    
    func previous(item: Element, infiniteLoop: Bool) -> Element? {
        if let index = self.firstIndex(of: item), index >= 0 {
            if infiniteLoop {
                return index == 0 ? self.last : self[index - 1]
            } else {
                return index == 0 ? nil : self[index - 1]
            }
        }
        
        return nil
    }
    
    func subtracting(_ array: Array<Element>) -> Array<Element> {
        self.filter { !array.contains($0) }
    }
    
    mutating func removeObject(_ object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
    
    mutating func concatenateRemovingNotPresentItems(_ newItems: [Element]) {
        var itemsCopy = self
        var newItemsCopy = newItems
        for item in self {
            if let index = newItemsCopy.firstIndex(of: item) {
                newItemsCopy.remove(at: index)
            } else {
                itemsCopy.removeObject(item)
            }
        }
        itemsCopy.append(contentsOf: newItemsCopy)
        self = itemsCopy
    }
    
    mutating func removeDuplicates() {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        self = result
    }
}

extension Array where Element: Comparable {
    func equal(to array: [Element], ignoreOrder: Bool = false) -> Bool {
        return self.count == array.count && ignoreOrder ? self.sorted() == array.sorted() : self == array
    }
}
