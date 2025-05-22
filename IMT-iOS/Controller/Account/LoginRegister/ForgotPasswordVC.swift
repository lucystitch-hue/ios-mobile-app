//
//  ForgotPasswordVC.swift
//  IMT-iOS
//
//  Created by dev on 24/04/2023.
//

import UIKit

class ForgotPasswordVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setGradientBackground()
        super.viewWillAppear(animated)
    }

    @IBAction func actionSendResetEmail(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
}

extension ForgotPasswordVC {
    
    private func setupUI() {
        self.setGradientBackground()
    }
    
    private func setupData() {
    
    }
}
