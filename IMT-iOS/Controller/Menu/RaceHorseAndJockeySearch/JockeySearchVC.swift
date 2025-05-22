//
//  JockeySearchVC.swift
//  IMT-iOS
//
//  Created on 19/03/2024.
//
    

import UIKit

class JockeySearchVC: BaseViewController {
    
    @IBOutlet private weak var collectWidget: CollectWidget!
    @IBOutlet private weak var cstCollectWidget: NSLayoutConstraint!
    
    var viewModel: JockeySearchViewModel!
    var onGotoResultSearch: ((Abbreviations) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configCollectWidget()
        bind()
    }
    
    private func bind() {
        
    }
    
    private func configCollectWidget() {
        collectWidget.delegate = self
        collectWidget.setup()
    }

}

extension JockeySearchVC: CollectWidgetDelegate {
    func kindOfCollectWidget(_ widget: CollectWidget) -> CollectWidgetStyle {
        return .abbreviations()
    }
    
    func collectWidget(_ widget: CollectWidget, heightChange: Float) {
        cstCollectWidget.constant = CGFloat(heightChange)
    }
    
    func collectWidget(_ widget: CollectWidget, didSelectAt index: Int) {
        let abb = Abbreviations.allCases[index]
        onGotoResultSearch?(abb)
    }
    
    func collectWidget(_ widget: CollectWidget, disableWidgetAt index: Int) -> Bool {
        return false
    }
}

extension JockeySearchVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.jockeySearch
    }
    
    func navigationBar() -> Bool {
        return true
    }
}
