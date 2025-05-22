//
//  IMTTabViewModel.swift
//  IMT-iOS
//
//  Created by dev on 09/05/2023.
//

import Foundation
import UIKit

protocol IMTTabViewModelProtocol {
    func transitionVote(_ controller: BaseViewController?)
    func createVotingQR(_ controller: BaseViewController?)
    
    var onTransactionVote: JString { get set }
}

class IMTTabViewModel: BaseViewModel {
    var onTransactionVote: JString = { _ in }
    internal var numRequest: Int = 0
    
    init(child childVC: IMTContentActionProtocol, parent parentVC: IMTTabVC) {
        super.init()
        self.loadContentView(child: childVC, parent: parentVC)
    }
}

extension IMTTabViewModel: IMTTabViewModelProtocol {
    func transitionVote(_ controller: BaseViewController?) {
        Utils.logActionClick(.internetVoting)
        if(UserManager.share().legalAge()) {
            let showLinkageIpat = UserManager.share().showLinkageIpat()
            let showUmaca = UserManager.share().showUmaca()
            
            if showLinkageIpat {
                if showUmaca {
                    controller?.showPopupLinkage()
                } else {
                    skipUmacaLogin()
                }
            } else {
                if showUmaca {
                    skipLogin()
                } else {
                    controller?.showPurchaseHorseRacingTicket({ [weak self] option in
                        switch option {
                        case .iPat:
                            self?.skipLogin()
                            break
                        case .umaca:
                            self?.skipUmacaLogin()
                            break
                        }
                    })
                }
            }
        } else {
            controller?.showWarningLegalAge()
        }
    }
    
    func createVotingQR(_ controller: BaseViewController?) {
        guard let controller = controller else { return }
        Utils.logActionClick(.createVotingQR)
        controller.transitionFromSafari(TransactionLink.qrCode.rawValue)
    }
}

extension IMTTabViewModel: IMTWedRedirect {
    func increaseRequest() {
        self.numRequest += 1
    }
    
    func redirect(url: String?, html: String?, success: Bool) {
        Utils.hideProgress()
        if let url = url {
            Utils.mainAsync { [weak self] in
                self?.onTransactionVote(url)
            }
        }
        self.numRequest = 0
    }
    
    private func call(transaction: TransactionLink,
              successCompletion:@escaping(_ html: String) -> Void,
              failureCompletion:@escaping() -> Void) {
        if let request = request(url: transaction.rawValue, post: true) {
            URLSession.shared.dataTask(with: request) {data, response, error in
                if let data = data,
                   let html = String(data: data, encoding: .japaneseEUC) {
                    successCompletion(html)
                } else {
                    failureCompletion()
                }
            }.resume()
        } else {
            failureCompletion()
        }
    }
    
    private func loadIpat() {
        self.call(transaction: .ipat) { [weak self] htmlIpat in
            if let urlIpatSkipLogin = self?.getFullURLSkipLogin(transition: .ipat, html: htmlIpat) {
                self?.redirect(url: urlIpatSkipLogin, html: htmlIpat, success: true)
                Utils.hideProgress()
            } else {
                self?.call(transaction: .nIpat, successCompletion: { [weak self] htmlNIpat in
                    if let urlNIpatSkipLogin = self?.getFullURLSkipLogin(transition: .nIpat, html: htmlNIpat) {
                        self?.redirect(url: urlNIpatSkipLogin, html: htmlNIpat, success: true)
                    } else {
                        self?.redirect(url: TransactionLink.ipat.rawValue, html: nil, success: true)
                    }
                    
                    Utils.hideProgress()
                }, failureCompletion: {
                    Utils.hideProgress()
                })
            }
        } failureCompletion: {
            Utils.hideProgress()
        }
    }
    
