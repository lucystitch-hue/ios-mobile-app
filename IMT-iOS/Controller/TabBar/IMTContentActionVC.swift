//
//  IMTContentActionVC.swift
//  IMT-iOS
//
//  Created by dev on 09/05/2023.
//

import Foundation
import UIKit

protocol IMTContentActionProtocol {
    
    //MARK: Action
    func back()
    func controller() -> BaseViewController
    func onSwipe(x: CGFloat, alpha: CGFloat, finish: Bool)
    func getSwipingRatio() -> CGFloat
    func getMainContent() -> UIScrollView?
    func scrollToTop()
    func gotoVoteOnline()
    
    func homeScreen() -> Bool
    func setHomeContentView(_ content: UIView)
    func getHomeContentView() -> UIView?
    func getNumberRemainPage() -> Int
    
    //MARK: LifeCycle
    func viewContentWillAppear(_ animated: Bool)
    func prepareRoot()
    
    //MARK: Callback
    var onHiddenBack: JBool { get set }
    var onRunAnimateVote: JVoid { get set }
    var onStopAnimateVote: JVoid { get set }
    var onPrepareAnimateBack: JVoid { get set }
    var onEnableParentScroll: JBool { get set } //Avoid case caculate offset from IQKeyboardManager. Default value true
    var onWillResignActive: JVoid { get set }
    
    var isScrollToTop: Bool { get set }
}

class IMTContentActionVC<VM: ViewModelProtocol>: BaseDataController<VM>, IMTContentActionProtocol {
    var onHiddenBack: JBool = { _ in }
    var onEnableParentScroll: JBool = { _ in }
    var onRunAnimateBack: JVoid = {}
    var onRunAnimateVote: JVoid = {}
    var onStopAnimateVote: JVoid = {}
    var onPrepareAnimateBack: JVoid = {}
    var isScrollToTop: Bool = false
    var vHomeContent: UIView?
    var onWillResignActive: JVoid = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onEnableParentScroll(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addHomeContentIfNeed()
        pushScreenFromIncomingNotificationIfNeed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func viewContentWillAppear(_ animated: Bool) {
    
    }
    
    override func willResignActive() {
        super.willResignActive()
        self.onWillResignActive()
    }
    
    func controller() -> BaseViewController {
        return self
    }
    
    func onSwipe(x: CGFloat, alpha: CGFloat, finish: Bool = false) {
        
    }
    
    func getSwipingRatio() -> CGFloat {
        return Constants.System.swipeRatio
    }
    
    func back() {
        
    }
    
    func backToRoot() {
        
    }
    
    func getMainContent() -> UIScrollView? {
        return nil
    }
    
    func scrollToTop() {
        isScrollToTop = false
        Utils.mainAsync {
            self.getMainContent()?.setContentOffset(.zero, animated: true)
        }
    }
    
    func gotoVoteOnline() {
        
    }
    
    func homeScreen() -> Bool {
        return false
    }
    
    func setHomeContentView(_ content: UIView) {
        self.vHomeContent = content
    }
    
    func getHomeContentView() -> UIView? {
        return vHomeContent
    }
    
    func getNumberOfChildController() -> Int {
        return 0
    }
    
    func prepareRoot() {
        
    }
    
    func getNumberRemainPage() -> Int {
        return 0
    }
    
    override func checkVersionBecomeForeground() -> Bool {
        //TODO: Handle doesn't show the forceupdate popup. Before the app shows other popups.
        guard let _ = presentedViewController else { return true }
        return false
    }
}

extension IMTContentActionVC {
    private func pushScreenFromIncomingNotificationIfNeed() {
        guard let notification = Constants.incomingNotification else { return }
        //TODO: Push
        guard let need = notification.getType()?.needToPushScreen(self) else { return }
        
        //TODO: Only push screen when controller is valid
        if (need) {
            action(notification)
        }
    }
    
    private func addHomeContentIfNeed() {
        if let vHomeContent = vHomeContent, !homeScreen() {
            self.view.addSubview(vHomeContent)
            vHomeContent.translatesAutoresizingMaskIntoConstraints = false
            self.view.sendSubviewToBack(vHomeContent)
            Utils.constraintFull(parent: self.view, child: vHomeContent)
        }
    }
}
