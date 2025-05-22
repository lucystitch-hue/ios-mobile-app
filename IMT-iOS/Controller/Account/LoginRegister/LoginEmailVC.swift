//
//  LoginEmailVC.swift
//  IMT-iOS
//
//  Created by dev on 21/04/2023.
//

import UIKit
import CryptoKit
import IQKeyboardManagerSwift

class LoginEmailVC: BaseViewController {
    @IBOutlet weak var tfMailAddress: IMTTextField!
    @IBOutlet weak var tfPassword: IMTTextField!
    @IBOutlet weak var stvContent: UIStackView!
    @IBOutlet weak var vImgLogo: UIView!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var vDescribe: UIView!
    @IBOutlet weak var btnLogin: IMTButton!
    @IBOutlet weak var cstHeightForgotPassword: NSLayoutConstraint!
    @IBOutlet weak var imvBiometric: UIImageView!
    @IBOutlet weak var lblBiometric: IMTLabel!
    @IBOutlet weak var vBiometric: UIView!
    @IBOutlet weak var lbVersion: IMTLabel!
    
    private var viewModel: LoginEmailViewModelProtocol!
    private var useAnimate: Bool = true
    var cstHeight: CGFloat = 0
    
    init(animate: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.useAnimate = animate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collapse()
        self.setGradientBackground()
        super.viewWillAppear(animated)
        Constants.isLoginScreen = true
        IQKeyboardManager.shared.disabledDistanceHandlingClasses = [] //tạm thời
    }
    
    override func checkVersionBecomeForeground() -> Bool {
        return true
    }
    
    override func checkVersionWhenRunApp() -> Bool {
        return false
    }
    
    override func continueWhenCancelUpgrade(_ controller: BaseViewController?) {
        viewModel.biometricAuthen(self, checkVersion: false)
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        collapse()
        viewModel.gotoForgotPassword(self)
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        if(!Utils.inprogress()) {
            collapse()
            viewModel.login()
        }
    }
    
    @IBAction func actionSignUp(_ sender: Any) {
        collapse()
        viewModel.gotoSignUp(self)
    }
    
    @IBAction func actionScanToLogin(_ sender: Any) {
        collapse()
        viewModel.scanToLogin(self, checkVersion: false)
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        viewModel.onChangeInput(sender)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.onChangeInput(sender)
    }
    
    @IBAction func actionInquiries(_ sender: Any) {
        transitionToInquiries()
    }
    
    @IBAction func actionChangeModel(_ sender: Any) {
        transitionChangeModel()
    }
}

extension LoginEmailVC {
    
    private func setupUI() {
        setGradientBackground()
        configBaseEnviroment()
        configBiometricControl()
        
        if(useAnimate) {
            self.animate()
        }
    }
    
    private func setupData() {
        viewModel = LoginEmailViewModel(controller: self )
        
        viewModel.onLoginSuccessfully.bind { [weak self] success in
            if(success == true) {
                self?.viewModel.onBiometricAuthenticationIfNeed(self)
            } else {
                guard let tfPassword = self?.tfPassword else { return }
                tfPassword.text = ""
                self?.viewModel.onChangeInput(tfPassword)
            }
        }
        
        viewModel.onReminderAccount.bind { [weak self] result in
            guard let form = result?.form else { return }
            guard let email = form.email else { return }
            guard let password = form.password else { return }
            
            self?.tfMailAddress.text = email
            self?.tfPassword.text = password
        }
        
        viewModel.onBiometricAuthen.bind { [weak self] authenInfo in
            guard let authenInfo = authenInfo else { return }
            
            if(!authenInfo.isIntital) {
                self?.vBiometric.isHidden = !authenInfo.show
            }
        }
        
        viewModel.onDidResultCheckVerion = { [weak self] state in
            self?.viewModel.showPopupUpgrade(self, state: state)
        }
        
        lbVersion.text = viewModel.getVersionApp()
    }
    
    private func animate() {
        vContent.center = CGPoint(x: stvContent.frame.size.width / 2, y: stvContent.frame.size.height / 2)
        vContent.alpha = 0
        lbVersion.alpha = 0
        
        if (stvContent.frame.size.height < 750 ){
            cstHeight = 35
        } else {
            cstHeight = 60
        }
        
        vImgLogo.center = CGPoint(x: stvContent.frame.size.width / 2, y: stvContent.frame.size.height / 2 - cstHeight)
        stvContent.addSubview(vImgLogo)
        
        vDescribe.center = CGPoint(x: stvContent.frame.size.width / 2, y: stvContent.frame.size.height / 2 + cstHeight)
        stvContent.addSubview(vDescribe)
        
        UIView.animate(withDuration: Constants.System.durationLoginAnimate, delay: 0.1, animations: { [weak self] in
            guard let vImgLogo = self?.vImgLogo,
                  let vDescribe = self?.vDescribe,
                  let stvContent = self?.stvContent else { return }
            
            vImgLogo.center = CGPoint(x: stvContent.frame.size.width / 2, y: 120)
            vDescribe.center = CGPoint(x: stvContent.frame.width/2, y: stvContent.frame.height - 90)
            
        }) { [weak self] finish in
            guard let vContent = self?.vContent else { return }
            
            self?.stvContent.addSubview(vContent)
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                self?.vContent.alpha = 1
                self?.lbVersion.alpha = 1
            }) { [weak self] finish in
                if(finish) {
                    let needCheckVersion = !UserManager.share().multipleLogin()
                    self?.viewModel.biometricAuthen(self, checkVersion: needCheckVersion)
                }
            }
        }
    }
    
    private func configBaseEnviroment() {
        let env = Utils.getEnviroment()
        
//        if(env != .develop) {
//            cstHeightForgotPassword.constant = 0
//        }
    }
    
    private func configBiometricControl() {
        let style = IMTBiometricAuthentication.getStyle()
        imvBiometric.image = style.loginImage()
        lblBiometric.text = style.loginTitle()
    }
}

