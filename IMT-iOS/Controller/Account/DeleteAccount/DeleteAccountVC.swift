//
//  DeleteAccountVC.swift
//  IMT-iOS
//
//  Created by dev on 10/04/2023.
//

import UIKit

class DeleteAccountVC: BaseViewController {
    
    @IBOutlet weak var tbvReason: UITableView!
    @IBOutlet weak var scvContainer: UIScrollView!
    @IBOutlet weak var cstHeightTbvReason: NSLayoutConstraint!
    @IBOutlet weak var btnDelete: IMTButton!
    
    private var viewModel: DeleteAcountViewModelProtocol!
    public var onDismiss: JVoid?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.removeObserver()
        super.viewDidDisappear(animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let tableView = object as? UITableView else { return }
        if(tableView == tbvReason) {
            self.cstHeightTbvReason.constant = tableView.contentSize.height
        }
    }
    
    override func gotoBack() {
        self.dismiss(animated: true)
    }
    
    //MARK: Action
    @IBAction func actionDeleteAccount(_ sender: Any) {
        viewModel.gotoPopup(self)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        onDismiss?()
        
    }
}

//MARK: Private
extension DeleteAccountVC {
    private func setupUI() {
        configTable()
        configScroll()
    }
    
    private func setupData() {
        self.addObserver()
        viewModel = DeleteAccountViewModel()
    }
    
    private func setupEvent() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        self.tbvReason.removeObserver(self, forKeyPath: "contentSize")
    }

    
    @objc private func hideKeyboard() {
        viewModel.hideKeyboard.updateNoBind(true)
    }
    
    @objc private func showKeyboard() {
        viewModel.hideKeyboard.updateNoBind(false)
    }
    
    @objc private func tap() {
        self.view.endEditing(true)
    }
    
    private func configTable() {
        self.tbvReason.dataSource = self
        self.tbvReason.delegate = self
        
        self.tbvReason.register(identifier: "IMTCheckboxCell")
        self.tbvReason.addObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
    private func configScroll() {
        self.scvContainer.delegate = self
    }
}

extension DeleteAccountVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numSection(tableView) ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numCell(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel!.getCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.getHeader(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return viewModel.getFootter(tableView, section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.getHeightFootter(tableView, section: section)
    }
}

extension DeleteAccountVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        btnDelete.isUserInteractionEnabled = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        btnDelete.isUserInteractionEnabled  =  true
    }
}
