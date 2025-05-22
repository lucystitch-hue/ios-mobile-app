//
//  PrivacyPolicyVC.swift
//  IMT-iOS
//
//  Created by dev on 04/05/2023.
//

import UIKit

class PrivacyPolicyVC: BaseViewController {
    
    @IBOutlet weak var tvContent: UITextView!
    
    private var viewModel: PrivacyPolicyViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
}
extension PrivacyPolicyVC {
    private func setupUI() {
        setupNavigation()
        configTextView()
    }
    
    private func setupData() {
        viewModel = PrivacyPolicyViewModel()
        
        viewModel.onAttributeHTML.bind { [weak self] attribute in
            self?.tvContent.attributedText = attribute
        }
    }
    
    private func configTextView(){
        tvContent.isEditable = false
    }
}

extension PrivacyPolicyVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.privacyPolicy
    }
}


