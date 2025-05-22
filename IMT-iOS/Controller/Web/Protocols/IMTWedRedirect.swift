//
//  IMTWedRedirect.swift
//  IMT-iOS
//
//  Created by dev on 02/06/2023.
//

import Foundation

//MARK: Workflow
///Step 1: Call function load
///Step 2: Redirect when It return response
internal protocol IMTWedRedirect: IMTWeb {
    var numRequest: Int { get set }
    
    //TODO: You need to implement the protocol in class. It returns a result after completing the fetch link.
    func redirect(url: String?, html: String?, success: Bool)
    
    //TODO: Increase number request when redirect
    func increaseRequest()
}

extension IMTWedRedirect {
    func load(url strURL: String) {
//        if let linkDefine = TransactionLink(rawValue: strURL), linkDefine.hasRedirect() {
//            self.call(transaction: linkDefine, orginal: linkDefine)
//        } else {
            self.redirect(url: strURL, html: nil, success: true)
//        }
    }
    
    func load(url strURL: String, convertHTML: Bool = false) {
        if(convertHTML) {
            call(url: strURL)
        } else {
            self.redirect(url: strURL, html: nil, success: true)
        }
    }
}

//MARK: Private
extension IMTWedRedirect {
    private func call(transaction: TransactionLink, orginal orginalTrans: TransactionLink) {
        if let request = request(url: transaction.rawValue) {
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                self.response(data: data, response: response, error: error, original: orginalTrans)
            }).resume()
        } else {
            redirect(url: nil, html: nil, success: false)
        }
    }
    
    private func call(url: String) {
        if let request = request(url: url) {
            URLSession.shared.dataTask(with: request, completionHandler: response).resume()
        } else {
            redirect(url: nil, html: nil, success: false)
        }
    }
    
    private func response(data:Data?,
                          response:URLResponse?,
                          error:Error?,
                          original orginTrans: TransactionLink) {
        if let data = data,
           let html = String(data: data, encoding: .japaneseEUC),
           let url = response?.url?.absoluteString,
           let transaction = TransactionLink(rawValue: url) {
            autoRedirect(transaction, html: html, orginal: orginTrans)
        } else {
            self.redirect(url: nil, html: nil, success: false)
        }
    }
    
    private func response(data:Data?,
                          response:URLResponse?,
                          error:Error?) {
        if let data = data,
           let html = String(data: data, encoding: .utf8),
           let url = response?.url?.absoluteString {
            self.redirect(url: url, html: html, success: true)
        } else {
            self.redirect(url: nil, html: nil, success: false)
        }
    }
    private func autoRedirect(_ transition: TransactionLink, html: String, orginal orginTrans: TransactionLink) {
        if(transition == orginTrans && self.numRequest > 0) {
            DispatchQueue.main.async {
                redirect(url: transition.rawValue, html: html, success: true)
            }
        } else {
            switch transition {
            case .ipat:
                self.redirect(transition.characters(), html: html, transition: .nIpat)
                break
            case .nIpat:
                self.redirect(transition.characters(), html: html, transition: .ipat)
                break
            default:
                break
            }
        }
    }
    
    private func redirect(_ text: String, html: String, transition: TransactionLink) {
        if html.contains(text) {
            self.load(transaction: transition)
            increaseRequest()
        } else {
            redirectFactory(html: html, transition: transition)
        }
    }
    
    private func redirectFactory(html: String, transition: TransactionLink) {
        DispatchQueue.main.async {
            switch transition {
            case .directPat, .nIpat, .ipat:
                //Success
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
                    if let fullURL = transition.externalLink(parameters) {
                        redirect(url: fullURL, html: html, success: true)
                        return
                    }
                }
            default:
                break
            }
            
            //Failure
            redirect(url: nil, html: nil, success: false)
        }
    }
}
