//
//  PopupTermVC.swift
//  IMT-iOS
//
//  Created by dev on 07/03/2023.
//

import UIKit
import CoreGraphics

class PopupTermVC: BaseViewController {
    
    @IBOutlet weak var btnAccpet: UIButton!
    @IBOutlet weak var tvContent: IMTTextView!
    
    var onComplete: JVoid?
    
    private var viewModel: PopupTermViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func checkVersionBecomeForeground() -> Bool {
        return false
    }
    
    @IBAction func actionAccept(_ sender: Any) {
        viewModel.gotoLogin(self)
    }
}

extension PopupTermVC {
    private func setupUI() {
        setupNavigation()
        configTextView()
    }
    
    private func setupData() {
        viewModel = PopupTermViewModel()
        
        viewModel.allowCheck.bind { [weak self] result in
            let colorBtn: UIColor = result ?? false ? .wageningenGreen : .cultured
            self?.btnAccpet.backgroundColor = colorBtn
            let colorTitle: UIColor = result ?? false ? .white : .lightGray
            self?.btnAccpet.setTitleColor(colorTitle, for: .normal)
            self?.btnAccpet.isEnabled = result ?? false
        }
        
        viewModel.onAttributeHTML.bind { [weak self] attribute in
            self?.tvContent.attributedText = attribute
        }
        
        viewModel.onDidResultCheckVerion = { [weak self] state in
            self?.viewModel.showPopupUpgrade(self, state: state)
        }
        
        self.scrollViewDidScroll(tvContent)
    }
    
    private func configTextView(){
        tvContent.isEditable = false
        tvContent.layer.borderWidth = 0
        tvContent.layer.borderColor =  UIColor.clear.cgColor
        tvContent.delegate = self
    }
}

extension PopupTermVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.termApp
    }
    
    func hideButtonBack() -> Bool {
        return true
    }
}

extension PopupTermVC: UITextViewDelegate {
}

extension PopupTermVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.viewModel.allowCheck.value == false) {
            if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height {
                viewModel.allowCheck.value = true
            }
        }
    }
}
