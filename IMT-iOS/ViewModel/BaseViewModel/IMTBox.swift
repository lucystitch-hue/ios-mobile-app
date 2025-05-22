//
//  IMTBox.swift
//  IMT-iOS
//
//  Created on 20/03/2024.
//
    

class IMTBox<T> {
    typealias Listener = (T) -> Void
    var listeners = [(Listener, String?)]()

    var value: T {
        didSet {
            listeners.forEach( { $0.0(value) } )
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ object: AnyObject, performInitialUpdate: Bool = true, clearPreviousBinds: Bool = true, listener: @escaping Listener) {
        if clearPreviousBinds {
            listeners = [(listener, hashString(frombject: object))]
        } else {
            if listeners.first(where: { $0.1 == hashString(frombject: object)}) == nil {
                listeners.append((listener, hashString(frombject: object)))
            }
        }
        if performInitialUpdate {
            listener(value)
        }
    }
    
    func unbind(_ object: AnyObject) {
        let hash = hashString(frombject: object)
        var indexesToRemove = [Int]()
        for (index, element) in listeners.enumerated() {
            if element.1 == hash {
                indexesToRemove.append(index)
            }
        }
        indexesToRemove.forEach { (index) in
            listeners.remove(at: index)
        }
    }
    
    func unbindAll() {
        listeners.removeAll()
    }
    
    private func hashString(frombject: AnyObject) -> String {
        return String(UInt(bitPattern: ObjectIdentifier(frombject)))
    }
}
