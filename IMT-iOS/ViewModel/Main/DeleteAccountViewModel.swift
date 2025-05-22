//
//  DeleteAccountViewModel.swift
//  IMT-iOS
//
//  Created by dev on 10/04/2023.
//

import Foundation
import UIKit

protocol DeleteAcountViewModelProtocol {
    var hideKeyboard: ObservableObject<Bool> { get set }
    
    func close(_ controller: DeleteAccountVC)
    func gotoPopup(_ controller: DeleteAccountVC?)
    
    func numSection(_ tableView: UITableView) -> Int
    func numCell(_ tableView: UITableView, section: Int) -> Int
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func getHeader(_ tableView: UITableView, section: Int) -> UIView
    func getFootter(_ tableView: UITableView, section: Int) -> UIView?
    func getHeightFootter(_ tableView: UITableView, section: Int) -> CGFloat
    func didChoice(_ tableView: UITableView, indexPath: IndexPath)
    
    func allowInput(_ textField: UITextView, range: NSRange, string: String) -> Bool
}

class DeleteAccountViewModel: BaseViewModel {
    var hideKeyboard: ObservableObject<Bool> = ObservableObject<Bool>(true)
    var data: [ReasonDeleteApp] = ReasonDeleteApp.allCases
    var detail: [ReasonDeleteApp: [IReasonDelete]] = [
        .q1: ReasonDeleteApp.q1.detail()
    ]
    
    private var strReason: String = ""
}

extension DeleteAccountViewModel: DeleteAcountViewModelProtocol {
    
    func close(_ controller: DeleteAccountVC) {
        controller.dismiss(animated: true)
    }
    
    func tap(_ controller: DeleteAccountVC) {
        if(hideKeyboard.value == true) {
            controller.dismiss(animated: true)
        } else {
            controller.view.endEditing(true)
        }
    }
    
    func numSection(_ tableView: UITableView) -> Int {
        return data.count
    }
    
    func numCell(_ tableView: UITableView, section: Int) -> Int {
        let reason = data[section]
        let detail = reason.detail()
        return detail.count
    }
    
    func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IMTCheckboxCell.identifier) as? IMTCheckboxCell else { return UITableViewCell() }
        let reason = data[indexPath.section]
        let iDetail = detail[reason]?[indexPath.row]
        cell.setup(item: iDetail, indexAt: indexPath)
        
        cell.onChecked = { [weak self] indexPath in
            self?.didChoice(tableView, indexPath: indexPath)
        }
        
        return cell
    }
    
    func getHeader(_ tableView: UITableView, section: Int) -> UIView {
        let reason = ReasonDeleteApp.allCases[section]
        let vHeader = HeaderTitle(index: reason.rawValue, title: reason.title())
        vHeader.alignment = .top
        return vHeader
    }
    
    func getFootter(_ tableView: UITableView, section: Int) -> UIView? {
        let reason = data[section]
        if reason.feedback() {
            let vFootter = FooterTextView(text: self.strReason)
            vFootter.characterLimitEnabled = true
            vFootter.onTextChange = { [weak self] text in
                self?.strReason = text
            }
            return vFootter
        } else {
            return nil
        }
    }
    
    func getHeightFootter(_ tableView: UITableView, section: Int) -> CGFloat {
        let reason = data[section]
        if reason.feedback() {
            return 220
        } else {
            return 0
        }
    }

    func didChoice(_ tableView: UITableView, indexPath: IndexPath) {
        if(hideKeyboard.value == true) {
            let reason = data[indexPath.section]
            let iDetail = detail[reason]?[indexPath.row]
            
            iDetail?.checked = !iDetail!.checked
            tableView.reloadData()
        } else {
            tableView.endEditing(true)
        }
    }
    
    func gotoPopup(_ controller: DeleteAccountVC?) {
        guard let controller = controller else { return }
        let vc = PopupDeleteAccountVC()
        vc.onDismiss =  {
            controller.onDismiss?()
        }
        
        controller.presentOverFullScreen(vc)
    }
    
    func allowInput(_ textField: UITextView, range: NSRange, string: String) -> Bool {
        let currentString: NSString = textField.text as NSString? ?? ""
        let newString = currentString.replacingCharacters(in: range, with: string)
        let tag = textField.tag
        strReason = newString
        
        return true
    }
    
}

//MARK: API
extension DeleteAccountViewModel {
    //TODO: Call
    
    //TODO: Response
    func responseDeleteUser(_ response: ResponseDeleteUser?, success: Bool) {
        guard let response = response else { return }
        
        if(response.success) {
            UserManager.share().resetShowTerm()
            Utils.postLogout()
        } else {
            guard let message = response.message else { return }
            showMessageError(message: message)
        }
    }
}
