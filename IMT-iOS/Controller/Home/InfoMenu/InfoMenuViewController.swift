//
//  InfoMenuViewController.swift
//  IMT-iOS
//
//  Created on 25/01/2024.
//
    

import UIKit
import MaterialComponents.MaterialTabs_TabBarView

class InfoMenuViewController: BaseViewController {
    
    @IBOutlet private weak var tabBarContainer: UIView!
    @IBOutlet private weak var cstHeightTabBarContainer: NSLayoutConstraint!
    @IBOutlet private weak var tableView: UITableView!
    
    private let tabBarView: MDCTabBarView = MDCTabBarView()
    private var cacheIndexPositionSection: Int = 0
    private var cacheContentOffset: CGPoint?
    
    var viewModel: InfoMenuViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tabBarView = object as? UIScrollView, tabBarView == self.tabBarView {
            self.cstHeightTabBarContainer.constant = tabBarView.contentSize.height
        } else if let tableView = object as? UITableView, tableView == self.tableView, let index = tableView.indexPathsForVisibleRows?.first, index.section != cacheIndexPositionSection, let item = tabBarView.items.safeObjectForIndex(index: index.section), cacheContentOffset == nil {
            tabBarView.setSelectedItem(item, animated: true)
            cacheIndexPositionSection = index.section
            cacheContentOffset = nil
        }
    }
}

extension InfoMenuViewController {
    private func setupUI() {
        setupNavigation()
        configTabBarView()
        configTableView()
    }
    
    private func setupData() {
        viewModel.menuSections.bind { [weak self] value in
            guard let value = value else { return }
            let tabBarItems = value.mapIndex { index, item in
                return UITabBarItem(title: item.rawValue, image: nil, tag: index)
            }
            self?.tabBarView.items = tabBarItems
            self?.tabBarView.setSelectedItem(tabBarItems.first, animated: false)
        }
        
        reloadTableView()
    }
    
    private func configTabBarView() {
        tabBarView.setContentPadding(.init(top: 0, left: 0, bottom: 0, right: 0), for: .scrollableCentered)
        tabBarView.setTitleFont(UIFont.appFontW6Size(14), for: .normal)
        tabBarView.setTitleColor(.quickSilver, for: .normal)
        tabBarView.setTitleColor(.black, for: .selected)
        tabBarView.preferredLayoutStyle = .scrollableCentered
        tabBarView.selectionIndicatorStrokeColor = UIColor.main
        tabBarView.addObserver(self, forKeyPath: "contentSize", context: nil)
        tabBarView.tabBarDelegate = self
        tabBarContainer.addSubview(tabBarView)
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.topAnchor.constraint(equalTo: tabBarContainer.topAnchor).isActive = true
        tabBarView.leadingAnchor.constraint(equalTo: tabBarContainer.leadingAnchor).isActive = true
        tabBarView.trailingAnchor.constraint(equalTo: tabBarContainer.trailingAnchor).isActive = true
        tabBarView.bottomAnchor.constraint(equalTo: tabBarContainer.bottomAnchor).isActive = true
        tabBarContainer.layoutIfNeeded()
    }
    
    private func configTableView() {
        let tableFooterView = UIView()
        tableView.tableFooterView = tableFooterView
        tableFooterView.translatesAutoresizingMaskIntoConstraints = false
        tableFooterView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        tableFooterView.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        tableFooterView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        tableFooterView.heightAnchor.constraint(equalToConstant: Utils.scaleWithHeight(120)).isActive = true
        tableView.tableFooterView?.layoutIfNeeded()
        tableView.addObserver(self, forKeyPath: "contentOffset", context: nil)
        tableView.separatorStyle = .none
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
}

extension InfoMenuViewController {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        cacheContentOffset = nil
    }
}

// MARK: NAVIGATION
extension InfoMenuViewController: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return String.TitleScreen.infoMenu
    }
    
    func navigationBar() -> Bool {
        return true
    }
}

// MARK: TabBarView
extension InfoMenuViewController: MDCTabBarViewDelegate {
    func tabBarView(_ tabBarView: MDCTabBarView, didSelect item: UITabBarItem) {
        let headerSectionView = tableView.headerView(forSection: item.tag)
        let yOffset = headerSectionView?.convert(headerSectionView?.bounds ?? CGRect.zero, to: tableView).origin.y ?? 0
        let isBottomTable = tableView.frame.size.height + tableView.contentOffset.y >= floor( tableView.contentSize.height) && tableView.frame.size.height + yOffset >= floor(tableView.contentSize.height)
        cacheContentOffset = isBottomTable ? nil : tableView.contentOffset
        cacheIndexPositionSection = item.tag
        let indexPath = IndexPath(row: NSNotFound, section: item.tag)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func tabBarView(_ tabBarView: MDCTabBarView, shouldSelect item: UITabBarItem) -> Bool {
        return cacheIndexPositionSection != item.tag
    }
}

// MARK: TableViewDelegate
extension InfoMenuViewController: UITableViewDelegate {
    
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
        header?.contentView.backgroundColor = UIColor.americanSilver
        header?.contentView.tintColor = UIColor.americanSilver
        return header
    }
}

// MARK: TableViewDatasource
extension InfoMenuViewController: UITableViewDataSource {
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
}