    private func loadDirectPat() {
        self.call(transaction: .ipat) { [weak self] htmlIpat in
            if let urlIpatSkipLogin = self?.getFullURLSkipLogin(transition: .directPat, html: htmlIpat) {
                self?.redirect(url: urlIpatSkipLogin, html: htmlIpat, success: true)
                Utils.hideProgress()
            } else {
                self?.redirect(url: TransactionLink.skipLoginDirect.rawValue, html: nil, success: true)
                Utils.hideProgress()
            }
        } failureCompletion: {
            Utils.hideProgress()
        }
    }
    
    private func getFullURLSkipLogin(transition: TransactionLink, html: String) -> String? {
        if let range = html.range(of: "NAME=uh VALUE="),
           let ipat = UserManager.share().getCurrentIpatSkipLogin() {
            let afterStr = html[range.upperBound...]
            
            let uhValue = afterStr.prefix(7).suffix(6)
            let gValue = "730"
            let userIdValue = ipat.siteUserId ?? ""
            let passValue = ipat.pinCode ?? ""
            let parNoValue =  ipat.parsNo ?? ""
            let mergeValue = "\(userIdValue)\(passValue)\(parNoValue)"
            let ifValue = "1"
            
            let parameters = "\(uhValue)&\(gValue)&\(mergeValue)&\(userIdValue)&\(passValue)&\(parNoValue)&\(ifValue)"
            let fullURL = transition.externalLink(parameters)
            return fullURL
        }
        
        return nil
    }
    
    private func getFullURLUmacaSkipLogin(transition: TransactionLink, html: String) -> String? {
        if let range = html.range(of: "NAME=uh VALUE="),
           let umaca = UserManager.share().getCurrentUMACASkipLogin() {
            let afterStr = html[range.upperBound...]
            
            let uhValue = afterStr.prefix(7).suffix(6)
            let gValue = "780"
            let cardNumberValue = umaca.cardNumber ?? ""
            let birthdayValue = umaca.birthday ?? ""
            let pinCodeValue =  umaca.pinCode ?? ""
            let mergeValue = "\(cardNumberValue)\(birthdayValue)\(pinCodeValue)"
            let ifValue = "1"
            
            let parameters = "\(uhValue)&\(gValue)&\(mergeValue)&\(ifValue)"
            let fullURL = transition.externalLink(parameters)
            return fullURL
        }
        
        return nil
    }
}

//MARK: Private
extension IMTTabViewModel {
    private func loadContentView(child childVC: IMTContentActionProtocol, parent parentVC: IMTTabVC) {
        parentVC.addChild(childVC.controller())
        childVC.controller().didMove(toParent: parentVC)
        parentVC.vContent.addSubview(childVC.controller().view)
        Utils.constraintFull(parent: parentVC.vContent, child: childVC.controller().view)
    }
    
    private func skipLogin() {
        if let ipat = UserManager.share().getCurrentIpatSkipLogin() {
            let isDirect = ipat.siteUserId.prefix(2) == "20"
            Utils.showProgress()
            
            if(isDirect) {
                loadDirectPat()
            } else {
                loadIpat()
            }
        } else {
            self.showMessageError(message: IMTErrorMessage.cantSkipLoggin.rawValue)
        }
    }
    
    private func skipUmacaLogin() {
        if let _ = UserManager.share().getCurrentUMACASkipLogin() {
            Utils.showProgress()
            
            loadUMACA()
        } else {
            self.showMessageError(message: IMTErrorMessage.cantSkipLoggin.rawValue)
        }
    }
    
    private func loadUMACA() {
        self.call(transaction: .umaca) { [weak self] htmlUMACA in
            if let urlUMACASkipLogin = self?.getFullURLUmacaSkipLogin(transition: .umaca, html: htmlUMACA) {
                self?.redirect(url: urlUMACASkipLogin, html: htmlUMACA, success: true)
            } else {
                self?.redirect(url: TransactionLink.umaca.rawValue, html: nil, success: true)
            }
            Utils.hideProgress()
        } failureCompletion: {
            Utils.hideProgress()
        }
    }
}
