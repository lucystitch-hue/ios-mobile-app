//
//  InquiryImprovementRequestVC.swift
//  IMT-iOS
//
//  Created by dev on 22/05/2023.
//

import UIKit

class InquiryImprovementRequestVC: BaseViewController {
    
    @IBOutlet weak var lbTitle: IMTLabel!
    @IBOutlet weak var lbDescribe: IMTLabel!
    @IBOutlet weak var lbCategory: IMTLabel!
    @IBOutlet weak var lbDeviceUsing: IMTLabel!
    @IBOutlet weak var lbOperatingSystem: IMTLabel!
    @IBOutlet weak var tfEmail: IMTTextField!
    
    private let ddCategory = DropDown()
    private let ddDeviceUsing = DropDown()
    private let ddOperatingSystem = DropDown()
    
    private var viewModel: InquiryImprovementRequestViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.loadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.removeObserverNotificationCenter()
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionCategory(_ sender: UIButton) {
        actionDropdown(ddCategory, label: lbCategory, sender: sender) { [weak self] index in
            self?.viewModel.indexCategory = index
        }
    }
    
    @IBAction func actionDeviceUsing(_ sender: UIButton) {
        actionDropdown(ddDeviceUsing, label: lbDeviceUsing, sender: sender) { [weak self] index in
            self?.viewModel.indexDeviceUsing = index
        }
    }
    
    @IBAction func actionOperatingSystem(_ sender: UIButton) {
        actionDropdown(ddOperatingSystem, label: lbOperatingSystem, sender: sender) { [weak self] index in
            self?.viewModel.indexOperatingSystem = index
        }
    }
    
    @IBAction func actionSend(_ sender: Any) {
    }
}

extension InquiryImprovementRequestVC {
    private func setupUI() {
        setupNavigation()
        configLabel()
    }
    
    private func setupData() {
        viewModel = InquiryImprovementRequestViewModel()
        
        viewModel.category.bind { [weak self] results in
            guard let categorys: [String] = results  else { return }
            self?.ddCategory.dataSource = categorys
        }
        
        viewModel.deviceUsing.bind { [weak self] results in
            guard let deviceUsings: [String] = results else { return }
            self?.ddDeviceUsing.dataSource = deviceUsings
            
        }
        
        viewModel.operatingSystem.bind { [weak self] results in
            guard let operatingSystems: [String] = results else { return }
            self?.ddOperatingSystem.dataSource = operatingSystems
        }
        
        viewModel.meDataModel.bind { [weak self] result in
            guard let data = result?.data else { return }
            let tfEmail = " \(data.email.encrypt())"
            self?.tfEmail.text = tfEmail
        }
        
    }
    
    private func configLabel() {
        lbTitle.text = .InquiryImprovementRequestString.title
        lbDescribe.attributedText = self.configAttribute(text: .InquiryImprovementRequestString.describe, alignmentText: "left")
    }
    
    private func actionDropdown(_ dropDown: DropDown,
                                label: UILabel,
                                sender: UIButton,
                                blackListSelect: [Int] = [],
                                action selectionAction: @escaping(_ index: Int) -> Void) {
        dropDown.anchorView = sender
        dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
        dropDown.cellNib = UINib(nibName: IMTDropDownCell.identifier, bundle: nil)
        dropDown.textColor = .clear
        dropDown.selectedTextColor = .clear
        dropDown.blackListSelected = blackListSelect
        dropDown.customCellConfiguration = {(index, string, cell) in
            guard let cell = cell as? IMTDropDownCell else { return }
            cell.lblTitle.textColor = index == 0 ? .quickSilver : .darkCharcoal
            cell.lblTitle.text = string
            cell.selectedBackgroundColor = index == 0 ? nil : dropDown.selectionBackgroundColor
            cell.lblTitle.font = .appFontW3Size(13)
        }
        
        dropDown.show()
        dropDown.selectionAction = {(index, value) in
            label.text = value
            label.textColor = index == 0 ? .quickSilver : .darkCharcoal
            selectionAction(index)
        }
        
        self.collapse()
    }
}

extension InquiryImprovementRequestVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.inquiryImprovementRequest
    }
}

