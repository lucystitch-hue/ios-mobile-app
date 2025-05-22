//
//  EnterChangeEmailVC.swift
//  IMT-iOS
//
//  Created by dev on 28/05/2023.
//

import UIKit

class EnterChangeEmailVC: BaseViewController {
    @IBOutlet weak var tfPassword: IMTTextField!
    @IBOutlet weak var btnConfirm: IMTRequiredButton!
    @IBOutlet weak var lbEmail: UILabel!
    
    private var viewModel: EnterChangeEmailViewModelProtocol!
    private var inputScreen: EnterChangeEmailFromScreen!
    public var onGotoMailChange: (([String: Any?]) -> Void)?
    
    init(email: String? = nil, inputScreen: EnterChangeEmailFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        self.inputScreen = inputScreen
        viewModel = EnterChangeEmailViewModel(email: email)
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
        self.dismiss(animated: true)
    }
    
    @IBAction func actionSend(_ sender: Any) {
        collapse()
        viewModel.gotoRegisterAndVerfiCode(self)
    }
}

extension EnterChangeEmailVC {
    private func setupUI(){
        setupNavigation()
        configTextField()
        setUpEmail()
    }
    
    private func setupData() {
        
        viewModel.form.onFilled = { [weak self] filled in
            self?.btnConfirm.filled = filled
        }
        
        viewModel.checkLoginSuccessfully = { [weak self] bundle in
            guard let bundle = bundle else { return }
            self?.onGotoMailChange?(bundle)
        }
    }
    
    private func configTextField() {
        self.tfPassword.delegate = self
    }
    
    private func setUpEmail() {
        self.lbEmail.text = viewModel.getEmail()
    }
    
}

extension EnterChangeEmailVC: IMTNavigationController {
    
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.changeEmail
    }
    
    func navigationBar() -> Bool {
        return !inputScreen.useNavigation()
    }
}

extension EnterChangeEmailVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.allowInput(textField, range: range, string: string)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        return viewModel.allowInputBegin(textField)
    }
}
