//
//  ChangePasswordVC.swift
//  IMT-iOS
//
//  Created by dev on 27/04/2023.
//

import UIKit

class ChangePasswordVC: BaseViewController {
    
    @IBOutlet weak var tfCurrentPassword: IMTTextField!
    @IBOutlet weak var tfNewPassword: IMTTextField!
    @IBOutlet weak var tfComfirNewPassword: IMTTextField!
    @IBOutlet weak var btnSend: IMTRequiredButton!
    
    public var onSuccess: JVoid?
    private var viewModel: ChangePasswordViewModelProtocol!
    private var pushScreen: ChangePasswordFromScreen!
    public var onGotoSendOtpToEmail: JVoid?
    
    init(email: String? = nil, userId:String? = nil, pushScreen:ChangePasswordFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        self.pushScreen = pushScreen
        viewModel = ChangePasswordViewModel(email: email, userId: userId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.hideToast()
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionForgotPassword(_ sender: Any) {
        onGotoSendOtpToEmail?()
    }
    
    @IBAction func actionSend(_ sender: Any) {
        viewModel.changePassword(self)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.onChangeValue(sender)
    }
    
}

extension ChangePasswordVC {
    private func setupUI(){
        setupNavigation()
        configTextField()
    }
    
    private func setupData() {
        viewModel.onChagePasswordSuccessful = { [weak self] value in
            if(value == true) {
                self?.onSuccess?()
            }
        }
        
        viewModel.form.onFilled = { [weak self] filled in
            self?.btnSend.filled = filled
        }
    }
    
    private func configTextField() {
        self.tfNewPassword.delegate = self
        self.tfCurrentPassword.delegate = self
        self.tfComfirNewPassword.delegate = self
        
        tfCurrentPassword.isUserInteractionEnabled = false
        tfCurrentPassword.attributedText = self.configPlaceholder(withText: Utils.getUserDefault(key: .password) ?? "")
    }
}

extension ChangePasswordVC: IMTNavigationController {
    
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.changePassword
    }
    
    func navigationBar() -> Bool {
        return !pushScreen.useNavigation()
    }
}

extension ChangePasswordVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.allowInput(textField, range: range, string: string)
    }
}
