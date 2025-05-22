//
//  ResultUpdateEmailSuccessVC.swift
//  IMT-iOS
//
//  Created by dev on 31/08/2023.
//

import UIKit

class ResultUpdateEmailSuccessVC: BaseViewController {

    private var viewModel: ResultUpdateEmailSuccessProtocol!
    private var newEmail: String!
    private var password: String!
    
    init(newEmail: String, password: String) {
        super.init(nibName: nil, bundle: nil)
        self.newEmail = newEmail
        self.password = password
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    @IBAction func actionResend(_ sender: Any) {
        viewModel.resend()
    }
}

//MARK: Private
extension ResultUpdateEmailSuccessVC {
    private func setupUI() {
        setupNavigation()
    }
    
    private func setupData() {
        viewModel = ResultUpdateEmailSuccessViewModel(newEmail: newEmail, password: password)
    }
}

extension ResultUpdateEmailSuccessVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return String.TitleScreen.resultUpdateEmailSuccess
    }
    
    func navigationBar() -> Bool {
        return true
    }
}
