//
//  ChangeTheOnlineVotingInformationVC.swift
//  IMT-iOS
//
//  Created by dev on 28/03/2023.
//

import UIKit

class VotingOnlineVC: BaseViewController {

    @IBOutlet weak var tfIPatId: UITextField!
    @IBOutlet weak var tfIPatPass: UITextField!
    @IBOutlet weak var tfIPatPar: UITextField!
    @IBOutlet weak var lbWarning: IMTLabel!
    @IBOutlet weak var lbButton: IMTLabel!
    @IBOutlet weak var btnDelete: IMTBorderButton!
    @IBOutlet weak var viewNumberEtc: UIView!
    
    public var onSuccess: JVoid?
    
    private var viewModel: VotingOnlineViewModelProtocol!
    private var original: Bool!
    private var inputScreen: VotingOnlineFromScreen!
    private var editScreen: Bool = false
    
    ///Type: Define the kind of ipat to genrate fit data
    ///Original: Support to navigate to fit screen when complete or back
    ///IsEdit: It helps define elements in the user interface. Such as placeholder,...
    init(type: VotingOnlineType, original: Bool = false, isEdit editScreen: Bool = true, inputScreen: VotingOnlineFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        self.original = original
        self.inputScreen = inputScreen
        viewModel = VotingOnlineViewModel(type: type, original: original, isEdit: editScreen, inputScreen: inputScreen)
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
        
    //MARK: Action
    @IBAction func actionRegister(_ sender: Any) {
        collapse()
        lbWarning.text = ""
        viewModel.register(self)
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        viewModel.onChangeInput(sender)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        collapse()
        lbWarning.text = ""
        Utils.showProgress(false)
        
        Utils.mainAsyncAfter { [weak self] in
            self?.viewModel.delete(self)
        }
    }
    
    @IBAction func actionNumberEtc(_ sender: Any) {
        self.transitionFromSafari(TransactionLink.subscriberNumberEtc.rawValue)
    }
    
    override func gotoBack() {
        viewModel.back(self)
    }
}

//MARK: Private
extension VotingOnlineVC {
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
            self?.btnDelete.isHidden = result!
            self?.viewNumberEtc.isHidden = !result!
            self?.editScreen = !result!
        }
        tfIPatId.text = viewModel.form.iPatId
        tfIPatPar.text = viewModel.form.iPatPars
        tfIPatPass.text = viewModel.form.iPatPass
    }
    
    private func configTextField() {
        configTextField(tfIPatId)
        configTextField(tfIPatPass)
        configTextField(tfIPatPar)
    }
    
    private func setUpPlaceholder() {
        tfIPatId.IMTPlaceholder(viewModel.getPlaceholderIPatId())
        tfIPatPar.IMTPlaceholder(viewModel.getPlaceholderIPatPars())
        tfIPatPass.IMTPlaceholder(viewModel.getPlaceholderIPatPass())
    }
    
    private func setUpTitleButton() {
        lbButton.text = viewModel.getTitleButton()
    }
    
    private func configTextField(_ textField: UITextField) {
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.delegate = self
    }
    
    private func clearData() {
        lbWarning.text = ""
        tfIPatId.text  =  ""
        tfIPatPass.text = ""
        tfIPatPar.text = ""
    }
    
}

extension VotingOnlineVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return viewModel.getTitle()
    }
    
    func navigationBar() -> Bool {
        return true
    }
}

extension VotingOnlineVC: UITextFieldDelegate {
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

