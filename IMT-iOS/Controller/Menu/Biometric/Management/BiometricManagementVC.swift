//
//  BiometricManagementVC.swift
//  IMT-iOS
//
//  Created by dev on 28/08/2023.
//


import UIKit

class BiometricManagementVC: BaseViewController {
    
    //MARK: Properties
    @IBOutlet weak var swBitometric: UISwitch!
    @IBOutlet weak var swEnhanceSecurity: UISwitch!
    
    private var viewModel: BiometricManagementProtocol!
    
    public var onDisableBiometric: JVoid?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func willChangeForeground() {
        super.willChangeForeground()
        viewModel.recheckStateBiometric(self)
    }
    
    //MARK: Action
    @IBAction func actionBitometric(_ sender: Any) {
        let value = viewModel.flagSwitch.value?.switchValue ?? true
        viewModel.flagSwitch.value = (false, !value)
    }
    
    @IBAction func actionEnhancedSecurity(_ sender: Any) {
        viewModel.switchEnhanceSecurity()
    }
    
    //MARK: Public
    public func didDisableBitometric() {
        swBitometric.isOn = false
        viewModel.flagSwitch.updateNoBind((false, false))
        viewModel.switchBiometric(self)
        Utils.postLogout()
    }
    
    public func didResetBiometric() {
        let value = !swBitometric.isOn
        swBitometric.isOn = value
        swEnhanceSecurity.isEnabled = value
        viewModel.flagSwitch.updateNoBind((false, value))
    }
}

//MARK: Private
extension BiometricManagementVC {
    private func setupUI() {
        setupNavigation()
        setupSwEnhanceSecurity()
    }
    
    private func setupData() {
        viewModel = BiometricManagementViewModel()
        
        viewModel.flagSwitch.bind { [weak self] result in
            let isIntial = result?.isInitial ?? true
            let value = result?.switchValue ?? false
            
            if(value == false) {
                if(!isIntial) {
                    self?.onDisableBiometric?()
                } else {
                    self?.swBitometric.isOn = false
                    self?.swEnhanceSecurity.isOn = false
                    self?.swEnhanceSecurity.isEnabled = false
                }
            } else {
                if !(isIntial) {
                    self?.viewModel.switchBiometric(self)
                }
                self?.swBitometric.isOn = value
            }
            
            self?.swEnhanceSecurity.isEnabled = value
        }
        
        viewModel.enhanceSecuritySwitch.bind { [weak self] value in
            guard let value = value else {
                self?.swEnhanceSecurity.isOn = false
                return
            }
            self?.swEnhanceSecurity.isOn = value
        }
        
        viewModel.onInvalid = { [weak self] in
            self?.swBitometric.isOn = false
            self?.swEnhanceSecurity.isEnabled = false
        }
    }
    
    private func setupSwEnhanceSecurity() {
        self.swEnhanceSecurity.isEnabled = false
    }
}

extension BiometricManagementVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return String.TitleScreen.biometricManagement
    }
    
    func navigationBar() -> Bool {
        return true
    }
    
}
