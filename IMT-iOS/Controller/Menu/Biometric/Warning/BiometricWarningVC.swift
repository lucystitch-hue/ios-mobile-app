//
//  BiometricWarningVC.swift
//  IMT-iOS
//
//  Created by dev on 28/08/2023.
//

import UIKit

class BiometricWarningVC: BaseViewController {
    
    public var onDismiss: JVoid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
        }
    }
}
