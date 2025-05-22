
//
//  ConfirmForgotPasswordInformationVC.swift
//  IMT-iOS
//
//  Created by dev on 28/05/2023.
//

import UIKit

class ConfirmForgotPasswordInformationVC: BaseViewController {
    
    @IBOutlet weak var lbYear: IMTLabel!
    @IBOutlet weak var lbMonth: IMTLabel!
    @IBOutlet weak var lbDay: IMTLabel!
    @IBOutlet weak var tfEmail: IMTTextField!
    @IBOutlet weak var btnComfirm: IMTRequiredButton!
    
    private let ddYear = DropDown()
    private let ddMonth = DropDown()
    private let ddDay = DropDown()
    
    private var viewModel: ConfirmForgotPasswordInformationViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        viewModel.sendOtpForgotPassword(self)
    }
    
    //MARK: Action
    @IBAction func actionDropdownYear(_ sender:UIButton) {
        ddYear.tag = 0
        actionDropdown(ddYear, label: lbYear, sender: sender) { [weak self] index in
            self?.viewModel.indexYear = index
        }
    }
    
    @IBAction func actionDropdownMonth(_ sender: UIButton) {
        ddMonth.tag = 1
        actionDropdown(ddMonth, label: lbMonth, sender: sender) { [weak self] index in
            self?.viewModel.indexMonth = index
        }
    }
    
    @IBAction func actionDropdownOfDay(_ sender: UIButton) {
        ddDay.tag = 2
        actionDropdown(ddDay, label: lbDay, sender: sender) { [weak self] index in
            self?.viewModel.indexDay = index
        }
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.onChangeInput(sender)
    }
    
    
    @IBAction func actionInquiries(_ sender: Any) {
        transitionToInquiries()
    }
}

extension ConfirmForgotPasswordInformationVC {
    private func setupUI(){
        setupNavigation()
        setupTextField()
    }
    
    private func setupData() {
        viewModel = ConfirmForgotPasswordInformationViewModel()
        
        viewModel.years.bind { [weak self] results in
            guard let years: [String] = results?.map({ return $0.title }) else { return }
            self?.ddYear.dataSource = years
        }
        
        viewModel.months.bind { [weak self] results in
            guard let months: [String] = results?.map({ return $0.title }) else { return }
            self?.ddMonth.dataSource = months
        }
        
        viewModel.days.bind { [weak self] results in
            guard let days: [String] = results?.map({ return $0.title }) else { return }
            self?.ddDay.dataSource = days
        }
        
        viewModel.onChangeDay = { [weak self] (value, index) in
            self?.lbDay.text = value
        }
        
        viewModel.form.onFilled = { [weak self] filled in
            self?.btnComfirm.filled = filled
        }
        
        viewModel.onForgotPasswordSuccessfull = { [weak self] bundle in
            self?.viewModel.gotoEnterConfirmationCode(self, bundle: bundle)
        }
        
        viewModel.showWarningLimitUpdate = { [weak self] in
            self?.showWarningLimitUpdate()
        }
    }
    
    func setupEvent() {
        onHideKeyboard()
    }
    
    private func setupTextField() {
        tfEmail.delegate = self
    }
    
    private func configDropDownYear() {
        self.ddYear.focusAt = viewModel.getIndexOfDefaultYear()
    }
    
    private func actionDropdown(_ dropDown: DropDown,
                                label: UILabel,
                                sender: UIButton,
                                blackListSelect: [Int] = [0],
                                action selectionAction: @escaping(_ index: Int) -> Void) {
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.cellNib = UINib(nibName: IMTDropDownCell.identifier, bundle: nil)
        dropDown.textColor = .clear
        dropDown.selectedTextColor = .clear
        dropDown.blackListSelected = blackListSelect
        dropDown.customCellConfiguration = {(index, string, cell) in
            guard let cell = cell as? IMTDropDownCell else { return }
            cell.lblTitle.textColor = index == 0 ? .quickSilver : .darkCharcoal
            cell.lblTitle.text = string
            cell.selectedBackgroundColor = index == 0 ? nil : dropDown.selectionBackgroundColor
            cell.lblTitle.font = .appFontW3Size(13)
        }
        
        dropDown.show()
        dropDown.selectionAction = {(index, value) in
            if(index != 0) {
                label.text = value
                label.textColor = .darkCharcoal
                selectionAction(index)
            }
            
            self.viewModel.onChoiceCombobox(dropDown, atIndex: index, value: value)
        }
        
        self.collapse()
    }
    
    @objc private func onHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(collapse))
        view.addGestureRecognizer(tap)
    }
}

extension ConfirmForgotPasswordInformationVC: IMTNavigationController {
    
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.resetPassword
    }
}

extension ConfirmForgotPasswordInformationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.allowInput(textField, range: range, string: string)
    }
}
