//
//  MenuRegisterInforVC.swift
//  IMT-iOS
//
//  Created by dev on 14/03/2023.
//

import UIKit
class UpdatePersonalInfoVC: BaseViewController {
    
    @IBOutlet weak var tfPassword: IMTTextField!
    @IBOutlet weak var tfConfirmPassword: IMTTextField!
    @IBOutlet weak var tfPostcode: IMTTextField!
    @IBOutlet weak var lbEmail: IMTLabel!
    
    @IBOutlet weak var lbStep: UILabel!
    @IBOutlet weak var lbYear: IMTLabel!
    @IBOutlet weak var lbMonth: IMTLabel!
    @IBOutlet weak var lbDay: IMTLabel!
    @IBOutlet weak var lbGender: IMTLabel!
    @IBOutlet weak var lbProfession: IMTLabel!
    @IBOutlet weak var lbHorseRacingYear: IMTLabel!
    
    @IBOutlet weak var lbLabelPostCode: IMTLabel!
    @IBOutlet weak var lbLabelBirthday: IMTLabel!
    @IBOutlet weak var lbLabelGender: IMTLabel!
    @IBOutlet weak var lbLabelJob: IMTLabel!
    @IBOutlet weak var lbLabelHorseRacingYear: IMTLabel!
    @IBOutlet weak var lbLabelPassword: IMTLabel!
    @IBOutlet weak var lbLabelConfirmPassword: IMTLabel!
    
    @IBOutlet weak var vGroupMail: UIStackView!
    @IBOutlet weak var vGroupPassword: UIStackView!
    @IBOutlet weak var vGroupConfirmPassword: UIStackView!
    @IBOutlet weak var vGroupLink: UIStackView!
    
    @IBOutlet weak var btnConfirmRegister: IMTRequiredButton!
    @IBOutlet weak var btnConfirmUpdate: IMTRequiredButton!
    
    private let ddYear = DropDown()
    private let ddMonth = DropDown()
    private let ddDay = DropDown()
    private let ddGender = DropDown()
    private let ddProfession = DropDown()
    private let ddHorseRacingYear = DropDown()
    
    private var viewModel: UpdatePersonInfoViewModelProtocol!
    private var style: ConfirmUpdateUserStyle!
    private var inputScreen: UpdatePersonalFromScreen!
    private var cacheTag: Int?
    
    public var onDismiss: JVoid?
    
    //Constructor
    init(bundle: [String: Any], style: ConfirmUpdateUserStyle = .new, inputScreen: UpdatePersonalFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        
        self.inputScreen = inputScreen
        self.style = style
        viewModel = UpdatePersonalInfoViewModel(bundle: bundle, style: style, inputScreen: inputScreen)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        configHideDropDown()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func gotoBack() {
        viewModel.back(self)
    }
    
    //MARK: Action
    @IBAction func actionDropdownYear(_ sender: UIButton) {
        ddYear.tag = 0
        actionDropdown(ddYear, label: lbYear, sender: sender, blackListSelect: []) { [weak self] index in
            self?.viewModel.indexYear = index
        }
    }
    
    @IBAction func actionDropdownMonth(_ sender: UIButton) {
        ddMonth.tag = 1
        actionDropdown(ddMonth, label: lbMonth, sender: sender, blackListSelect: []) { [weak self] index in
            self?.viewModel.indexMonth = index
        }
    }
    
    @IBAction func actionDropdownDay(_ sender: UIButton) {
        ddDay.tag = 2
        actionDropdown(ddDay, label: lbDay, sender: sender, blackListSelect: []) { [weak self] index in
            self?.viewModel.indexDay = index
        }
    }
    
    @IBAction func actionGender(_ sender: UIButton) {
        ddGender.tag = 3
        actionDropdown(ddGender, label: lbGender, sender: sender) { [weak self] index in
            self?.viewModel.indexGender = index
        }
    }
    
    @IBAction func actionProfession(_ sender: UIButton) {
        ddProfession.tag = 4
        actionDropdown(ddProfession, label: lbProfession, sender: sender) { [weak self] index in
            self?.viewModel.indexProfession = index
        }
    }
    
    @IBAction func actionDropdownHorseRacingYear(_ sender: UIButton) {
        ddHorseRacingYear.tag = 5
        actionDropdown(ddHorseRacingYear, label: lbHorseRacingYear, sender: sender) { [weak self] index in
            self?.viewModel.indexHorceRaceYear = index
        }
    }
    
    @IBAction func actionToNext(_ sender: Any) {
        viewModel.gotoNextStep(self)
        collapse()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        viewModel.onInputChange(sender, text: nil)
    }
    @IBAction func actionInquiries(_ sender: Any) {
        transitionToInquiries()
    }
    
}

extension UpdatePersonalInfoVC {
    
    func setupUI() {
        setupNavigation()
        configControl(style)
    }
    
