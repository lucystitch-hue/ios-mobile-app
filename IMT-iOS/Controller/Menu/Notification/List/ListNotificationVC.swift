//
//  ListNotificationVC.swift
//  IMT-iOS
//
//  Created by dev on 24/03/2023.
//

import UIKit
import SwiftyJSON

class ListNotificationVC: BaseViewController {
    
    @IBOutlet weak var tbvNotification: UITableView!
    
    public var onDismiss: JVoid?
    public var onGotoDetail: (([NotificationBundleKey: Any]) -> Void)?
    private var viewModel: ListNotificationViewModelProtocol!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        viewModel = ListNotificationViewModel()
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
        viewModel.isCurrentScreen = true
        viewModel.callAPI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.removeObserver()
    }
    
    //MARK: Action
    @IBAction func actionAllSeen(_ sender: Any) {
        viewModel.getReadNotification()
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.onDismiss?()
        super.dismiss(animated: flag, completion: completion)
    }
    
    //MARK: Public
    public func show(_ messageCode: String) {
        var notification = NotificationModel(json: JSON())
        notification.messageCode = messageCode
        viewModel.gotoDetailNotification(self, bundle: [.detail: notification])
    }
}

//MARK: Private
extension ListNotificationVC {
    private func setupUI() {
        configTable()
    }
    
    private func setupData() {
        viewModel.notifications.bind { [weak self] results in
            self?.tbvNotification.reloadData()
        }
        
        viewModel.onReadNotificationSuccessfully = { [weak self] in
            self?.viewModel.markAllSeen((self?.tbvNotification)!)
        }
    }
    
    private func configTable() {
        viewModel.register(table: tbvNotification, delegate: self)
    }
}

extension ListNotificationVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.getCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didChoice(controller: self, tableView: tableView, section: indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.footerView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.heightFooter()
    }
}

