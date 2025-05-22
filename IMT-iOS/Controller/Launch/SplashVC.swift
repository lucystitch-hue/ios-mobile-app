//
//  SplashVC.swift
//  IMT-iOS
//
//  Created by dev on 21/06/2023.
//

import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setGradientBackground()
    }
}
