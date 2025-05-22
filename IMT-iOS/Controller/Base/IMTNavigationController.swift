//
//  IMTNavigationController.swift
//  IMT-iOS
//
//  Created by dev on 15/03/2023.
//

import Foundation
import UIKit

protocol IMTNavigationController {
    func getController() -> BaseViewController
    func getTitleNavigation() -> String
    func navigationBar() -> Bool
    func setupNavigation()
    func useLogoApp() -> Bool
    func hideButtonBack() -> Bool
    func getTitleSubNavigation() -> String
}

extension IMTNavigationController {
    
    func setupNavigation() {
        let controller = self.getController()
        controller.navigationController?.navigationBar.isHidden = true
        
        let vHeader = getHeader(controller)
        controller.view.addSubview(vHeader)
        configHeaderConstraint(vHeader, controller: controller)
    }
    
    func useLogoApp() -> Bool {
        return false
    }
    
    func hideButtonBack() -> Bool {
        return false
    }
    
    func navigationBar() -> Bool {
        return false
    }
    
    func getTitleSubNavigation() -> String {
        return ""
    }
}

//MARK: Private
extension IMTNavigationController {
    private func getHeader(_ controller: BaseViewController) -> UIView {
        let isHeaderBar = navigationBar()
        
        if(isHeaderBar) {
            return getHeaderBar(controller)
        } else {
            return getHeaderDefault(controller)
        }
    }
    
    private func getHeaderDefault(_ controller: BaseViewController) -> IMTHeaderView {
        let vHeader = IMTHeaderView()
        vHeader.backgroundColor = .red
        vHeader.title = self.getTitleNavigation()
        vHeader.theme = .main
        vHeader.hiddenBack = hideButtonBack()
        vHeader.hiddenLogo = !useLogoApp()
        
        vHeader.onBack = {
            controller.gotoBack()
        }
        
        return vHeader
    }
    
    private func getHeaderBar(_ controller: BaseViewController) -> IMTHeaderBar {
        let vHeader = IMTHeaderBar()
        vHeader.title = self.getTitleNavigation()
        vHeader.titleSub = self.getTitleSubNavigation()
        
        return vHeader
    }
    
    private func configHeaderConstraint(_ headerView: UIView, controller: BaseViewController) {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        guard let parentView = controller.view else { return }
        
        let isHeaderBar = navigationBar()

        var hHeader = 48.0
        if (!self.getTitleSubNavigation().isEmpty) {
            hHeader = 100.0
        }
        var heightContent = hHeader //Caculate from class IMTTabVC
        
        if(!isHeaderBar) {
            heightContent = 63.0 //Caculate from class IMTTabVC
            let topSafeArea = Constants.topPadding
            hHeader = topSafeArea + heightContent
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: parentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: hHeader)
        ])
        
        //Caculate top safe area
        controller.additionalSafeAreaInsets.top = heightContent
    }
    
}
