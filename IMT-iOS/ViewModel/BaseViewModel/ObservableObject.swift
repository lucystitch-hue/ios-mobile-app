//
//  ObservableObject.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation

final class ObservableObject<T> {
    
    private var needBinding = true;
    
    var value: T? {
        
        didSet {
            if(self.needBinding == true) {
                self.listener?(value);
            }
            self.needBinding = true;
        }
    }
    
    private var listener: ((T?) -> Void)?;
    
    init(_ value: T?) {
        self.value = value;
    }
    
    func bind(_ listener: @escaping(T?) -> Void){
        if(value != nil) {
            listener(value)
            self.listener = listener;
        }
    }
    
    func updateNoBind(_ value: T?) {
        needBinding = false;
        self.value = value;
    }
}
