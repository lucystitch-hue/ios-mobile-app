//
//  WarningV2VC.swift
//  IMT-iOS
//
//  Created on 19/03/2024.
//
    

import UIKit

class WarningV2VC: BaseViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var ivIcon: UIImageView!
    @IBOutlet weak var cstHeightIcon: NSLayoutConstraint!
    @IBOutlet weak var svContainer: UIStackView!
    @IBOutlet weak var svButtonGroup: UIStackView!
    
    var viewModel: WarningV2ViewModelProtocol!
    var onAction: ((_ tag: Int, _ controller: WarningV2VC?) -> Void)?
    private var type: WarningTypeV2!
    
    private var requireClose: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func checkVersionBecomeForeground() -> Bool {
        return false
    }
    
    //MARK: Constructor
    init(requireClose: Bool = true, type: WarningTypeV2) {
        super.init(nibName: "WarningV2VC", bundle: nil)
        self.requireClose = requireClose
        self.type = type
        self.viewModel = WarningV2ViewModel(type: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Public
    public func close() {
        self.dismiss(animated: true)
    }
}


extension WarningV2VC {
    private func setupUI() {
        configView()
        configControl()
    }
    
    private func setupData() {
        viewModel.onAction.bind { [weak self](result) in
            if let requireClose = self?.requireClose, requireClose {
                self?.close()
            }
            
            if let isIntial = result?.isIntial, isIntial == false {
                guard let tag = result?.tag else { return }
                self?.onAction?(tag, self)
            }
        }
    }
    
    private func configView() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.25)
    }
    
    private func configControl() {
        self.lblTitle.attributedText = type.title()
        self.lblDescription.attributedText = type.description()
        self.ivIcon.image = type.image()
        self.cstHeightIcon.constant = type.imageHeight()
        self.svContainer.spacing = type.space()
        addButton()
    }
    
    private func addButton() {
        viewModel.generateButtons(svButtonGroup)
    }
}
