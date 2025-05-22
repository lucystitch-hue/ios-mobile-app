//
//  TermsOfServiceVC.swift
//  IMT-iOS
//
//  Created by dev on 04/05/2023.
//

import UIKit

class TermsOfServiceVC: BaseViewController {
    
    @IBOutlet weak var tvContent: IMTTextView!
    
    private var viewModel: PopupTermViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
}
extension TermsOfServiceVC {
    private func setupUI() {
        setupNavigation()
        configTextView()
    }
    
    private func setupData() {
        viewModel = PopupTermViewModel()
        
        viewModel.onAttributeHTML.bind { [weak self] attribute in
            self?.tvContent.attributedText = attribute
        }
    }
    
    private func configTextView(){
        tvContent.isEditable = false
        tvContent.layer.borderWidth = 0
        tvContent.layer.borderColor =  UIColor.clear.cgColor
    }
}

extension TermsOfServiceVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.termsOfService
    }
}
