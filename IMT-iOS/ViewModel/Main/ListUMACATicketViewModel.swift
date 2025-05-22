//
//  ListUMACATicketViewModel.swift
//  IMT-iOS
//
//  Created by dev on 05/10/2023.
//

import Foundation

import Foundation
import UIKit

protocol ListUMACATicketViewModelProtocol {
    var umacaTicket: ObservableObject<(cardNumber: String?, birthday: String?, pinCode: String?, umacaFlg: String?, isIntial: Bool)> { get set }
    var needGetData: Bool { get set }
    
    func registerUMACATicket(_ controller: ListUMACATicketVC?)
    func updateUMACATicket(_ controller: ListUMACATicketVC?)
    func configButtonActive(button: UIButton?, background view: UIView?, isActive: Bool, lbCardNumber: UILabel?)
    func connect()
    func disconnect()
    func getData()
    func back(_ controller: ListUMACATicketVC?)
}

class ListUMACATicketViewModel: BaseViewModel {
    
    private struct Constants {
        static let enableUmacaFlg: String = "1"
        static let disableUmacaFlg: String = "0"
    }
    
    var umacaTicket: ObservableObject<(cardNumber: String?, birthday: String?, pinCode: String?, umacaFlg: String?, isIntial: Bool)> = ObservableObject<(cardNumber: String?, birthday: String?, pinCode: String?, umacaFlg: String?, isIntial: Bool)>((nil, nil, nil, nil, true))
    var needGetData: Bool = false
    
    override init() {
        super.init()
        self.getData()
    }
}

extension ListUMACATicketViewModel: ListUMACATicketViewModelProtocol  {
    func updateUMACATicket(_ controller: ListUMACATicketVC?) {
        guard let controller = controller else { return }
        let vc = UMACATicketVC()
        controller.push(vc)
    }
    
    func registerUMACATicket(_ controller: ListUMACATicketVC?) {
        guard let controller = controller else { return }
        let vc = UMACATicketVC(original: false, isEdit: false)
        controller.push(vc)
    }
    
    func connect() {
        guard let userId = Utils.getUserDefault(key: .userId), let umacaTickets = Utils.getDictUserDefault(key: .umacaTickets), let umaca = umacaTickets[userId] as? [String: String], umaca["umacaFlg"] != "1" else { return }
        Utils.showProgress(false)
        
        Utils.mainAsyncAfter { [weak self] in
            guard let self = self else { return }
            self.manager.call(endpoint: .updateUmacaFlag(Constants.enableUmacaFlg), completion: self.responseUpdateUMACA)
        }
    }
    
    func disconnect() {
        Utils.showProgress(false)
        
        Utils.mainAsyncAfter { [weak self] in
            guard let self = self else { return }
            self.manager.call(endpoint: .updateUmacaFlag(Constants.disableUmacaFlg), completion: self.responseUpdateUMACA)
        }
    }

    func configButtonActive(button: UIButton?, background view: UIView?, isActive: Bool, lbCardNumber: UILabel?) {
        guard let button = button else { return }
        guard let view = view else { return }
        
        let colorViewBackground: UIColor = isActive ? .main: .cultured
        let colorBackground: UIColor = isActive ? .clear: .main
        let colorBorder: UIColor = isActive ? .white: .clear
        let colorText: UIColor = isActive ? .white: .quickSilver
        let titleButton: String = isActive ? "Selected" : "Select"
        
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = colorBackground
        button.setTitle(titleButton, for: .normal)
        button.layer.borderColor = colorBorder.cgColor
        lbCardNumber?.textColor = colorText
        view.backgroundColor = colorViewBackground
    }
    
    func getData() {
        if let umaca = UserManager.share().getCurrentUMACA() {
            let cardNumber = umaca["cardNumber"]
            let birthday = umaca["birthday"]
            let pinCode = umaca["pinCode"]
            let umacaFlg = umaca["umacaFlg"]
            umacaTicket.value = (cardNumber, birthday, pinCode, umacaFlg, false)
            needGetData = true
        }
    }
    
    func back(_ controller: ListUMACATicketVC?) {
        guard let controller = controller else { return }
        if(controller.isModal) {
            controller.dismiss(animated: true)
        } else {
            guard let rootVC = controller.navigationController?.viewControllers.first else { return }
            rootVC.dismiss(animated: true)
        }
    }
    
    func reloadData() {
        getData()
    }
}

extension ListUMACATicketViewModel {
    private func handlerResponse<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void), failureCompletion:(String) -> Void) {
        Utils.hideProgress()
        guard let response = response else { return }
        if (response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            failureCompletion(message)
        }
    }
    
    private func responseUpdateUMACA(_ response: ResponseUpdateUMACAFlag?, success: Bool) {
        handlerResponse(response) { [weak self] res in
            guard let data = res.data, let umacaFlg = data.umacaFlg, let userId = data.userId, var umacaTickets = Utils.getDictUserDefault(key: .umacaTickets), var umaca = umacaTickets[userId] as? [String: String] else { return }
            umaca["umacaFlg"] = umacaFlg
            umacaTickets[userId] = umaca
            Utils.setDictUserDefault(value: umacaTickets, forKey: .umacaTickets)
            self?.reloadData()
        } failureCompletion: { [weak self] message in
            self?.showMessageError(message: message)
        }
    }
}
