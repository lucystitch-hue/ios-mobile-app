//
//  ScrollViewExtension.swift
//  IMT-iOS
//
//  Created on 19/04/2024.
//
    

import Foundation
import UIKit

extension UIScrollView {
    
    @objc func stopScroll(_ notification: Notification) {
        guard let enable = notification.object as? Bool else { return }
        isUserInteractionEnabled = enable
        panGestureRecognizer.isEnabled = enable
        pinchGestureRecognizer?.isEnabled = enable
    }
    
    open override func didMoveToWindow() {
        super.didMoveToWindow()
        // Called when the view has been added or removed from a window
        if window != nil {
            Utils.onObserver(self, selector: #selector(stopScroll), name: .killScroll)
        } else {
            Utils.removeObserver(self, name: .killScroll)
        }
    }
    
    open override func removeFromSuperview() {
        // Perform cleanup tasks here
        // Remove any observers, release resources, etc.
        
        super.removeFromSuperview()
        Utils.removeObserver(self, name: .killScroll)
    }
}
