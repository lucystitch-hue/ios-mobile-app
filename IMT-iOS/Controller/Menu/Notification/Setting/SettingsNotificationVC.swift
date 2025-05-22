//
//  SettingsNotificationVC.swift
//  IMT-iOS
//
//  Created by dev on 24/03/2023.
//

import UIKit

class SettingsNotificationVC: BaseViewController {
    
    @IBOutlet weak var tbvNotification: UITableView!
    
    public var onSuccess: JVoid?
    private var viewModel: SettingsNotificationViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func gotoBack() {
        viewModel.back(self)
    }
    
    func reloadTableData() {
        self.tbvNotification.reloadData()
        setupData()
    }
}

extension SettingsNotificationVC {
    private func setupUI() {
        configTable()
        setupNavigation()
    }
    
    private func setupData() {
        viewModel = SettingsNotificationViewModel()
        
        viewModel.onUpdateSuccessfully = { [weak self] in
            self?.onSuccess?()
        }
        
        viewModel.sections.bind { [weak self] result in
            self?.tbvNotification.reloadData()
        }
        
    }
    
    private func configTable() {
        self.tbvNotification.dataSource = self;
        self.tbvNotification.delegate = self;
        self.tbvNotification.register(identifier: NotificationSettingsCell.identifier)
        self.tbvNotification.allowsSelection = false
    }
}

extension SettingsNotificationVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numCell(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.getCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.getHeader(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.getHeightHeader(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.getFootter(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.getHeightHeader(tableView, section: section)
    }
}

extension SettingsNotificationVC: IMTNavigationController {
    
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.notification
    }
    
    func getTitleSubNavigation() -> String {
        return .TitleScreen.notificationSub
        
    }
    
    func navigationBar() -> Bool {
        return true
    }
}
