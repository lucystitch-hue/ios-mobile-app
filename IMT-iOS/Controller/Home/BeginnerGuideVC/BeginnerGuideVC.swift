//
//  BeginerGuideVC.swift
//  IMT-iOS
//
//  Created by dev on 22/05/2023.
//

import UIKit

class BeginnerGuideVC: BaseViewController {
    
    @IBOutlet weak var imvBackground: UIImageView!
    @IBOutlet weak var svContent: UIStackView!
    
    private var viewModel: BeginGuideViewModelProtocol!
    public var onTransition: (JTransAgent)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
}

//MARK: Private
extension BeginnerGuideVC {
    private func setupUI() {
        
    }
    
    private func setupData() {
        viewModel = BeginerGuideViewModel()
        
        viewModel.onLoadContent.bind { [weak self] (value) in
            guard let view = value?.view else { return }
            self?.svContent.addArrangedSubview(view)
        }
        
        viewModel.onTransition = { [weak self] trans in
            self?.onTransition?(trans)
        }
    }
    
}
