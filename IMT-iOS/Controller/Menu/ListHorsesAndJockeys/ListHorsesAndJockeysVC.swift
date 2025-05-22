//
//  ListHorsesAndJockeysVC.swift
//  IMT-iOS
//
//  Created on 14/03/2024.
//


import UIKit

class ListHorsesAndJockeysVC: BaseViewController {
    
    @IBOutlet private weak var segmentControlView: UIView!
    @IBOutlet private weak var vFavoriteHorseRankingButton: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cstHeightTableView: NSLayoutConstraint!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbSize: UILabel!
    @IBOutlet private weak var btnTop: IMTButton!
    @IBOutlet private weak var deleteMultipleViewContainer: UIView!
    
    var onGotoSearch: ((ListHorsesAndJockeysSegment) -> Void)?
    var onGotoWebView: ((String) -> Void)?
    var onGotoRaceHorseRanking: JVoid?
    
    private lazy var segmentControl: SegmentControl = {
        let segmentControl = SegmentControl.instantiateView()
        segmentControlView.addSameSizeConstaints(subView: segmentControl)
        return segmentControl
    }()
    
    private lazy var deleteMultipleView: DeleteMultipleView = {
        let deleteMultipleView = DeleteMultipleView.instantiateView()
        deleteMultipleViewContainer.addSameSizeConstaints(subView: deleteMultipleView)
        return deleteMultipleView
    }()
    
    var viewModel: ListHorsesAndJockeysViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSegmentControl()
        setupTableView()
        setupDeleteMultipleView()
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
            self.cstHeightTableView.constant = tableView.contentSize.height - 1
        }
    }
    
    override func allowToBack() -> Bool {
        let shouldShowCheckBox = viewModel.shouldShowCheckBox
        if (shouldShowCheckBox) {
            viewModel.objectsSelected.removeAll()
            deleteMultipleView.expaned.value = false
        }
        return !shouldShowCheckBox
    }
    
    private func bind() {
        viewModel.isLoading.bind { [weak self] value in
            guard let self = self, let value = value else { return }
            
            if (value) {
                deleteMultipleView.expaned.value = false
                vFavoriteHorseRankingButton.isHidden = viewModel.shouldHideRanking
                lbTitle.text = viewModel.selectedSegment.title()
                deleteMultipleView.cancelTitle = viewModel.selectedSegment.cancelTitle()
                Utils.showProgress()
            } else {
                Utils.hideProgress()
                viewModel.objectsSelected.removeAll()
                tableView.reloadData()
                lbSize.text = "\(viewModel.itemsCount)/\(viewModel.maximum)"
                btnTop.isUserInteractionEnabled = viewModel.shouldActiveRanking
                btnTop.backgroundColor = viewModel.shouldActiveRanking ? .lapisLazuli : .americanSilver
            }
        }
        
        viewModel.reloadData.bind { [weak self] value in
            guard let self = self, let _ = value else { return }
            tableView.reloadData()
        }
        
        viewModel.shouldShowWarningPopup.bind(self, performInitialUpdate: false) { [weak self] name in
            guard let self = self, let name = name else { return }
            self.showWarningReleased(with: viewModel.selectedSegment, name: name)
        }
        
        viewModel.onShowRemoveAllPreferenceComplete = { [weak self] numberOfItem, selectedSegment in
            self?.showWarningDidRemoveAllPreferenceComplete(numberOfItem, selectedSegment)
        }
        
        viewModel.emitPushWebview = { [weak self] url in
            self?.onGotoWebView?(url)
        }
        
        viewModel.selectedItemsObservable.bind(self) { value in
            self.deleteMultipleView.bind()
        }
    }
    
    private func setupSegmentControl() {
        segmentControl.delegate = self
        segmentControl.removeAllSegments()
        let buttons = viewModel.availableSegment.mapIndex { UIButton(title: $1.text(), tag: $0) }
        segmentControl.items = buttons
        segmentControl.selectedSegmentIndex = viewModel.selectedSegment.rawValue
    }
    
    private func setupTableView() {
        tableView.addObserver(self, forKeyPath: "contentSize", context: nil)
        tableView.register(UINib(nibName: HorseAndJockeyCell.nameOfClass, bundle: nil), forCellReuseIdentifier: HorseAndJockeyCell.nameOfClass)
    }
    
    private func setupDeleteMultipleView() {
        deleteMultipleView.delegate = self
        deleteMultipleView.expaned.bind(self, performInitialUpdate: false, clearPreviousBinds: false) { [weak self] value in
            self?.viewModel.shouldShowCheckBox = value
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func actionGoToSearch(_ sender: Any) {
        onGotoSearch?(viewModel.selectedSegment)
    }
    
    @IBAction func actionGotoRaceHorseRanking(_ sender: Any) {
        onGotoRaceHorseRanking?()
    }
}

extension ListHorsesAndJockeysVC: SegmentControlDelegate {
    func segmentControl(_ segmentControl: SegmentControl, didSelect item: UIButton) {
        if let segment = ListHorsesAndJockeysSegment(rawValue: item.tag) {
            viewModel.selectedSegment = segment
        }
    }
    
    func segmentControl(_ segmentControl: SegmentControl, shouldSelect item: UIButton) -> Bool {
        return true
    }
}

extension ListHorsesAndJockeysVC: DeleteMultipleViewDelegate {
    
    func numberOfItems(view: DeleteMultipleView) -> Int {
        return viewModel.itemsCount
    }
    
    func numberOfItemsSelected(view: DeleteMultipleView) -> Int {
        return viewModel.selectedCount
    }
    
    func selectAll(view: DeleteMultipleView) {
        viewModel.selectedAll()
    }
    
    func removeAll(view: DeleteMultipleView) {
        viewModel.removeAll()
    }
    
    func cancel(view: DeleteMultipleView) {
        showWarningCancelMultiple(with: viewModel.selectedSegment, numberOfItems: viewModel.selectedCount) { [weak self] action, _ in
            if action == .ok {
                self?.viewModel.cancelMultiple()
            }
        }
    }
}

extension ListHorsesAndJockeysVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = viewModel.tableViewCell(for: tableView, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !viewModel.shouldShowCheckBox
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Cancel") { action, view, completion in
            guard let name = self.viewModel.getName(indexPath.row) else { return }
            self.showWarningCancel(with: self.viewModel.selectedSegment, name: name) { [weak self] action, _ in
                guard let self = self else { return }
                if action == .ok {
                    self.viewModel.cancel(indexPath.row)
                }
            }
            completion(true)
        }
        let config = UISwipeActionsConfiguration(actions: [actionDelete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didChoice(for: tableView, indexPath: indexPath)
    }
}
