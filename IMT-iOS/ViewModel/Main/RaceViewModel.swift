//
//  RaceViewModel.swift
//  IMT-iOS
//
//  Created by dev on 24/04/2023.
//

import Foundation
import UIKit
import WebKit

enum RaceContentType: Equatable {
    case main
    case subcriber
    case updateIpat
    case registerIpat
    case webView
}

protocol RaceViewModelProtocol {
    var trainingRaces: [RaceYoutubeLink] { get set }
    var indexSelected: ObservableObject<Int> { get set }
    var onTransactionRaceYoutube:((_ path: String) -> Void) { get set }
    var onChangeContent: ObservableObject<RaceContentType> { get set }
    
    func getViewHeaderSection(_ tableView: UITableView) -> UIView
    func getNumberSections(_ tableView: UITableView) -> Int
    func getCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell
    func didChoice(controller: RaceVC, tableView: UITableView, didChoiceRowAt indexPath: IndexPath)
    
    func getNumberRemainPage() -> Int
}

class RaceViewModel: BaseViewModel {
    
    var trainingRaces: [RaceYoutubeLink] = RaceYoutubeLink.allCases
    var indexSelected: ObservableObject<Int> = ObservableObject<Int>(-1)
    var onTransactionRaceYoutube: ((String) -> Void) = { _ in }
    var onChangeContent: ObservableObject<RaceContentType> = ObservableObject<RaceContentType>(.main)
    
    var currentContent: UIView?
    var previousContent: UIView?
    var contentQueue: [(type: RaceContentType, controller: BaseViewController?)] = []
    var contentView: UIView!
    var mainView: UIView!
    var homeContentView: UIView?
    
    init(contentView: UIView, mainView: UIView, homeContentView: UIView?) {
        super.init()
        self.contentView = contentView
        self.mainView = mainView
        self.homeContentView = homeContentView
    }
}

//MARK: RaceViewModelProtocol
extension RaceViewModel: RaceViewModelProtocol {
    
    func getNumberSections(_ tableView: UITableView) -> Int {
        return trainingRaces.count
    }
    
    func getViewHeaderSection(_ tableView: UITableView) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func getCell(_ tableView: UITableView,  indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrainingRaceCell.identifier) as? TrainingRaceCell else { return UITableViewCell() }
        cell.setup(image:trainingRaces[indexPath.section].image())
        return cell
    }
    
    func didChoice(controller: RaceVC, tableView: UITableView, didChoiceRowAt indexPath: IndexPath) {
        let link = trainingRaces[indexPath.section].url()
        loadContent(controller, type: .webView, bundle: [.transInfo: link])
    }
    
    func getNumberRemainPage() -> Int {
        return contentQueue.count
    }
}

//MARK: Private
extension RaceViewModel: ContentFrameLayout{
    func getContentLayoutFactory(type: RaceContentType, controller: RaceVC, bundle: [RaceBundleKey: Any]?) -> BaseViewController? {
        var contentVC: BaseViewController?
        
        switch type {
        case .main:
            currentContent = contentView!
            break
        case .subcriber:
            let exist = UserManager.share().checkExistIpat()
            let vc: BaseViewController!
            
            if(!exist) {
                let votingOnlineVC = VotingOnlineVC(type: .ipatOne, original: true, isEdit: false, inputScreen: .menu)
                
                votingOnlineVC.onSuccess = { [weak self] in
                    self?.back(controller)
                    self?.loadContent(controller, type: .subcriber)
                }
                
                vc = votingOnlineVC
            } else {
                let listVotingOnlineVC = ListVotingOnlineVC(.menu)
                listVotingOnlineVC.onGotoUpdateIPat = { [weak self] type in
                    let bundle: [RaceBundleKey: Any] = [.votingOnlineType: type]
                    self?.loadContent(controller, type: .updateIpat, bundle: bundle)
                }
                
                listVotingOnlineVC.onGotoRegisterIPat = { [weak self] in
                    self?.loadContent(controller, type: .registerIpat)
                }
                
                vc = listVotingOnlineVC
            }
            
            self.prepareMoveContent(child: vc, parent: controller)
            
            return vc
        case .updateIpat:
            guard let type = bundle?[.votingOnlineType] as? VotingOnlineType else { return nil }
            let vc = VotingOnlineVC(type: type, inputScreen: .menu)
            
            vc.onSuccess = { [weak self] in
                let exist = UserManager.share().checkExistIpat()
                if(exist) {
                    self?.back(controller)
                } else {
                    self?.loadContent(controller, type: .main)
                }
            }
            
            self.prepareMoveContent(child: vc, parent: controller)
            return vc
        case .registerIpat:
            let type: VotingOnlineType = UserManager.share().checkExistIpat1() ? .ipatTwo : .ipatOne
            let vc = VotingOnlineVC(type: type, original: false, isEdit: false, inputScreen: .menu)
            
            vc.onSuccess = { [weak self] in
                self?.back(controller)
            }
            
            self.prepareMoveContent(child: vc, parent: controller)
            
            return vc
        case .webView:
            guard let trans = bundle?[.transInfo] as? JMTransAgent else { return nil }
            contentVC = IMTWebVC(string: trans.url, useNavigation: false, delegate: self, userAgent: trans.userAgent)
            self.prepareMoveContent(child: contentVC!, parent: controller)
            break
        }
        
        return contentVC
    }
    
    func getContainer() -> UIView? {
        return contentView
    }
    
    func getMainView() -> UIView {
        return mainView
    }
    
    func updateContent(view: UIView) {
        self.currentContent = view
    }
    
    func pushQueue(type: RaceContentType, controller: BaseViewController?) {
        let item = (type: type, controller: controller)
        contentQueue.append(item)
    }
    
    func removeLastQueue() {
        self.contentQueue.removeLast()
    }
    
    func removeAllQueue() {
        self.contentQueue.removeAll()
    }
    
    func getMainType() -> RaceContentType {
        return .main
    }
    
    func didChangeType(type: RaceContentType) {
        onChangeContent.value = type
    }
    
    func getHomeView() -> UIView? {
        return self.homeContentView
    }
}

extension RaceViewModel: IMTWebVCDelete {
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, clearHistory currentURL: String) -> Bool {
        return false
    }
    
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == "youtube" || url.scheme == "vnd.youtube" || url.queryStringParameter(param: "redirect_app_store_ios") == "1" {
            decisionHandler(.cancel)
            transitionBrowser(url: url)
            return
        }
        guard navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url, let host = url.host, host.hasPrefix("youtu.be") || host.hasPrefix("www.youtube.com") || host.hasPrefix("m.youtube.com") else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        web.load(url: url.absoluteString)
        
        func transitionBrowser(url: URL) {
            var trans: JMTrans = (url.absoluteString, false)
            
            if !UIApplication.shared.canOpenURL(url), let urlHttpsScheme = url.replaceScheme("https") {
                trans = (urlHttpsScheme.absoluteString, false)
            }
            
            web.transition(info: trans)
        }
    }
    
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, redirectScript navigationAction: WKNavigationAction) -> (input: String, event: String?)? {
        let js = "let style = document.createElement('style'); style.innerHTML = '.mobile-topbar-back-arrow { display: none }'; document.head.appendChild(style);"
        return (js, nil)
    }
}
