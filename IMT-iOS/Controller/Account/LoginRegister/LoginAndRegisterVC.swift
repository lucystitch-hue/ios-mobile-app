//
//  LoginAndRegisterVC.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import UIKit

class LoginAndRegisterVC:BaseDataController<LoginAndRegisterViewModel> {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbLoginWithEmail: IMTLabel!
    @IBOutlet weak var lbLine: IMTLabel!
    @IBOutlet weak var lbYahoo: IMTLabel!
    @IBOutlet weak var lbGoogle: IMTLabel!
    @IBOutlet weak var lbFacebook: IMTLabel!
    @IBOutlet weak var lbTwiter: IMTLabel!
    @IBOutlet weak var lbApple: IMTLabel!
    
    var mode: LoginAndRegisterMode!

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    override func setupUI() {
        setGradientBackground()
        chageTitleLoginRegiter()
        configButton()
    }
    
    override func setupData() {
        viewModel = LoginAndRegisterViewModel()
        
        viewModel.onLoginSuccess = { [weak self]validate in
            if(validate == .success) {
                self?.viewModel.gotoHome(self!)
            }
        }
    }
    
    //MARK: Action
    @IBAction func actionEmail(_ sender: Any) {
        viewModel.loginWithUserName("aaa")
    }
    
    @IBAction func actionLine(_ sender: Any) {
        self.viewModel.gotoHome(self)
    }
    
    @IBAction func actionYahoo(_ sender: Any) {
        self.viewModel.gotoHome(self)
       
    }
    
    @IBAction func actionGoogle(_ sender: Any) {
        self.viewModel.gotoHome(self)
       
    }
    
    @IBAction func actionFacebook(_ sender: Any) {
        self.viewModel.gotoHome(self)
       
    }
    
    @IBAction func actionTwiter(_ sender: Any) {
        self.viewModel.gotoHome(self)
      
    }
    
    @IBAction func actionApple(_ sender: Any) {
        self.viewModel.gotoHome(self)
    
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

//MARK: Private
extension LoginAndRegisterVC {
    
    private func chageTitleLoginRegiter() {
        self.lbTitle.text = mode.title()
        lbLoginWithEmail.text = mode.titleLoginWithMail()
    }
    
    private func configButton() {
        //TODO: Title
        configTitleButton()
    }
    
    private func configTitleButton() {
        switch mode {
        case .register:
            lbLine.text =  .registerScreen.line
            lbYahoo.text = .registerScreen.yahoo
            lbGoogle.text =  .registerScreen.google
            lbFacebook.text = .registerScreen.facebook
            lbTwiter.text = .registerScreen.twitter
            lbApple.text = .registerScreen.apple
            break
        case .login:
            lbLine.text =  .loginScreen.line
            lbYahoo.text = .loginScreen.yahoo
            lbGoogle.text = .loginScreen.google
            lbFacebook.text = .loginScreen.facebook
            lbTwiter.text = .loginScreen.twitter
            lbApple.text = .loginScreen.apple
            break
        default:
            break
        }
    }
}
