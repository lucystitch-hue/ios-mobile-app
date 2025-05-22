//
//  ClubIMTNetCooperationVC.swift
//  IMT-iOS
//
//  Created by dev on 05/04/2023.
//

import UIKit

class ClubIMTNetCooperationVC: BaseViewController  {
    
    @IBOutlet weak var tfSubscriberNumber: UITextField!
    @IBOutlet weak var tfClbCooperation: UITextField!
    @IBOutlet weak var lbSubNumber: IMTLabel!
    @IBOutlet weak var lbClbCooperation: IMTLabel!
    @IBOutlet weak var lbWarning: IMTLabel!
    
    var viewModel: ClubIMTNetCooperationViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setGradientBackground()
        clearLabelWarningAndTextField()
        super.viewWillAppear(animated)
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionRegister(_ sender: Any) {

        let subscriber = tfSubscriberNumber.text ?? ""
        let clb = tfClbCooperation.text ?? ""
       
        viewModel.validate(subscriberValue: subscriber , clbValue: clb)
    }

}

extension ClubIMTNetCooperationVC {
    private func setupUI() {
        setGradientBackground()
        configTextField()
        setupNavigation()
        clearLabelWarningAndTextField()
        configLabel()
    }
        
    private func setupData() {
        viewModel = ClubIMTNetCooperationViewModel()

        viewModel.onValidate.bind { [weak self] validate in
            if(self?.viewModel.isValidating == true) {
                if(validate != ClubIMTNetCooperationValidate.none) {
                    self?.lbWarning.text =  validate?.rawValue
                } else {
                    // present View
                    self?.lbWarning.text =  validate?.rawValue
                }
            }
        }
    }
    
    private func configTextField() {
        configTextField(tfSubscriberNumber)
        configTextField(tfClbCooperation)
    }
    
    private func configLabel() {
        lbSubNumber.attributedText = viewModel.coloredAttributedString(withText: .myPersonal.placeholderIPatIdRegister, coloredText: .myPersonal.lbColorSub)
    }
    
    private func configTextField(_ textField: UITextField) {
        textField.borderStyle = .none
        textField.delegate = self
        if textField.tag == 0 {
            textField.keyboardType = .numberPad
        }
    }
    
    private func clearLabelWarningAndTextField() {
        lbWarning.text = ""
        tfSubscriberNumber.text  =  ""
        tfClbCooperation.text = ""
    }
}

extension ClubIMTNetCooperationVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.clubCooperation
    }
}

extension ClubIMTNetCooperationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.allowInput(textField, range: range, string: string)
    }
    
}
