//
//  RaceHorseSearchVC.swift
//  IMT-iOS
//
//  Created on 18/03/2024.
//
    

import UIKit

class RaceHorseSearchVC: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cstHeightTableView: NSLayoutConstraint!
    @IBOutlet private weak var lbStartWith: UILabel!
    @IBOutlet private weak var lbWarning: UILabel!
    
    var onGotoResultSearch: ((String, [OshiUma]) -> Void)?
    
    private let ddStartWith = DropDown()
    
    var viewModel: RaceHorseSearchViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableView = object as? UITableView, tableView == self.tableView {
            cstHeightTableView.constant = tableView.contentSize.height
        }
    }
    
    @IBAction func actionDropdown(_ sender: UIButton) {
        collapse()
        ddStartWith.tag = 0
        actionDropdown(ddStartWith, label: lbStartWith, sender: sender, blackListSelect: []) { [weak self] index in
            self?.viewModel.onChangeDropdown(index)
        }
    }
    
    @IBAction func actionSearch(_ sender: Any) {
        collapse()
        viewModel.handleSearch(self)
    }
    
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        viewModel.onChangeInput(sender)
    }
    
    private func setupUI() {
        setupNavigation()
        setupTableView()
    }
    
    private func setupData() {
        bind()
        reloadTableView()
    }
    
    private func setupTableView() {
        tableView.addObserver(self, forKeyPath: "contentSize", context: nil)
        tableView.separatorStyle = .none
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0
        tableView.register(UINib(nibName: TextSectionHeaderView.nameOfClass, bundle: nil), forHeaderFooterViewReuseIdentifier: TextSectionHeaderView.nameOfClass)
        tableView.bounces = false
    }
    
    func reloadTableView() {
        viewModel.sectionViewModels.forEach { sectionViewModel in
            sectionViewModel.cellViewModels().forEach { [weak self] cellViewModel in
                let nib = UINib(nibName: cellViewModel.nibName, bundle: nil)
                self?.tableView.register(nib, forCellReuseIdentifier: cellViewModel.cellIdentifier)
            }
        }
        tableView.reloadData()
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
            cell.lblTitle.textColor = .darkCharcoal
            cell.lblTitle.text = string
            cell.selectedBackgroundColor = index == 0 ? nil : dropDown.selectionBackgroundColor
            cell.lblTitle.font = .appFontW3Size(13)
        }
        
        dropDown.show()
        dropDown.selectionAction = {(index, value) in
            self.formatDropdown(label, value: value, indexAt: index, action: selectionAction)
        }
        
        self.collapse()
    }
    
    private func formatDropdown(_ label: UILabel, value: String, indexAt index: Int, action selectionAction: @escaping(_ index: Int) -> Void) {
        label.text = value
        label.textColor = .quickSilver
        selectionAction(index)
    }
    
    private func bind() {
        viewModel.error.bind(self, performInitialUpdate: false) { [weak self] error in
            guard let self = self else { return }
            lbWarning.isHidden = error == nil
            lbWarning.text = error
        }
        
        viewModel.datasource.bind(self) { [weak self] datasource in
            guard let self = self else { return }
            ddStartWith.dataSource = datasource
        }
        
        viewModel.isLoading.bind(self) { value in
            if (value) {
                Utils.showProgress()
            } else {
                Utils.hideProgress()
            }
        }
    }
}

extension RaceHorseSearchVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionViewModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionViewModel = viewModel.sectionViewModels[section]
        return sectionViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionViewModel = viewModel.sectionViewModels[indexPath.section]
        let cellViewModels = sectionViewModel.cellViewModels()
        guard indexPath.row < cellViewModels.count else {
            return UITableViewCell()
        }
        let cellViewModel = cellViewModels[indexPath.row]
        return viewModel.getCell(tableView, cellViewModel: cellViewModel, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionViewModel = viewModel.sectionViewModels[section]
        return sectionViewModel.hasHeader() ? UITableView.automaticDimension : CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewModel = viewModel.sectionViewModels[section]
        guard sectionViewModel.hasHeader() else {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TextSectionHeaderView.nameOfClass) as? TextSectionHeaderView
        header?.sectionTitle = sectionViewModel.headerTitle()
        header?.sectionTitleColor = UIColor.main
        header?.sectionTitleFont = UIFont.appFontW6Size(16)
        header?.sectionTitleLeadingGap = 0
        return header
    }
}

extension RaceHorseSearchVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.raceHorseSearch
    }
    
    func navigationBar() -> Bool {
        return true
    }
}
