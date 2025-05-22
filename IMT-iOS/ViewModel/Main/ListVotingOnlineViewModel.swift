//
//  ListVotingOnlineViewModel.swift
//  IMT-iOS
//
//  Created by dev on 18/05/2023.
//

import Foundation
import UIKit

protocol ListVotingOnlineViewModelProtocol {
    var ipatData: ObservableObject<(data: IPatDataModel?, isIntial: Bool)> { get set }
    var needGetData: Bool { get set }
    
    func registerIPat(_ controller: ListVotingOnlineVC?)
    func updateIPat(_ controller: ListVotingOnlineVC?, type: VotingOnlineType)
    func configButtonActive(button: UIButton?, background view: UIView?, isActive: Bool, lbIPatId: UILabel?, lbIPatPass: UILabel?, lbIPatPars: UILabel?)
    func connect(type: VotingOnlineType)
    func disconnect(type: VotingOnlineType)
    func getData()
    func back(_ controller: ListVotingOnlineVC?)
}

class ListVotingOnlineViewModel: BaseViewModel {
    var ipatData: ObservableObject<(data: IPatDataModel?, isIntial: Bool)> = ObservableObject<(data: IPatDataModel?, isIntial: Bool)>((nil, true))
    var needGetData: Bool = false
    
    override init() {
        super.init()
        self.getData()
    }
}

extension ListVotingOnlineViewModel: ListVotingOnlineViewModelProtocol  {
    func updateIPat(_ controller: ListVotingOnlineVC?, type: VotingOnlineType) {
        guard let controller = controller else { return }
        let vc = VotingOnlineVC(type: type)
        controller.push(vc)
    }
    
    func registerIPat(_ controller: ListVotingOnlineVC?) {
        guard let controller = controller else { return }
        let type: VotingOnlineType = UserManager.share().checkExistIpat1() ? .ipatTwo : .ipatOne
        let vc = VotingOnlineVC(type: type, original: false, isEdit: false)
        controller.push(vc)
    }
    
    func connect(type: VotingOnlineType) {
        let form = FormVotingOnline(type: type, intitalFromUserManager: true)
        if (form.ysnFlg == "1") { return }
        Utils.showProgress(false)
        Utils.mainAsyncAfter { [weak self] in
            guard let self = self else { return }
            form.ysnFlg = "1"
            self.manager.call(endpoint: .createAndUpdateUserIPat(form), completion: self.responseUpdateIPat)
        }
    }
    
    func disconnect(type: VotingOnlineType) {
        Utils.showProgress(false)
        
        Utils.mainAsyncAfter { [weak self] in
            guard let self = self else { return }
            let form = FormVotingOnline(type: type, intitalFromUserManager: true)
            form.ysnFlg = "0"
            self.manager.call(endpoint: .createAndUpdateUserIPat(form), completion: self.responseUpdateIPat)
        }
    }

    func configButtonActive(button: UIButton?, background view: UIView?, isActive: Bool, lbIPatId: UILabel?, lbIPatPass: UILabel?, lbIPatPars: UILabel?) {
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
        lbIPatId?.textColor = colorText
        lbIPatPass?.textColor = colorText
        lbIPatPars?.textColor = colorText
        view.backgroundColor = colorViewBackground
    }
    
    func getData() {
        self.manager.call(endpoint: .ipatList, completion: responseIPat)
    }
    
    func back(_ controller: ListVotingOnlineVC?) {
        guard let controller = controller else { return }
        if(controller.isModal) {
            controller.dismiss(animated: true)
        } else {
            guard let rootVC = controller.navigationController?.viewControllers.first else { return }
            rootVC.dismiss(animated: true)
        }
    }
}

//MARK: Private
extension ListVotingOnlineViewModel {
    private func hiddenBtnRegister(ipatData: IPatDataModel?) -> Bool {
        guard let _ = ipatData?.iPatId2 else { return false }
        return true
    }
    
    func reloadData() {
        let data = UserManager.share().user
        ipatData.value = (data, false)
    }
}

//MARK: API
extension ListVotingOnlineViewModel {
    //TODO: Call
    
    //TODO: Response
    private func handlerResponse<R: BaseResponse>(_ response: R?, successCompletion:@escaping((R) -> Void), failureCompletion:(String) -> Void) {
        guard let response = response else { return }
        if (response.success) {
            successCompletion(response)
        } else {
            guard let message = response.message else { return }
            failureCompletion(message)
        }
    }
    
    private func responseIPat(_ response: ResponseIPatList?, success: Bool) {
        Utils.hideProgress()
        handlerResponse(response) { [weak self]res in
            guard let data = response?.data else { return }
            UserManager.share().updateIPat(data)
            self?.reloadData()
            self?.needGetData = true
        } failureCompletion: { [weak self] message in
            self?.showMessageError(message: message)
        }
    }
    
    private func responseUpdateIPat(_ response: ResponseVotingOnline?, success: Bool) {
        handlerResponse(response) { [weak self] res in
            guard let data = res.data else { return }
            UserManager.share().user?.ysnFlg1 = data.ysnFlg1
            UserManager.share().user?.ysnFlg2 = data.ysnFlg2
            self?.reloadData()
        } failureCompletion: { [weak self] message in
            self?.showMessageError(message: IMTErrorMessage.activeVotingInvalid.rawValue)
        }
    }
}
