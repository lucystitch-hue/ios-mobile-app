//
//  ListJockeyResultSearchVC.swift
//  IMT-iOS
//
//  Created on 09/04/2024.
//
    

import UIKit

class ListJockeyResultSearchVC: BaseViewController {
    
    @IBOutlet private weak var collectWidget: CollectWidget!
    @IBOutlet private weak var cstCollectWidget: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cstHeightTableView: NSLayoutConstraint!
    @IBOutlet private weak var lbWarningMaxium: UILabel!
    
    var onGotoWebView: ((String) -> Void)?
    var onGotoListHorseAndJockey: ((ListHorsesAndJockeysSegment) -> Void)?
    
    var viewModel: ListJockeySearchResultViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        configCollectWidget()
        configTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isFirstLoad {
            viewModel.fetch()
        }
        super.viewWillAppear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableView = object as? UITableView, tableView == self.tableView {
            self.cstHeightTableView.constant = tableView.contentSize.height - 10
        }
    }
    
    private func configCollectWidget() {
        collectWidget.delegate = self
        collectWidget.setup()
        collectWidget.selected(viewModel.type)
    }
    
    private func configTableView() {
        tableView.addObserver(self, forKeyPath: "contentSize", context: nil)
        tableView.isScrollEnabled = false
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.register(UINib(nibName: TextSectionHeaderView.nameOfClass, bundle: nil), forHeaderFooterViewReuseIdentifier: TextSectionHeaderView.nameOfClass)
    }
    
    private func reloadTableView() {
        viewModel.sectionViewModels.forEach { sectionViewModel in
            sectionViewModel.cellViewModels().forEach { [weak self] cellViewModel in
                let nib = UINib(nibName: cellViewModel.nibName, bundle: nil)
                self?.tableView.register(nib, forCellReuseIdentifier: cellViewModel.cellIdentifier)
            }
        }
        tableView.reloadData()
    }
    
    private func bind() {
        viewModel.isLoading.bind(self) { [weak self] value in
            guard let self = self else {
                return
            }
            if (value) {
                Utils.showProgress()
            } else {
                Utils.hideProgress()
                lbWarningMaxium.isHidden = viewModel.warningMaximumText == nil
                lbWarningMaxium.text = viewModel.warningMaximumText
                reloadTableView()
            }
        }
        
        viewModel.emitPushListHorseAndJockey = { [weak self] segment in
            self?.onGotoListHorseAndJockey?(segment)
        }
        
        viewModel.emitPushWebview = { [weak self] link in
            self?.onGotoWebView?(link)
        }
        
        viewModel.emitShowPopup = { [weak self] (type, item) in
            self?.viewModel.showPopup(controller: self, info: (type, item))
        }
    }
}

extension ListJockeyResultSearchVC: UITableViewDelegate, UITableViewDataSource {
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
        let viewModel = cellViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier, for: indexPath)
        
        switch viewModel {
        case let ifavoriteSearchResultCellViewModel as IFavoriteSearchResultCellViewModel:
            if let ifavoriteSearchResultCell = cell as? IFavoriteSearchResultCell {
                ifavoriteSearchResultCell.viewModel = ifavoriteSearchResultCellViewModel
            }
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didChoice(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionViewModel = viewModel.sectionViewModels[section]
        return sectionViewModel.hasHeader() ? 30 : CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionViewModel = viewModel.sectionViewModels[section]
        guard sectionViewModel.hasHeader() else {
            return nil
        }
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TextSectionHeaderView.nameOfClass) as? TextSectionHeaderView
        header?.sectionTitle = sectionViewModel.headerTitle()
        header?.sectionTitleAligment = .center
        header?.sectionTitleFont = UIFont.appFontW6Size(16)
        header?.contentView.backgroundColor = UIColor.americanSilver
        header?.contentView.tintColor = UIColor.americanSilver
        return header
    }
}

extension ListJockeyResultSearchVC: CollectWidgetDelegate {
    func kindOfCollectWidget(_ widget: CollectWidget) -> CollectWidgetStyle {
        return .abbreviations(true)
    }
    
    func collectWidget(_ widget: CollectWidget, heightChange: Float) {
        cstCollectWidget.constant = CGFloat(heightChange)
    }
    
    func collectWidget(_ widget: CollectWidget, didSelectAt index: Int) {
        guard let type = Abbreviations.allCases.safeObjectForIndex(index: index) else { return }
        collectWidget.selected(type)
        viewModel.type = type
    }
    
    func collectWidget(_ widget: CollectWidget, disableWidgetAt index: Int) -> Bool {
        return false
    }
}

extension ListJockeyResultSearchVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.jockeySearch
    }
    
    func navigationBar() -> Bool {
        return true
    }
}
