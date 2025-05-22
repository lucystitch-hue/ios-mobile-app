//
//  ScanQRCodeGuideVC.swift
//  IMT-iOS
//
//  Created by dev on 20/04/2023.
//

import UIKit

class ScanQRCodeGuideVC: BaseViewController {
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblTitle: IMTLabel!
    @IBOutlet weak var lbDescription: IMTLabel!
    @IBOutlet weak var lblAction: IMTLabel!
    @IBOutlet weak var imvTikect: UIImageView!
    @IBOutlet weak var vCheckbox: IMTView!
    @IBOutlet weak var imvCheckbox: UIImageView!
    
    public var onDidClose: ((_ step: QRCodeStep?) -> Void)?
    
    private var step: QRCodeStep!
    private var viewModel: ScanQRCodeGuideViewModelProtocol!
    
    init(step: QRCodeStep) {
        super.init(nibName: nil, bundle: nil)
        self.step = step
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    @IBAction func actionNext(_ sender: Any) {
        viewModel.dismiss(self)
    }
    
    @IBAction func actionCheck(_ sender: Any) {
        guard let isCheck = viewModel.onChecked.value else { return }
        self.viewModel.onChecked.value = !isCheck
    }

}

//MARK: Private
extension ScanQRCodeGuideVC {
    private func setupUI() {
        setupControl(step)
    }
    
    private func setupData() {
        viewModel = ScanQRCodeGuideViewModel(step: step)
        
        viewModel.onChecked.bind { [weak self] result in
            guard let isCheck = result else { return }
            
            let image: UIImage = isCheck ? .icCheckboxBoldSelected : .icCheckboxBoldUnSelected
            self?.imvCheckbox.image = image
            
            Utils.setUserDefault(value: isCheck.description, forKey: .showGuideQR)
        }
    }
    
    private func setupControl(_ step: QRCodeStep) {
        lblTitle.text = step.title()
        lbDescription.text = step.description()
        lblAction.text = step.button()
        imvTikect.image = step.image()
        vCheckbox.isHidden = step.isHiddenCheck()
    }
    

}

