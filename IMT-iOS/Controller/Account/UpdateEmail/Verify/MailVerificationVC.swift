//
//  MailVerificationVC.swift
//  IMT-iOS
//
//  Created by dev on 02/06/2023.
//

import UIKit

class MailVerificationVC: BaseViewController {
    
    @IBOutlet weak var lbTitle: IMTLabel!
    @IBOutlet weak var lbDescribe: IMTLabel!
    @IBOutlet weak var tfInput: IMTTextField!
    @IBOutlet weak var btnSend: IMTButton!
    @IBOutlet weak var vBtnReturn: IMTView!
    @IBOutlet weak var vTextField: IMTInnerShadowView!
    @IBOutlet weak var lbEmail: IMTLabel!
    @IBOutlet weak var vBackgroundLink: IMTView!
    
    private var viewModel: MailVerificationViewModelProtocol!
    private var style: MailVerificationStyle!
    private var inputScreen: EnterChangeEmailFromScreen!
    public var onGotoConfirmOtp: (([ConfirmOTPBundleKey: Any]?, _ style: ConfirmOTPStyle?) -> Void)?
    public var onResultUpdateEmail: (([ResultChangeEmailBundleKey: Any?]) -> Void)?
    public var onBack: JVoid?
    
    init(style: MailVerificationStyle,
         oldEmail email: String? = nil,
         password: String? = nil,
         inputScreen: EnterChangeEmailFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
        self.inputScreen = inputScreen
        viewModel = MailVerificationViewModel(style: style, oldEmail: email, password: password)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func gotoBack() {
        collapse()
        viewModel.back(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func checkVersionBecomeForeground() -> Bool {
        return true
    }
    
    @IBAction func actionSend(_ sender: Any) {
        collapse()
        viewModel.send(self)
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        viewModel.onChangeInput(sender)
    }
    
    @IBAction func actionReturn(_ sender: Any) {
        onBack?()
    }
    
    @IBAction func actionInquiries(_ sender: Any) {
        transitionToInquiries()
    }
}

extension MailVerificationVC {
    
    private func setupUI() {
        setupNavigation()
        configTextLabel()
        configTextField()
    }
    
    private func setupData() {
        viewModel.onVerifySuccessful = { [weak self] bundle in
            self?.viewModel.gotoConfirmCode(self, bundle: bundle)
        }
        
        viewModel.onUpdateEmail = { [weak self] result in
            self?.onResultUpdateEmail?(result)
        }
        
        viewModel.onDidResultCheckVerion = { [weak self] state in
            self?.viewModel.showPopupUpgrade(self, state: state)
        }
    }
    
    private func configTextField() {
        tfInput.delegate = self
    }
    
    private func configTextLabel() {
        lbTitle.text = style.title()
        if (style == .changeEmail) {
            lbTitle.isHidden = true
            lbDescribe.attributedText =  self.configAttribute(text: style.describe(), alignmentText: "left", lineSpacing:10)
            vBtnReturn.isHidden = true
            vBackgroundLink.isHidden = true
        } else if (style == .signup) {
            lbDescribe.attributedText =  self.configAttribute(text: style.describe(), alignmentText: "left", lineSpacing: 10)
            vBtnReturn.isHidden = true
        } else if ( style == .sendCodeChangePassword || style == .sendCodeForgotPassword ) {
            lbDescribe.attributedText =  self.configAttribute(text: style.describe(), alignmentText: "left", lineSpacing: 10)
            lbEmail.isHidden = true
            vTextField.isHidden = true
            vBackgroundLink.isHidden = true
        }
    }
}

extension MailVerificationVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return style.titleScreen()
    }
    
    func navigationBar() -> Bool {
        return !inputScreen.useNavigation()
    }
}

extension MailVerificationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.allowInput(textField, range: range, string: string)
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        if #available(iOS 17.0, *) {
            builder.remove(menu: .autoFill)
        }
        super.buildMenu(with: builder)
    }
}
