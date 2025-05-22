//
//  ServiceView.swift
//  IMT-iOS
//
//  Created by dev on 10/03/2023.
//

import UIKit

protocol ServiceViewDelegate {
    func serviceView(_ serviceView: ServiceView, heightChange: Float)
    func serviceView(_ serviceView: ServiceView, didSelectAt service: Service)
    func serviceView(_ serviceView: ServiceView, didChoiceServiceOrderTicketFromQRCode isQRCode: Bool)
}

class ServiceView: UIView {

    @IBOutlet var vContent: UIView!
    @IBOutlet weak var tbvService: UITableView!
    @IBOutlet weak var cstTopTableView: NSLayoutConstraint!
    
    var topContent: Float = 0 {
        didSet {
            self.cstTopTableView.constant = CGFloat(topContent)
        }
    }
    
    private var delegate: ServiceViewDelegate?
    private var viewModel: ServiceViewModelProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    //MARK: Public
    func setup(services: [Service], asDelegate delegate: ServiceViewDelegate) {
        self.delegate = delegate
        viewModel = ServiceViewModel(services: services, asDelegate: self)
        
        viewModel?.services.bind { [weak self] results in
            self?.tbvService.reloadData()
        }
        
        viewModel?.onChoiceServiceOrderTicket = { [weak self] isQRCode in
            guard let weakSelf = self else { return }
            weakSelf.delegate?.serviceView(weakSelf, didChoiceServiceOrderTicketFromQRCode: isQRCode)
        }
        
        tbvService.addObserver(self, forKeyPath: "contentSize",context: nil)
    }
    
    //MARK: Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let tableView = object as? UITableView else { return }
        if(tableView == tbvService) {
            updateHeightView()
        }
    }
}

//MARK: Private
extension ServiceView {
    
    private func commonInit() {
        configContent()
        configTable()
        updateHeightView()
    }
    
    private func configContent() {
        Bundle.main.loadNibNamed("ServiceView", owner: self, options: nil)
        self.addSubview(vContent)
        Utils.constraintFull(parent: self, child: vContent)
        self.vContent.backgroundColor = self.backgroundColor
    }
    
    private func configTable() {
        
        self.tbvService.dataSource = self
        self.tbvService.delegate = self
        
        self.tbvService.register(identifier: ServiceOrderTicketCell.identifier)
        self.tbvService.register(identifier: ServiceImageCell.identifier)
    }
    
    private func updateHeightView() {
        let heightContent: Float = Float(tbvService.contentSize.height)
        let spaceVerticle = topContent * 2
        let hSummary = spaceVerticle + heightContent
        
        self.delegate?.serviceView(self, heightChange: hSummary)
    }
}

extension ServiceView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numSection(tableView: tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel?.getCell(tableView: tableView, atIndexPath: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel?.getHeightCell(tableView: tableView, atIndexPath: indexPath) ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel?.getFooterView(tableView: tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel?.getHeightFooter(tableView: tableView, section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let service = viewModel?.services.value?[indexPath.section] else { return }
        self.delegate?.serviceView(self, didSelectAt: service)
    }
}

extension ServiceView: ServiceOrderRoomCellDelegate {
    func didManageAccount(cell: ServiceOrderRoomCell, atIndex: Int) {
        
    }
    
    func didShowAnswer(cell: ServiceOrderRoomCell, atIndex: Int) {
        
    }
}
