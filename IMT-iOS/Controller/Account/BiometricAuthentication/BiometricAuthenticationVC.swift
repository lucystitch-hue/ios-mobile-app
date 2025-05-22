//
//  BiometricAuthenticationVC.swift
//  IMT-iOS
//
//  Created by dev on 17/08/2023.
//

import UIKit

class BiometricAuthenticationVC: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imvLogo: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnScan: IMTRequiredButton!
    
    private var viewModel: BiometricAuthenticationViewModelProtocol!
    
    init() {
        super.init(nibName: "BiometricAuthenticationVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    @IBAction func actionScan(_ sender: Any) {
        viewModel.scan()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        viewModel.close(self)
    }
}

extension BiometricAuthenticationVC {
    private func setupUI() {
        let style = IMTBiometricAuthentication.getStyle()
        setupNavigation()
        configControl(style)
    }
    
    private func setupData() {
        viewModel = BiometricAuthenticationViewModel()
    }
    
    private func configControl(_ style: BiometricAuthenticationStyle) {
        lblTitle.text = style.title()
        imvLogo.image = style.image()
        lblDescription.attributedText = style.description()
        btnScan.filled = true
    }
}

extension BiometricAuthenticationVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.biometricAuthentication
    }
    
    func hideButtonBack() -> Bool {
        return true
    }
}
