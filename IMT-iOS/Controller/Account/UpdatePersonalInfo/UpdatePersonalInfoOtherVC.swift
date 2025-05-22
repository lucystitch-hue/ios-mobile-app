//
//  UpdatePersonalInfoOtherVC.swift
//  IMT-iOS
//
//  Created by dev on 15/03/2023.
//

import UIKit

class UpdatePersonalInfoOtherVC: BaseViewController {
    
    @IBOutlet weak var tbvAnswer: UITableView!
    @IBOutlet weak var lblPage: IMTLabel!
    @IBOutlet weak var lblTitle: IMTLabel!
    @IBOutlet weak var btnNext: IMTButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var cstHeightTableAnswer: NSLayoutConstraint!
    
    private var type: RegisterStepType!
    private var viewModel: UpdatePersonalInfoOtherViewModelProtocol!
    
    init(data: [RegisterStepType: [InputStepRegisterModel]], type: RegisterStepType, form: FormUpdatePersonalInfo) {
        super.init(nibName: nil, bundle: nil)
        self.type = type
        viewModel = UpdatePersonalInfoOtherViewModel(data: data, type: type, form: form)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let tableView = object as? UITableView else { return }
        if(tableView == tbvAnswer) {
            self.cstHeightTableAnswer.constant = tableView.contentSize.height
        }
    }
    
    //MARK: Action
    @IBAction func actionNext(_ sender: Any) {
        self.viewModel.nextStep(self)
    }
    
    @IBAction func actionSkip(_ sender: Any) {
        self.viewModel.skip(self)
    }
}

//MARK: Private
extension UpdatePersonalInfoOtherVC {
    private func setupUI() {
        setupNavigation()
        configTable()
        updateTitle(type)
    }
    
    private func setupData() {
        viewModel.items.bind { [weak self] results in
            self?.tbvAnswer.reloadData()
        }
        
        viewModel.indexSelected.bind { [weak self] result in
            self?.tbvAnswer.reloadData()
        }
        
        viewModel.onHideSkip.bind { [weak self] hidden in
            guard let hidden = hidden else { return }
            self?.btnSkip.isHidden = hidden
            self?.btnSkip.isUserInteractionEnabled = !hidden
        }
    }
    
    private func configTable() {
        self.tbvAnswer.register(identifier: IMTCheckboxCell.identifier)
        self.tbvAnswer.addObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
    private func updateTitle(_ type: RegisterStepType) {
        lblPage.text = type.page()
        lblTitle.attributedText = type.attribute()
        btnNext.setTitleWithoutAnimation(type.buttonTitle(), for: .normal)
    }
}

extension UpdatePersonalInfoOtherVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return type.screenTitle()
    }
}

extension UpdatePersonalInfoOtherVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.getCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.getFooter(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(viewModel.getHeightFooter(tableView, section: section))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelected(tableView, indexPath: indexPath)
    }
}
