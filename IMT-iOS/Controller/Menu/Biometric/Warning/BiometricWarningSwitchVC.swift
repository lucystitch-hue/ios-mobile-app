//
//  BiometricWarningSwitchVC.swift
//  IMT-iOS
//
//  Created by dev on 06/09/2023.
//

import UIKit

class BiometricWarningSwitchVC: BaseViewController {

    public var onDisableBiometric: JVoid?
    public var onDismiss: JVoid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Action
    @IBAction func actionOff(_ sender: Any) {
        onDisableBiometric?()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }
    
}
