//
//  LinkageSubcriptionVC.swift
//  IMT-iOS
//
//  Created by dev on 11/03/2023.
//

import UIKit

class LinkageSubcriptionVC: BaseViewController {
    
    @IBOutlet weak var imvCheck: UIImageView!
    
    private var viewModel: LinkageSubcriptionViewModelProtocol!
    
    public var onGotoVoteOnline: JVoid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    var onDismiss: JVoid?
    
    //MARK: Action
    @IBAction func actionPAT(_ sender: Any) {
        viewModel.pat(self)
    }
    
    @IBAction func actionSubscriberNumber(_ sender: Any) {
        viewModel.enterSubscriberNumber(self)
    }
    
    @IBAction func actionIgnore(_ sender: Any) {
        viewModel.ignore(self)
    }
    
    @IBAction func actionMaskConfirmNoShowPopup(_ sender: Any) {
        viewModel.isConfirmNoShowPopup.value = !(viewModel.isConfirmNoShowPopup.value ?? false)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let onDismiss = onDismiss else { return }
        onDismiss()
    }

}

//MARK: Private
extension LinkageSubcriptionVC {
    private func setupUI() {
        
    }
    
    private func setupData() {
        viewModel = LinkageSubcriptionViewModel()
    }
}
