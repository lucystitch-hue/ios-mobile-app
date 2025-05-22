//
//  ListFavoriteSearchResultVC.swift
//  IMT-iOS
//
//  Created on 14/03/2024.
//


import UIKit

class ListFavoriteSearchResultVC: BaseViewController {
    
    @IBOutlet weak var lblTitle: IMTLabel!
    @IBOutlet weak var tbvSearch: UITableView!
    @IBOutlet weak var cstHeightTableSearch: NSLayoutConstraint!
    @IBOutlet weak var vNoteFavorite: UIView!
    @IBOutlet weak var vErrorSpace: UIView!
    @IBOutlet weak var lblMoreThanError: IMTLabel!
    @IBOutlet weak var lblMaximumAddError: IMTLabel!
    @IBOutlet weak var lblItem: IMTLabel!
    
    var onGotoWebView: ((String) -> Void)?
    var onGotoListHorseAndJockey: ((ListHorsesAndJockeysSegment) -> Void)?
    
    private var viewModel: (any ListPreferenceSearchResultProtocol)!
    private var type: ListFavoriteSearchResultType = .favorite
    private var searchValue: String!
    private var items: [PreferenceFeature] = []
    
    //MARK: Structure
    init(type: ListFavoriteSearchResultType,
         items: [PreferenceFeature] = [],
         searchValue: String) {
        super.init(nibName: "ListFavoriteSearchResultVC", bundle: nil)
        self.type = type
        self.searchValue = searchValue
        self.items = items
        self.viewModel = getViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.fetch()
    }
    
    //MARK: Action
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableView = object as? UITableView,
           tableView == tbvSearch {
            cstHeightTableSearch.constant = tbvSearch.contentSize.height
        }
    }
    
}

//MARK: Private
extension ListFavoriteSearchResultVC {
    private func setupUI() {
        updateTitle()
        configNoteView()
        configTable()
    }
    
    private func setupData() {
        self.viewModel.emitPushListHorseAndJockey = { [weak self] segment in
            self?.onGotoListHorseAndJockey?(segment)
        }
        
        self.viewModel.emitPushWebview = { [weak self] link in
            self?.onGotoWebView?(link)
        }
        
        self.viewModel.emitShowPopup = { [weak self] (type, index, name) in
            self?.viewModel.showPopup(controller: self, info: (type, index, name))
        }
        
        self.viewModel.emitReloadData = { [weak self] in
            self?.updateTitle()
            self?.tbvSearch.reloadData()
        }
        
        self.viewModel.onMoreThanError.bind { [weak self] result in
            self?.lblMoreThanError.isHidden = true
            if let result = result {
                self?.lblMoreThanError.isHidden = !(result == .moreThan50OfItem)
            }
        }
        
        self.viewModel.onMaximumAddError.bind { [weak self] result in
            self?.lblMaximumAddError.isHidden = true
            if let result = result {
                self?.lblMaximumAddError.isHidden = false
                self?.lblMaximumAddError.text = result.message()
            }
        }
        
        viewModel.setItems(items)
    }
    
    private func configNoteView() {
        lblItem.text = type.itemLabel()
    }
    
    private func updateTitle() {
        let numberOfItem = self.items.count
        lblTitle.text = type.title(searchValue, numberOfItem)
    }
    
    private func configTable() {
        viewModel.registerCell(tbvSearch)
        tbvSearch.addObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
    private func getViewModel() -> any ListPreferenceSearchResultProtocol {
        switch self.type {
        case .favorite:
            return ListFavoriteSearchResultViewModel()
        case .recommended:
            return ListRecommendSearchResultViewModel()
        }
    }
}

//MARK: UITableViewDatasource, UITableViewDelegate
extension ListFavoriteSearchResultVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numCell(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.getCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.getFootter(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.getHeightFootter(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didChoice(tableView, indexPath: indexPath)
    }
}
