//
//  TabExtension.swift
//  IMT-iOS
//
//  Created by dev on 26/05/2023.
//

import Foundation
import UIKit

extension UITabBar {
    
    func showBadge(at index: Int,
                   value: String? = nil,
                   configuration: TabBarBadgeConfiguration = TabBarBadgeConfiguration()) {
        let existingBadge = subviews.first { ($0 as? TabBarBadge)?.hasIdentifier(for: index) == true }
        existingBadge?.removeFromSuperview()
        
        guard let tabBarItems = items else { return }
        
        let itemPosition = CGFloat(index + 1)
        let itemWidth = frame.width / CGFloat(tabBarItems.count)
        let itemHeight = frame.height
        let tabBarButton = getTabBarButton()
        let hTabBarButton = tabBarButton?.frame.size.height ?? itemHeight
        
        let badge = TabBarBadge(for: index)
        badge.frame.size = configuration.size
        badge.center = CGPoint(x: (itemWidth * itemPosition) - (0.5 * itemWidth) + configuration.centerOffset.x,
                               y: (0.5 * hTabBarButton) + configuration.centerOffset.y)
        badge.layer.cornerRadius = 0.5 * configuration.size.height
        badge.clipsToBounds = true
        badge.textAlignment = .center
        badge.backgroundColor = configuration.backgroundColor
        badge.font = configuration.font
        badge.textColor = configuration.textColor
        badge.text = value
        
        addSubview(badge)
    }
    
    func hideBadge(at index: Int) {
        let existingBadge = subviews.first { ($0 as? TabBarBadge)?.hasIdentifier(for: index) == true }
        existingBadge?.removeFromSuperview()
    }
        
        private func getTabBarButton() -> UIView?  {
            for subview in subviews {
                if let cls = NSClassFromString("UITabBarButton") , subview.isKind(of: cls){
                    return subview
                }
            }
            return nil
        }
}

class TabBarBadge: UILabel {
    var identifier: String = String(describing: TabBarBadge.self)
    
    private func identifier(for index: Int) -> String {
        return "\(String(describing: TabBarBadge.self))-\(index)"
    }
    
    convenience init(for index: Int) {
        self.init()
        identifier = identifier(for: index)
    }
    
    func hasIdentifier(for index: Int) -> Bool {
        let has = identifier == identifier(for: index)
        return has
    }
}

class TabBarBadgeConfiguration {
    var backgroundColor: UIColor = .red
    var centerOffset: CGPoint = .init(x: 12, y: -14)
    var size: CGSize = .init(width: 12, height: 12)
    var textColor: UIColor = .white
    var font: UIFont! = .systemFont(ofSize: 11) {
        didSet { font = font ?? .systemFont(ofSize: 11) }
    }
    
    static func construct(_ block: (TabBarBadgeConfiguration) -> Void) -> TabBarBadgeConfiguration {
        let new = TabBarBadgeConfiguration()
        block(new)
        return new
    }
}
