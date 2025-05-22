//
//  VoteViewModel.swift
//  IMT-iOS
//
//  Created by dev on 30/08/2023.
//

import Foundation
import UIKit

class VoteViewModel: BaseViewModel {
    var onTransactionVote: JString = { _ in }
    internal var numRequest: Int = 0
}

extension VoteViewModel {
    func transitionVote(_ controller: VoteVC?) {
        Utils.logActionClick(.internetVoting)
        if(UserManager.share().legalAge()) {
            if(UserManager.share().showLinkageIpat()) {
                controller?.showPopupLinkage()
            } else {
                skipLogin()
            }
        } else {
            controller?.showWarningLegalAge()
        }
    }
    
    func createVotingQR(_ controller: VoteVC?) {
        guard let controller = controller else { return }
        Utils.logActionClick(.createVotingQR)
        controller.transitionFromSafari(TransactionLink.qrCode.rawValue)
    }
    
    func back(_ controller: VoteVC?) {
        Utils.postObserver(.openTab, object: IMTTab.home)
    }
    
    func swipe(_ controller: VoteVC?, x: CGFloat, alpha: CGFloat, finish: Bool) {
//        let currentContent = controller?.view
//        currentContent?.frame.origin.x = x
//        currentContent?.alpha = alpha
        
        if(finish) {
            back(controller)
        }
    }
}

extension VoteViewModel: IMTWedRedirect {
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
}

//MARK: Private
extension VoteViewModel {
    
    private func skipLogin() {
        if let ipat = UserManager.share().getCurrentIpatSkipLogin() {
            let isDirect = ipat.siteUserId.prefix(2) == "20"
            Utils.showProgress()
            
            if(isDirect) {
                load(transaction: .directPat)
            } else {
                loadIpat()
            }
        } else {
            self.showMessageError(message: IMTErrorMessage.cantSkipLoggin.rawValue)
        }
    }
}
