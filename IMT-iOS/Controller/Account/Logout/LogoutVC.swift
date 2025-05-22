//
//  LogoutVC.swift
//  IMT-iOS
//
//  Created by dev on 10/04/2023.
//

import UIKit

class LogoutVC: BaseViewController {
    
    private var viewModel: LogoutViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
    //MARK: Action
    @IBAction func actionLogout(_ sender: Any) {
        viewModel.logout()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        viewModel.close(self)
    }
}

//MARK: Private
extension LogoutVC {
    private func setupUI() {
        
    }
    
    private func setupData() {
        viewModel = LogoutViewModel()
    }
}
