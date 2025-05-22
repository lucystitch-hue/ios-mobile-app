//
//  LoginVC.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import UIKit


class LoginVC: BaseDataController<LoginViewModel> {
    @IBOutlet weak var imvLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupUI() {
        setGradientBackground()
        configLogo()
    }
    
    override func setupData() {
        viewModel = LoginViewModel(controller: self);
    }
    
    //MARK: Action
    @IBAction func actLoginVC(_ sender: Any) {
        self.viewModel.gotoLoginAccount(self)
    }
    
    @IBAction func actRegisterVC(_ sender: Any) {
        self.viewModel.gotoResgiterAccount(self)
    }
    
}

//MARK: Private
extension LoginVC {
    private func configLogo() {
        self.imvLogo.heightConstraint?.constant = self.imvLogo.heightConstraint?.constant.autoScale() ?? 0
    }
}
