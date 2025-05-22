//
//  UMACAVC.swift
//  IMT-iOS
//
//  Created by dev on 04/10/2023.
//

import UIKit

class UMACATicketVC: BaseViewController {
    
    @IBOutlet private weak var tfCardNumber: UITextField!
    @IBOutlet private weak var tfBirthDay: UITextField!
    @IBOutlet private weak var tfPinNumber: UITextField!
    @IBOutlet private weak var lbButton: IMTLabel!
    @IBOutlet private weak var btnDelete: IMTBorderButton!
    @IBOutlet private weak var lbWarning: IMTLabel!
    @IBOutlet private weak var vStackView: UIStackView!
    
    public var onSuccess: JVoid?
    
    private var viewModel: UMACAViewModelProtocol!
    
    init(original: Bool = false, isEdit editScreen: Bool = true, inputScreen: VotingOnlineFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        viewModel = UMACAViewModel(original: original, isEdit: editScreen, inputScreen: inputScreen)
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

        if(viewModel.getEdit() == false) {
            clearData()
        }
        
        super.viewWillAppear(animated)
    }

    @IBAction func actionRegister(_ sender: Any) {
        collapse()
        lbWarning.text = ""
        viewModel.register(self)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        collapse()
        lbWarning.text = ""
        Utils.showProgress(false)
        
        Utils.mainAsyncAfter {
            self.viewModel.delete(self)
        }
    }
    
    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        viewModel.onChangeInput(sender)
    }
    
    override func gotoBack() {
        viewModel.back(self)
    }
    
    @IBAction func actionForgetPolicy(_ sender: Any) {
        collapse()
        viewModel.forgetPolicy(self)
    }
}

extension UMACATicketVC {
    private func setupUI() {
        configTextField()
        clearData()
        setUpPlaceholder()
        setUpTitleButton()
        setupNavigation()
    }
    
    private func setupData() {
        viewModel.onInvalidMessage = { [weak self] message in
            self?.lbWarning.text =  message
        }
        
        viewModel.onRegisterSuccessfully = { [weak self] in
            self?.viewModel.gotoRegisterSuccess(self)
        }
        
        viewModel.onDeleteSuccessfully = { [weak self] in
            self?.viewModel.gotoResult(self)
        }
        
        viewModel.onShowButtonDelete.bind { [weak self] result in
            guard let result = result else { return }
            self?.btnDelete.isHidden = result
            self?.vStackView.isHidden = !result
        }
        tfCardNumber.text = viewModel.form.cardNumber
        tfBirthDay.text = viewModel.form.birthday
        tfPinNumber.text = viewModel.form.pinCode
    }
    
    private func configTextField() {
        configTextField(tfCardNumber)
        configTextField(tfBirthDay)
        configTextField(tfPinNumber)
    }
    
    private func configTextField(_ textField: UITextField) {
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.delegate = self
    }
    
    private func setUpPlaceholder() {
        tfCardNumber.IMTPlaceholder(viewModel.getPlaceholderCardNumber())
        tfBirthDay.IMTPlaceholder(viewModel.getPlaceholderBirthDay())
        tfPinNumber.IMTPlaceholder(viewModel.getPlaceholderPinCode())
    }
    
    private func setUpTitleButton() {
        lbButton.text = viewModel.getTitleButton()
    }
    
    private func clearData() {
        lbWarning.text = ""
        tfCardNumber.text  =  ""
        tfBirthDay.text = ""
        tfPinNumber.text = ""
    }
}

extension UMACATicketVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return viewModel.navigationTitle()
    }
    
    func navigationBar() -> Bool {
        return true
    }
}

extension UMACATicketVC: UITextFieldDelegate {
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
