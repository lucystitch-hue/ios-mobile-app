//
//  PopupVC.swift
//  IMT-iOS
//
//  Created by dev on 06/09/2023.
//

import UIKit

class PopupDeleteAccountVC: BaseViewController {
    
    private var viewModel: PopupDeleteAccountViewModelProtocol!
    public var onDismiss: JVoid?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
    }
    
    //MARK: Action
    @IBAction func actionDelete(_ sender: Any) {
        viewModel.delete()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        viewModel.close(self)
    }
}

//MARK: Private
extension PopupDeleteAccountVC {
    private func setupUI() {
        
    }
    
    private func setupData() {
        viewModel = PopupDeleteAccountViewModel()
    }
}
