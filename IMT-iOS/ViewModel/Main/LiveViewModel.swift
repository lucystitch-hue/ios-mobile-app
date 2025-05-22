//
//  LiveViewModel.swift
//  IMT-iOS
//
//  Created by dev on 07/03/2023.
//

import UIKit

enum LiveContentType: Equatable {
    case main
    case subcriber
    case updateIpat
    case registerIpat
}

class LiveViewModel: BaseViewModel {
    var onChangeContent: ObservableObject<LiveContentType> = ObservableObject<LiveContentType>(.main)
    var currentContent: UIView?
    var previousContent: UIView?
    var contentQueue: [(type: LiveContentType, controller: BaseViewController?)] = []
    var contentView: UIStackView!
    var mainView: UIView!
    var homeContentView: UIView?
    
    func setup(contentView: UIStackView, mainView: UIView, homeContentView: UIView?) {
        self.contentView = contentView
        self.mainView = mainView
        self.homeContentView = homeContentView
    }
    
//    func swipe(_ controller: LiveVC?, x: CGFloat, alpha: CGFloat, finish: Bool) {
////        let currentContent = controller?.view
////        currentContent?.frame.origin.x = x
////        currentContent?.alpha = alpha
//        
//        if(finish) {
//            back(controller)
//        }
//    }
    
    func getNumberRemainPage() -> Int {
        return self.contentQueue.count
    }
}

extension LiveViewModel: ContentFrameLayout{
    
    func getContentLayoutFactory(type: LiveContentType, controller: LiveVC, bundle: [LiveBundleKey: Any]?) -> BaseViewController? {
//        controller.svMainContent.isHidden = true
        
        switch type {
        case .main:
//            controller.svMainContent.isHidden = false
            currentContent = contentView
            return nil
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
                    let bundle: [LiveBundleKey: Any] = [.votingOnlineType: type]
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
        }
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
    
    func pushQueue(type: LiveContentType, controller: BaseViewController?) {
        let item = (type: type, controller: controller)
        contentQueue.append(item)
    }
    
    func removeLastQueue() {
        self.contentQueue.removeLast()
    }
    
    func removeAllQueue() {
        self.contentQueue.removeAll()
    }
    
    func getMainType() -> LiveContentType {
        return .main
    }
    
    func didChangeType(type: LiveContentType) {
        onChangeContent.value = type
    }
    
    func getHomeView() -> UIView? {
        return homeContentView
    }
}
