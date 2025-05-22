//
//  VoteOnlineTabBar.swift
//  IMT-iOS
//
//  Created by dev on 30/08/2023.
//

import UIKit

class VoteVC: IMTContentActionVC<VoteViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        super.setupUI()
        self.onHiddenBack(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupData()
    }
    
    override func setupData() {
        viewModel = VoteViewModel()
        
        viewModel.transitionVote(self)
        
        viewModel.onTransactionVote = { [weak self] path in
            self?.transitionFromSafari(path)
        }
    }
    
    override func back() {
        viewModel.back(self)
    }
    
    override func onSwipe(x: CGFloat, alpha: CGFloat, finish: Bool = false) {
        viewModel.swipe(self, x: x, alpha: alpha, finish: finish)
    }
}

