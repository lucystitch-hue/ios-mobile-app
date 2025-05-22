//
//  ListMemorialVC.swift
//  IMT-iOS
//
//  Created by dev on 13/03/2023.
//

import UIKit

class ListMemorialVC: BaseViewController {
    
    @IBOutlet private weak var vMaskYear: IMTView!
    @IBOutlet private weak var vMaskReward: IMTView!
    @IBOutlet private weak var tbvMemorial: UITableView!
    @IBOutlet private weak var lblYear: UILabel!
    @IBOutlet private weak var lblReward: UILabel!
    @IBOutlet private weak var lblPage: UILabel!
    @IBOutlet private weak var vSpaceGroup: UIView!
    @IBOutlet private weak var vAllowMultipleDeleteGroup: UIView!
    @IBOutlet private weak var vAcceptMultipleDeleteGroup: UIView!
    @IBOutlet private weak var lblAllowDeleteMultiple: IMTLabel!
    @IBOutlet private weak var lblAcceptDeleteMultiple: IMTLabel!
    @IBOutlet private weak var imgAcceptDeleteMultiple: UIImageView!
    
    public var onGotoPreviewTicket: ((_ listQRModel: [IListQRModel],_ index: Int) -> Void)?
    private let ddYear = DropDown()
    private let ddReward = DropDown()
    private var viewModel: ListMemorialViewModelProtocol!
    public var valueModel: HitBettingTicketArchiveModel!
    private var bundle: [HomeBundleKey: Any]?
    
    init(bundle: [HomeBundleKey: Any]?) {
        super.init(nibName: nil, bundle: nil)
        self.bundle = bundle
        
    }
    
    //MARK: Constructor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshData()
        viewModel.callAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func allowToBack() -> Bool {
        let isMutipleMode = viewModel.deleteMode.value == .multiple
        if (isMutipleMode) {
            viewModel.resetDetectMode(self)
        }
        return !isMutipleMode
    }
    
    //MARK: Action
    @IBAction func actionShowDropDownYear(_ sender: UIButton) {
        actionDropdown(ddYear, label: lblYear, sender: sender) { index in
            self.viewModel.indexYear.value = index
        }
    }
    
    @IBAction func actionShowDropDownReward(_ sender: UIButton) {
        actionDropdown(ddReward, label: lblReward, sender: sender) { [weak self] index in
            self?.viewModel.indexGrade.value = index
        }
    }
    
    @IBAction func actionAllowMultipleDelete(_ sender: Any) {
        viewModel.actionAllowDeleteMultiple(self)
    }
    
    @IBAction func actionAcceptMultipleDelete(_ sender: Any) {
        viewModel.actionAcceptDeleteMultiple(self)
    }
}

//MARK: Public
extension ListMemorialVC {
    public func reloadData() {
        self.tbvMemorial.reloadData()
    }
    
    public func reloadAt( _ row: Int) {
//        let indexPath = IndexPath(row: row, section: 0)
//        if(row != viewModel.getNumberSections(tbvMemorial) - 1) {
//            self.tbvMemorial.reloadRows(at: [indexPath], with: .none)
//        } else {
//            self.tbvMemorial.reloadData()
//        }
    }
}

//MARK: Private
extension ListMemorialVC {
    private func setupUI() {
        configCombobox()
        configTable()
        configLabel()
    }
    
