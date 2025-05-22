//
//  ConfirmOTPVC.swift
//  IMT-iOS
//
//  Created by dev on 28/05/2023.
//

import UIKit

class ConfirmOTPVC: BaseViewController {
    
    @IBOutlet weak var lbDescribe: IMTLabel!
    @IBOutlet weak var lbGuide: IMTLabel!
    @IBOutlet weak var tfCode: IMTTextField!
    @IBOutlet weak var btnConfirm: IMTButton!
    @IBOutlet weak var lbSend: IMTLabel!
    @IBOutlet weak var lbEmail: IMTLabel!
    
    private var style: ConfirmOTPStyle!
    private var viewModel: ConfirmOTPViewModelProtocol!
    private var inputScreen: ConfirmOTPFromScreen!
    public var onSuccess: JVoid?
    public var onGotoResetPassword: (([String: Any?]) -> Void)?
    
    init(style: ConfirmOTPStyle!, bundle: [ConfirmOTPBundleKey: Any]? = nil, inputScreen: ConfirmOTPFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        
        self.style = style
        self.inputScreen = inputScreen
        viewModel = ConfirmOTPViewModel(style: style, bundle: bundle, inputScreen: inputScreen)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.hideToast()
        super.viewWillAppear(animated)
        configTextLabel()
        self.view.hideToast()
    }
    
    override func gotoBack() {
        collapse()
        viewModel.back(self)
    }
    
    @IBAction func actionSend(_ sender: Any) {
        collapse()
        viewModel.send(self)
    }
    
    @IBAction func actionResend(_ sender: Any) {
        collapse()
        viewModel.resend(self)
    }
    
    @IBAction func textFieldDidChange(_ sender: Any) {
        guard let textField = sender as? UITextField else { return }
        viewModel.onChangeInput(textField)
    }
    
    @IBAction func actionInquiries(_ sender: Any) {
        transitionToInquiries()
    }
    
}

extension ConfirmOTPVC {
    
    private func setupUI() {
        setupNavigation()
        configTextLabel()
        configTextField()
    }
    
    private func setupData() {
        
        viewModel.onVerfiySuccessful = { [weak self] bundle in
            self?.viewModel.gotoScreen(self, bundle: bundle)
        }
        
        viewModel.onChangEmailSuccessfully = { [weak self] in
            self?.viewModel.gotoMenu(self)
        }
        
        viewModel.onSendSuccessfully = { [weak self] in
            self?.lbSend.isHidden = false
        }
        
        viewModel.shouldHideLbSend.bind { [weak self] shouldHide in
            guard let self, let shouldHide else { return }
            self.lbSend.isHidden = shouldHide
        }
        
        viewModel.onEmail.bind { [weak self] result in
            self?.lbEmail.text = result
        }
    }
    
    private func configTextLabel() {
        if (style == .resetPassword || style == .updateUserInfo) {
            self.btnConfirm.titleLabel?.text = style.button()
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = .center
        lbDescribe.attributedText = NSAttributedString(string: .loginScreen .sentVerfiCode, attributes: [.paragraphStyle: paragraphStyle])
        lbGuide.attributedText = self.configAttribute(text:.loginScreen .titleGuide , alignmentText: "left")
    }
    
    private func configTextField() {
        self.tfCode.delegate = self
    }
}

extension ConfirmOTPVC : IMTNavigationController {
    
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return style.title()
    }
    
    func navigationBar() -> Bool {
        return !inputScreen.useNavigation()
    }
}

extension ConfirmOTPVC: UITextFieldDelegate {
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
