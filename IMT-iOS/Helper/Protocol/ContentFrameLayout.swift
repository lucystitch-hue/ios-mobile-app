//
//  BaseLoadContentProtocol.swift
//  IMT-iOS
//
//  Created by dev on 22/06/2023.
//

import Foundation
import UIKit
import WebKit

protocol ContentFrameLayout: AnyObject {
    associatedtype T: Equatable //Type
    associatedtype C: BaseViewController //Controller
    associatedtype B: Any //Bundle
    
    var currentContent: UIView? { get set }
    var contentQueue: [(type: T, controller: BaseViewController?)] { get set }
    var onChangeContent: ObservableObject<T> { get set }
    
    //TODO: Common
    func loadContent(_ controller: C?, type: T, bundle: B?)
    func prepareMoveContent(child: UIViewController, parent: C)
    func back(_ controller: C?, times: Int, refresh: Bool, swipe: Bool)
    func swipe(_ controller: C?, x: CGFloat, alpha: CGFloat, finish: Bool)
    func getSwipingRatio() -> CGFloat
    
    //TODO: Implement
    ///View
    func getContentLayoutFactory(type: T, controller: C, bundle: B?) -> BaseViewController?
    func getContainer() -> UIView?
    func getMainView() -> UIView
    func updateContent(view: UIView)
    func getHomeView() -> UIView?
    func homeScreen() -> Bool
    
    ///Queue
    func pushQueue(type: T, controller: BaseViewController?)
    func removeLastQueue()
    func removeAllQueue()
    
    ///Type
    func getMainType() -> T
    func didChangeType(type: T)
}

extension ContentFrameLayout {
    func loadContent(_ controller: C?, type: T, bundle: B? = nil) {
        guard let controller = controller else { return }
        guard let stackView = getContainer() else { return }
        
        //TODO: Remove or hidden content
        let mainType = getMainType()
        if let currentContent = self.currentContent, type != mainType {
            currentContent.isHidden = false;
        } else {
            removeContentQueue(stackView)
        }
        
        //TODO: Update content
        let contentVC = getContentLayoutFactory(type: type, controller: controller, bundle: bundle)
        pushQueue(type: type, controller: contentVC)
        
        //TODO: Reload UI
        didChangeType(type: type)
        
        //TODO: Update lastController
        updateLastController(controller, contentVC: contentVC)
        
        //TODO: Add mask when navigate to child
        addMaskOnPreviousView()
    }
    
    func back(_ controller: C?, times: Int = 1, refresh: Bool = true, swipe: Bool = false) {
        run()
        
        /*--------------------------------------------------------------*/
        func run() {
            if(times == 1) {
                execute()
            } else {
                for _ in 1...times {
                    execute()
                }
            }
        }
        
        func execute() {
            if let webVC = contentQueue.last?.controller as? IMTWebVC {
                let canGoBack = webVC.canGoBackFromParent(swipe)
                if(canGoBack) {
                    return
                } else {
                    backWhenNoWebview()
                }
            } else {
                backWhenNoWebview()
            }
            
            func backWhenNoWebview() {
                //TODO: Step 1 - Get view is visible
                guard let _ = controller,
                      let lastItem = contentQueue.last else { return }
                
                //TODO: Step 2 -  Remove last view
                if let lastController = lastItem.controller,
                   let vLastContent = lastController.view {
                    if (lastController.allowToBack() || swipe) {
                        self.removeMaskOnPreviousView()
                        
                        vLastContent.removeFromSuperview()
                        removeLastQueue()
                    } else {
                        return
                    }
                } else {
                    //TODO: Navigate tab home
                    self.removeMaskOnPreviousView()
                    
                    Utils.pushTab(.home)
                    return
                }
                
                //TODO: Step3 - Update visible view
                guard let currentItem = self.contentQueue.last else { return }
                let contentVC = currentItem.controller
                
                var vCurrentContent: UIView = contentVC?.view ?? getMainView()
                if(currentItem.type == getMainType()) {
                    vCurrentContent = getMainView()
                }
                
                vCurrentContent.isHidden = false
                
                if refresh {
                    if let contentVC = contentVC {
                        contentVC.viewWillAppear(true)
                    } else {
                        controller?.viewWillAppear(true)
                    }
                }
                
                updateContent(view: vCurrentContent)
                didChangeType(type: currentItem.type)
            }
        }
        /*--------------------------------------------------------------*/
    }
    
    func prepareMoveContent(child: UIViewController, parent: C) {
        if let vContent = child.view {
            let stackView = getContainer()
            stackView?.addSubview(vContent)
            vContent.translatesAutoresizingMaskIntoConstraints = false
            Utils.constraintFull(parent: stackView!, child: vContent)
            updateContent(view: vContent)
        }
    }
    
