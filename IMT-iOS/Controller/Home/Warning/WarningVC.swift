//
//  WarningVC.swift
//  IMT-iOS
//
//  Created by dev on 04/08/2023.
//

import UIKit

class WarningVC: BaseViewController {

    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var btnDismiss: IMTBorderButton!
    @IBOutlet private weak var btnFilled: IMTButton!
    @IBOutlet private weak var ivIcon: UIImageView!
    @IBOutlet weak var cstHeightIcon: NSLayoutConstraint!
    @IBOutlet weak var svContainer: UIStackView!
    
    var viewModel: WarningViewModel!
    var onDismiss: ((_ action: WarningAction?, _ controller: WarningVC?) -> Void)?
    
    private var requireClose: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStyle()
        bind()
    }
    
    override func checkVersionBecomeForeground() -> Bool {
        return false
    }
    
    //MARK: Constructor
    init(requireClose: Bool = true) {
        super.init(nibName: "WarningVC", bundle: nil)
        self.requireClose = requireClose
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Action
    @IBAction func actionClose(_ sender: UIButton) {
        if(requireClose) {
            dismiss(animated: false) { [weak self] in
                self?.onDismiss?(WarningAction(rawValue: sender.tag), self)
            }
        } else {
            self.onDismiss?(WarningAction(rawValue: sender.tag), self)
        }
    }
    
    //MARK: Public
    public func close() {
        self.dismiss(animated: true)
    }
    
    //MARK: Private
    private func applyStyle() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.25)
    }
    
    private func bind() {
        
        let defaultColor = viewModel.themeColor.first
        
        lblTitle.attributedText = viewModel.title
        lblTitle.isHidden = viewModel.title.string.isEmpty
        lblDescription.attributedText = viewModel.description
        btnDismiss.setAttributedTitle(viewModel.textBorderedButton, for: .normal)
        btnDismiss.isHidden = viewModel.textBorderedButton.string.isEmpty
        btnDismiss.layer.borderColor = defaultColor?.cgColor
        btnDismiss.setTitleColor(defaultColor, for: .normal)
        btnDismiss.borderWith = Constants.System.borderWidthOfIMTBorderButton
        btnFilled.setAttributedTitle(viewModel.textFilledButton, for: .normal)
        btnFilled.isHidden = viewModel.textFilledButton.string.isEmpty
        btnFilled.backgroundColor = defaultColor
        ivIcon.image = viewModel.image
        cstHeightIcon.constant = viewModel.imageHeight
        
        //MARK: Space
        if let space = viewModel.space {
            svContainer.spacing = space
        }
        
        //MARK: Color
        if let dismissColor = viewModel.themeColor.last {
            btnDismiss.layer.borderColor = dismissColor.cgColor
            btnDismiss.setTitleColor(dismissColor, for: .normal)
        }
    }
}
