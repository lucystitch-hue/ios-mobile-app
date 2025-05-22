//
//  LoginViewModel.swift
//  IMT-iOS
//
//  Created by dev on 07/03/2023.
//

import UIKit

class LoginViewModel: BaseViewModel {
    
    init(controller: LoginVC) {
        super.init()
        gotoTerm(controller)
    }
    
    func gotoLoginAccount(_ controller: LoginVC?) {
        guard let controller = controller else { return }
        let vc = LoginAndRegisterVC()
        vc.mode = .login
        controller.presentOverFullScreen(vc)
    }
    
    func gotoResgiterAccount(_ controller: LoginVC?) {
        guard let controller = controller else { return }
        let vc = LoginAndRegisterVC()
        vc.mode = .register
        controller.presentOverFullScreen(vc)
    }
    
    func gotoTerm(_ controller: LoginVC) {
        let isShow = checkShowTerm()
        
        if(isShow) {
            let vc = PopupTermVC()
            controller.presentOverFullScreen(vc, animate: false)
        }
    }
}

//MARK: Private
extension LoginViewModel {
    private func checkShowTerm() -> Bool {
        return true
    }
}
