//
//  PasswordResetVC.swift
//  IMT-iOS
//
//  Created by dev on 04/05/2023.
//

import UIKit

class PasswordResetVC: BaseViewController {
    
    @IBOutlet weak var tfNewPassword: IMTTextField!
    @IBOutlet weak var tfComfirmNewPassword: IMTTextField!
    @IBOutlet weak var btnReset: IMTRequiredButton!
    
    private var inputScreen: ConfirmOTPFromScreen!
    private var viewModel: PasswordResetViewModelProtocol!
    public var onSuccess: JVoid?
    
    init( bundle: [String: Any]? = nil, inputScreen: ConfirmOTPFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        self.inputScreen = inputScreen
        viewModel = PasswordResetViewModel(bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    @IBAction func actionReset(_ sender: Any) {
        collapse()
        viewModel.resetPassword(self)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.onChangeValue(sender)
    }
    
}

extension PasswordResetVC {
    
    private func setupUI() {
        setupNavigation()
        configTextField()
    }
    
    private func setupData() {
        viewModel.form.onFilled = { [weak self] filled in
            self?.btnReset.filled = filled
        }
        
        viewModel.onResetPasswordSuccessfull = { [weak self] value in
            if (value == true){
                if (self?.inputScreen == .menu) {
                    self?.onSuccess?()
                } else {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
    private func configTextField() {
        self.tfNewPassword.delegate = self
        self.tfComfirmNewPassword.delegate = self
    }
}

extension PasswordResetVC: IMTNavigationController {
    
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.reset
    }
    
    func navigationBar() -> Bool {
        return !inputScreen.useNavigation()
    }
}

extension PasswordResetVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.allowInput(textField, range: range, string: string)
    }
}