    func swipe(_ controller: C?, x: CGFloat, alpha: CGFloat, finish: Bool) {
        
        var webView: WKWebView?
        if let webVC = contentQueue.last?.controller as? IMTWebVC {
            let canGoBack = webVC.webView.canGoBack
            if(!canGoBack) {
                webView = webVC.webView
                setViewAttribute(webView, interaction: false, originX: x)
                setAlpha(alpha)
            }
        } else {
            let swipeable = (homeScreen() && onChangeContent.value != getMainType()) || !homeScreen()
            
            if(swipeable) {
                setViewAttribute(nil, interaction: false, originX: x)
                setAlpha(alpha)
            }
        }
        
        if(finish) {
            back(controller, swipe: true)
        } else {
            setViewAttribute(webView, interaction: true, originX: nil)
        }
        
        func setViewAttribute(_ webView: WKWebView?, interaction: Bool, originX: CGFloat?) {
            if let webView {
                webView.scrollView.isScrollEnabled = interaction
            }
            
            if let originX = originX {
                let dragView = getDragView()
                dragView?.frame.origin.x = originX
                
                if let pView = getPreviousView() {
                    let startOriginx = -(UIScreen.main.bounds.width * Constants.System.swipeRatio)
                    pView.frame.origin.x = startOriginx + originX * Constants.System.swipeRatio
                }
            }
        }
        
        func setAlpha(_ value: CGFloat) {
            guard let pView = getPreviousView() else { return }
            let vAlpha = value > Constants.System.swipeRatio ? Constants.System.swipeRatio : alpha
            if let maskView = pView.subviews.last, maskView.accessibilityIdentifier == MainVC.maskViewIdentifier {
                maskView.backgroundColor = UIColor(white: 0, alpha: vAlpha)
            }
        }
        
        func getDragView() -> UIView? {
            if(onChangeContent.value == getMainType()) {
                return self.getContainer()
            } else {
                return self.currentContent
            }
        }
    }
    
    func getSwipingRatio() -> CGFloat {
        return Constants.System.swipeRatio
    }
    
    func getHomeView() -> UIView? {
        return nil
    }
    
    func homeScreen() -> Bool {
        return false
    }
}

//MARK: Private
extension ContentFrameLayout {
    private func removeContentQueue(_ stackView: UIView) {
        let mainType = getMainType()
        for queue in contentQueue {
            if(queue.type != mainType) {
                if let vContent = queue.controller?.view {
                    vContent.removeFromSuperview()
                }
            }
        }
        
        removeAllQueue()
    }
    
    private func updateLastController(_ containerVC: UIViewController, contentVC: UIViewController?) {
        if let contentVC = contentVC {
            Constants.lastController = contentVC.getName()
        } else {
            Constants.lastController = containerVC.getName()
        }
    }
    
    private func getMaskView() -> UIView? {
        let vMask = UIView()
        vMask.backgroundColor = UIColor(white: 0, alpha: Constants.System.swipeRatio)
        vMask.accessibilityIdentifier = MainVC.maskViewIdentifier
        
        return vMask
    }
    
    private func getPreviousView() -> UIView? {
        let pIndex = self.contentQueue.lastIndex - 1
        
        if(pIndex > 0) {
            return contentQueue[pIndex].controller?.view
        } else if(pIndex == 0) {
            return self.getMainView()
        } else {
            guard let vHome = getHomeView() else { return nil }
            return vHome.subviews.last
        }
    }
    
    private func addMaskOnPreviousView() {
        //TODO: Remove maskView in previous tab screen when user selected other tab
        resetViewAttribute()
        
        //TODO: Add mask view
        if let pView = getPreviousView(), pView.subviews.last?.accessibilityIdentifier != MainVC.maskViewIdentifier {
            if let vMask = getMaskView() {
                pView.addSubview(vMask)
                pView.frame.origin.x = -UIScreen.main.bounds.size.width * Constants.System.swipeRatio
                vMask.translatesAutoresizingMaskIntoConstraints = false
                Utils.constraintFull(parent: pView, child: vMask)
            }
        }
        
        func resetViewAttribute() {
            getMainView().frame.origin.x = 0.0
            if(getMainView().subviews.last?.accessibilityIdentifier == MainVC.maskViewIdentifier && self.onChangeContent.value == getMainType() ) {
                getMainView().subviews.last?.removeFromSuperview()
            }
        }
    }
    
    private func removeMaskOnPreviousView() {
        if let pView = getPreviousView(),
           let maskView = pView.subviews.last, maskView.accessibilityIdentifier == MainVC.maskViewIdentifier {
            maskView.removeFromSuperview()
            pView.frame.origin.x = 0
        }
    }
}
