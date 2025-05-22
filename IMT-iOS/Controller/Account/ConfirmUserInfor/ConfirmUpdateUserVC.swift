//
//  ConfirmUpdateUserVC.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import UIKit
import LocalAuthentication

class ConfirmUpdateUserVC: BaseViewController {
    
    @IBOutlet weak var lbDateBirth : UILabel!
    @IBOutlet weak var lbMail : UILabel!
    @IBOutlet weak var lbPostCode : UILabel!
    @IBOutlet weak var lbSex : UILabel!
    @IBOutlet weak var lbProfession : UILabel!
    @IBOutlet weak var lbHorseRacing : UILabel!
    @IBOutlet var btnDisable : [UIButton]!
    @IBOutlet weak var lbCentralHorseRacing: UILabel!
    @IBOutlet weak var lbJapanRacingAssociation: UILabel!
    @IBOutlet weak var lbPassword: UILabel!
    
    @IBOutlet weak var vEmail: UIView!
    @IBOutlet weak var vPassword: UIView!
    @IBOutlet weak var vCentralHorseRacing: UIView!
    @IBOutlet weak var vJapanRacingAssociation: UIView!
    @IBOutlet weak var lbButton: IMTLabel!
    @IBOutlet weak var vBtnBack: UIView!
    
    public var onGotoUpdatePersonInfo: (([String: Any?]) -> Void)?
    
    private var style: ConfirmUpdateUserStyle!
    private var inputScreen: UpdatePersonalFromScreen!
    private var viewModel: ComfirmUpdateUserViewModelProtocol!
    
    init(style: ConfirmUpdateUserStyle, form: FormUpdatePersonalInfo?, inputScreen: UpdatePersonalFromScreen = .other) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
        self.inputScreen = inputScreen
        viewModel = ConfirmUpdateUserViewModel(style: style, form: form) //
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.removeObserver()
    }
    
    override func gotoBack() {
        viewModel.back(self)
    }

    @IBAction func actionConfirm(_ sender: Any) {
        viewModel.confirm(self)
    }
    
    @IBAction func actionBack(_ sender: Any) {
        pop(ofClass: UpdatePersonalInfoVC.classForCoder())
    }
    
}

extension ConfirmUpdateUserVC {
    private func setupUI(){
        setupNavigation()
        configStep()
        configButton()
    }

    private func setupData() {

        viewModel.onLoadUserInfo.bind { [weak self] info in
            guard let form = info?.form else { return }
            
            self?.lbDateBirth.text = form.birtdayToString()
            self?.lbMail.text = form.email
            self?.lbPostCode.text = form.postCode
            self?.lbSex.text = form.genderToString()
            self?.lbProfession.text = form.jobToString()
            self?.lbHorseRacing.text = form.racingStartYearToString()
            self?.lbPassword.text = form.passwordToString()
        }
        
        viewModel.onLoginSuccessfully.bind { [weak self] success in
            Utils.hideProgress()
            let style = IMTBiometricAuthentication.getStyle()
            
            if(success == true) {
                if(style == .none) {
                    Utils.setUserDefault(value: "true", forKey: .didUseBiomatricAuthentication)
                    self?.viewModel.gotoHome(self)
                } else {
                    self?.viewModel.gotoBiometricAuthentication(self)
                }
            }
        }
    }
    
    private func configStep() {
        if(style == .update){
            configView()
            setTitleButton()
        } else if (style == .new) {
            configLabel()
            configView()
        }
    }
    
    private func configLabel() {

        lbJapanRacingAssociation.attributedText =  self.configAttribute(text: .ComfirmUserInforString.japanRacingAssociation , alignmentText: "left")
        lbCentralHorseRacing.attributedText = self.configAttribute(text: .ComfirmUserInforString.centralHorseRacing , alignmentText: "left")
    }
    
    private func setTitleButton() {
        lbButton.text = "変更する"
    }
    
    private func configView() {
        switch style {
        case .update:
            vEmail.isHidden = true
            vPassword.isHidden = true
            vBtnBack.isHidden = true
            break
        default:
            break
        }
    }
    
    private func configButton() {
        btnDisable.forEach {
            $0.isEnabled = false
        }
    }

}

extension ConfirmUpdateUserVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return style.title()
    }
    
    func navigationBar() -> Bool {
        return !self.inputScreen.useNavigation()
    }
}






