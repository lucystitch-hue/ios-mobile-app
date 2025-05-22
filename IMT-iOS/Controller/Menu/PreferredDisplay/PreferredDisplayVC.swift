//
//  PreferredDisplayViewController.swift
//  IMT-iOS
//
//  Created on 24/01/2024.
//
    

import UIKit

class PreferredDisplayVC: BaseViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cstHeightTable: NSLayoutConstraint!
    
    private var viewModel: PreferredDisplayViewModel!
    
    public var onDismiss: JVoid?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let tableView = object as? UITableView else { return }
        if(tableView == tableView) {
            self.cstHeightTable.constant = tableView.contentSize.height
        }
    }
    
    @IBAction func actionConfirm(_ sender: Any) {
        viewModel.confirm(self)
    }
}

// MARK: PRIVATE
extension PreferredDisplayVC {
    private func setupUI() {
        setupNavigation()
        configTable()
    }
    
    private func setupData() {
        viewModel = PreferredDisplayViewModel()
        
        viewModel.items.bind { [weak self] results in
            self?.tableView.reloadData()
        }
    }
    
    private func configTable() {
        tableView.register(identifier: IMTRadioButtonCell.identifier)
        tableView.addObserver(self, forKeyPath: "contentSize", context: nil)
    }
}

// MARK: NAVIGATION
extension PreferredDisplayVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return String.TitleScreen.preferredDisplay
    }
    
    func navigationBar() -> Bool {
        return true
    }
}

// MARK: TABLEVIEW
extension PreferredDisplayVC: UITableViewDelegate, UITableViewDataSource {
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
}