    private func setupData() {
        viewModel = ListMemorialViewModel(bundle: bundle)
        
        viewModel.years.bind { [weak self] results in
            guard let results = results else { return }
            self?.ddYear.dataSource = results
            guard let indexYear = self?.viewModel.indexYear.value, results.count != 0 else { return }
            self?.lblYear.text = results.safeObjectForIndex(index: indexYear) ?? "All"
        }
        
        viewModel.grades.bind { [weak self] results in
            guard let results = results else { return }
            self?.ddReward.dataSource = results.map({ return $0.rawValue })
            guard let indexGrade = self?.viewModel.indexGrade.value, results.count != 0 else { return }
            self?.lblReward.text = results.safeObjectForIndex(index: indexGrade)?.rawValue ?? GradeName.all.rawValue
        }
        
        viewModel.hitBettingTicketArchives.bind { [weak self] results in
            let numberPage = results?.count ?? 0
            let total = self?.viewModel.getAllNumber() ?? 0
            self?.lblPage.text = "\(numberPage)/\(total)"
            self?.tbvMemorial.reloadData()
        }
        
        viewModel.items.bind { [weak self] results in
            let numberPage = results?.count ?? 0
            let total = self?.viewModel.getAllNumber() ?? 0
            self?.lblPage.text = "\(numberPage)/\(total)"
            self?.tbvMemorial.reloadData()
        }
        
        viewModel.onUpdateYearTitle = { [weak self] result in
            self?.lblYear.text = result
        }
        
        viewModel.onUpdateGradeTitle = { [weak self] result in
            self?.lblReward.text = result
        }
        
        viewModel.deleteMode.bind { mode in
            self.lblAllowDeleteMultiple.text = mode?.title()
            
            switch mode {
            case .single:
                self.vSpaceGroup.isHidden = false
                self.vAcceptMultipleDeleteGroup.isHidden = true
                return
            case .multiple:
                self.vSpaceGroup.isHidden = true
                self.vAcceptMultipleDeleteGroup.isHidden = false
                return
            case .none:
                return
            }
        }
        
        viewModel.onUpdateButtonDelete = { [weak self] in
            guard let self = self, viewModel.deleteMode.value == .multiple else { return }
            let isSelectedAll = viewModel.itemsCount > 0 && viewModel.itemsCount <= viewModel.selectedItemsCount
            let isSelectedItemsEmpty = viewModel.rawSelectedItemsCount == 0
            lblAllowDeleteMultiple.text = isSelectedAll ? "Deselect All" : "Select All"
            lblAcceptDeleteMultiple.text = isSelectedItemsEmpty ? "Return to List" : "Delete Selected Ticket Images"

            imgAcceptDeleteMultiple.isHidden = isSelectedItemsEmpty
        }
    }
    
    private func configCombobox() {
        vMaskYear.setShadow()
        vMaskReward.setShadow()
    }
    
    private func configLabel() {
        if(UIScreen.main.bounds.height < Constants.hScreenSE3) {
            lblAcceptDeleteMultiple.textAlignment = .center
        }
    }
    
    private func configTable() {
        self.tbvMemorial.rowHeight = UITableView.automaticDimension;
        self.tbvMemorial.estimatedRowHeight = 44.0;
        tbvMemorial.register(identifier: IMemorialCell.identifier)
        tbvMemorial.register(identifier: IMemorialNoRadioCell.identifier)
    }
    
    private func actionDropdown(_ dropdown: DropDown,
                                label: UILabel,
                                sender: UIButton,
                                action selectionAction: @escaping((_ index: Int) -> Void)) {
        dropdown.anchorView = sender
        dropdown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height) //6
        dropdown.show()
        dropdown.customCellConfiguration = {(index, string, cell) in
            if label == self.lblYear {
                cell.optionLabel.text = index == 0 ? string : "\(string)年"
            }
        }
        dropdown.selectionAction = {(index, value) in
            label.text = value
            selectionAction(index)
        }
    }
}

extension ListMemorialVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberSections(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.getCell(self, tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.getViewFooterInSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.getHeightFooter(tableView, section: section)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        viewModel.choice(self, tableView: tableView, index: indexPath.section)
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return viewModel.deleteMode.value?.swipeToDelete() ?? false
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: viewModel.deleteMode.value?.titleSwipeToDelete() ?? "") { action, view, completion in
            self.viewModel.remove(controller: self, tableView: tableView, atIndex: indexPath.section)
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [actionDelete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
