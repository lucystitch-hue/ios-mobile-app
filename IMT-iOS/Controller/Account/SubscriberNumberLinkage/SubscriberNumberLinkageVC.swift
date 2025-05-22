//
//  SubscriberNumberLinkageVC.swift
//  IMT-iOS
//
//  Created by dev on 09/03/2023.
//

import UIKit

class SubscriberNumberLinkageVC: BaseDataController<SubscriberNumberLinkageViewModel> {
    
    @IBOutlet weak var vPriority: UIView!
    @IBOutlet weak var vNoPriority: UIView!
    @IBOutlet weak var btnPrioritize: UIButton!
    @IBOutlet weak var btnNoPriority: UIButton!
    @IBOutlet weak var btnDisconnect: IMTButton!
    @IBOutlet weak var tbvPriority: UITableView!
    
    var tableViewWidth:CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    override func setupUI(){
        setupNavigation()
        configTable()
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
    override func setupData() {
        viewModel = SubscriberNumberLinkageViewModel()
        viewModel.listSubNumerLinks.bind {[weak self] results in
            self?.tbvPriority.reloadData()
        }
    }
}

extension SubscriberNumberLinkageVC {
    
    private func configTable() {
        
        self.tbvPriority.dataSource = self;
        self.tbvPriority.delegate = self;
        tbvPriority.register(identifier: SubNumerLinksCell.identifier)
        self.tableViewWidth = tbvPriority.frame.size.width
        
    }

}

extension SubscriberNumberLinkageVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return .TitleScreen.subcriberNumber
    }
}

extension SubscriberNumberLinkageVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.listSubNumerLinks.value?.count ?? 0
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
        return viewModel.getViewFooterInSection(tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.getHeightFooter(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.gotoChangeTheOnlineVotingInformation(self)
    }
    
}