    func setupData() {
        
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
        
        viewModel.horseRaceYears.bind { [weak self] results in
            guard let years: [String] = results?.map({ return $0.title }) else { return }
            self?.ddHorseRacingYear.dataSource = years
        }
        
        viewModel.genders.bind { [weak self] results in
            guard let genders: [String] = results else { return }
            self?.ddGender.dataSource = genders
        }
        
        viewModel.professions.bind { [weak self] results in
            guard let professions: [String] = results else { return }
            self?.ddProfession.dataSource = professions
        }
        
        viewModel.onChangeDay = { [weak self] (value, index) in
            self?.lbDay.text = value
        }
        
        viewModel.onLoadEmail.bind { [weak self] value in
            guard let email = value else { return }
            self?.setUpPlaceholder(email)
        }
        
        viewModel.onUpdateSuccessfully = { [weak self] in
            self?.viewModel.executeUpdateSuccess(self)
        }
        
        viewModel.onCheckPostCodeSuccessfully = { [weak self] in
            self?.viewModel.executeStep(self)
        }
        
        viewModel.onLoadUserInfo.bind { [weak self] info in
            guard let form = info?.form else { return }
           
            self?.lbYear.text = form.yearBirtdayToString()
            self?.lbMonth.text = form.monthBirtdayToString()
            self?.lbDay.text = form.dayBirtdayToString()
            self?.lbGender.text = form.genderToString()
            self?.lbProfession.text =  form.jobToString()
            self?.lbHorseRacingYear.text = form.racingStartYearToString()
            self?.tfPostcode.text = form.postCode
            
            self?.ddYear.focusAt = self?.viewModel.getIndexYear(year: form.yearBirtdayToInt()) ?? 0
            self?.ddHorseRacingYear.focusAt = self?.viewModel.getIndexHorseRaceYear(year: form.racingStartYearToInt()) ?? 0

        }
        
        viewModel.form.onBirthday = { [weak self] fill in
            if(self?.style == .update) {
                self?.lbLabelBirthday.require = !fill
            }
        }
        
        viewModel.form.onGender = { [weak self] fill in
            if(self?.style == .update) {
                self?.lbLabelGender.require = !fill
            }
        }
        
        viewModel.form.onPostCode = { [weak self] fill in
            if(self?.style == .update) {
                self?.lbLabelPostCode.require = !fill
            }
        }
        
        viewModel.form.onJob = { [weak self] fill in
            if(self?.style == .update) {
                self?.lbLabelJob.require = !fill
            }
        }
        
        viewModel.form.onHorseRacingYear = { [weak self] fill in
            if(self?.style == .update) {
                self?.lbLabelHorseRacingYear.require = !fill
            }
        }
    
        viewModel.form.onFilled = { [weak self] filled in
            self?.btnConfirmRegister.filled = filled
            self?.btnConfirmUpdate.filled = filled
        }
        
        Utils.onObserver(self, selector: #selector(onCompleteStep), name: .completeRegisterStep)
    }
    
    func setupEvent() {
        onHideKeyboard()
    }
    
    private func actionDropdown(_ dropDown: DropDown,
                                label: UILabel,
                                sender: UIButton,
                                blackListSelect: [Int] = [],
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
            
            var vFlag = value
            
            if(label == self.lbHorseRacingYear && index != 0) {
                vFlag = "\(value)年"
            }
            
            self.viewModel.formatDropdown(label, value: vFlag, indexAt: index, action: selectionAction)
            self.viewModel.onChoiceCombobox(dropDown, atIndex: index, value: value)
        }
        
        self.collapse()
    }
    
    @objc private func onCompleteStep() {
        self.dismiss(animated: true)
    }
    
    @objc private func onHideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(collapse))
        view.addGestureRecognizer(tap)
    }
    
    private func setUpPlaceholder(_ email: String) {

        lbEmail.isUserInteractionEnabled = false
        lbEmail.attributedText = self.configPlaceholder(withText: email)
    }
    
    private func configControl(_ style: ConfirmUpdateUserStyle) {
        switch style {
        case .new:
            btnConfirmUpdate.isHidden = true
            self.ddYear.focusAt = viewModel.getIndexOfDefaultYear()
            break
        case .update:
            btnConfirmRegister.isHidden = true
            lbStep.isHidden = true
            vGroupMail.isHidden = true
            vGroupPassword.isHidden = true
            vGroupConfirmPassword.isHidden = true
            vGroupLink.isHidden = true
            lbLabelBirthday.require = false
            lbLabelGender.require = false
            lbLabelJob.require = false
            lbLabelPostCode.require = false
            lbLabelHorseRacingYear.require = false
            configTextColor()
            break
        }
    }
    
    private func configTextColor() {
        lbYear.textColor = UIColor.black
        lbProfession.textColor = UIColor.black
        lbMonth.textColor = UIColor.black
        lbDay.textColor = UIColor.black
        lbGender.textColor = UIColor.black
        lbHorseRacingYear.textColor = UIColor.black
    }
    
    private func configHideDropDown() {
        ddYear.hide()
        ddMonth.hide()
        ddDay.hide()
        ddGender.hide()
        ddProfession.hide()
        ddHorseRacingYear.hide()
    }
}

extension UpdatePersonalInfoVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return viewModel.getTitle()
    }
    
    func navigationBar() -> Bool {
        return !inputScreen.useNavigation()
    }
}

extension UpdatePersonalInfoVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return viewModel.allowInput(textField, range: range, string: string)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        cacheTag = textField.tag
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        cacheTag = nil
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        if #available(iOS 17.0, *), cacheTag == 1 {
            builder.remove(menu: .autoFill)
        }
        super.buildMenu(with: builder)
    }
}
