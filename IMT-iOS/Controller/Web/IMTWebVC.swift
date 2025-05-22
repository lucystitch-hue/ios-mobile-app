//
//  IMTWebVC.swift
//  IMT-iOS
//
//  Created by dev on 29/03/2023.
//

import UIKit
import WebKit
import SwiftyJSON

//MARK: Workflow
/// Step 1: Call function load
/// Step 2: Listent fuction redirect
/// Step 3: Load on webKit
protocol IMTWebVCDelete {
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, redirectScript navigationAction: WKNavigationAction) -> (input: String, event: String?)?
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, clearHistory currentURL: String) -> Bool
}

extension IMTWebVCDelete {
    func IMTWebVC(_ web: IMTWebVC, orginalUrl: String, redirectScript navigationAction: WKNavigationAction) -> (input: String, event: String?)? {
        return nil
    }
    
    func IMTWebVC(_ web: IMTWebVC, clearHistory currentUrl: String) -> Bool {
        return false
    }
}

class IMTWebVC: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var vContainFavorite: UIView!
    @IBOutlet weak var imvFavorite: UIImageView!
    @IBOutlet weak var lblFavorite: IMTLabel!
    
    private var url: String!
    private var currentUrl: String?
    private var cacheUrl: String?
    private var tryReload: Bool!
    private var isLoadingScript: Bool = false
    private var useNavigation: Bool = true
    private var postMethod: Bool = false //Support with link does not belong TransactionLink
    private var convertHTML: Bool = false
    private var replaceAttributeHTML: [String: String]?    //Ex: You want add attribute hidden = "hidden" <div className = "a" ><div>:
    //attributeHTML = {"className = "a"", "className = "a" hidden = "Hidden""}
    private var userAgent: String?
    private var redirectScripts: (input: String, event: String?)?
    private var preferenceFeatureViewModel: (any IMTWebViewForPreferenceFeatureViewModelProtocol)?
    
    public var delegate: IMTWebVCDelete?
    public var isCheckBack: Bool = false
    public var onPushFavorite: JVoid?
    public var onPushRaceHorseAndJockeyList: ((ListHorsesAndJockeysSegment?) -> Void)?
    
    internal var numRequest: Int = 0
    
    init(transition: TransactionLink) {
        super.init(nibName: nil, bundle: nil)
        self.url = transition.rawValue
    }
    
    init(string strValue: String,
         post: Bool = false,
         useNavigation: Bool = true,
         convertHTML: Bool = false,
         replaceAttributeHTML: [String: String]? = nil,
         delegate: IMTWebVCDelete? = nil,
         userAgent: String? = Constants.System.userAgentIMTA,
         tryReload: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.url = strValue
        self.useNavigation = useNavigation
        self.postMethod = post
        self.convertHTML = convertHTML
        self.replaceAttributeHTML = replaceAttributeHTML
        self.delegate = delegate
        self.userAgent = userAgent
        self.tryReload = tryReload
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupData()
    }
    
    override func gotoBack() {
        if let currentUrl = self.currentUrl,
           let clearHistory = self.delegate?.IMTWebVC(self, orginalUrl: url, clearHistory: currentUrl), clearHistory == true {
            self.dismiss(animated: true)
        } else {
            if(webView.canGoBack) {
                webView.goBack()
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
    public func canGoBackFromParent(_ swipe: Bool = true) -> Bool {
        if let currentUrl = self.currentUrl,
           let clearHistory = self.delegate?.IMTWebVC(self, orginalUrl: url, clearHistory: currentUrl), clearHistory == true {
            
            return false
        } else {
            let canGoBack = webView.canGoBack
            var isCheckGoBack:Bool = true
            
            if(canGoBack && !isCheckBack) {
                //If user touch from backButton is call goBack(). Else if user swipe isn't nessecary
                if(!swipe) {
                    webView.goBack()
                }
            } else {
                isCheckGoBack = false
            }
            
            return isCheckGoBack
        }
    }
    
    @IBAction func actionUpdateStateFavorite(_ sender: Any) {
        preferenceFeatureViewModel?.action(self)
    }
}

//MARK: Private
extension IMTWebVC {
    private func setupUI() {
        self.useNavigation ? self.setupNavigation() : nil
        configWebKit()
        configFavoriteView()
    }
    
    private func setupData() {
        self.load(url: self.url, convertHTML: convertHTML)
    }
    
    private func autoAction() {
        main()
        
        /*------------------------------------------------------------------------------------------------------------------------------------------*/
        func main() {
            if let scripts = self.redirectScripts {
                run(scripts) {
                    self.endProgress()
                }
            } else {
                nonRedirectScripts()
            }
        }
        
        func nonRedirectScripts() {
            if(url == currentUrl) {
                run(url) {
                    self.endProgress()
                }
            } else {
                run(url) {
                    run(self.currentUrl) {
                        self.endProgress()
                    }
                }
            }
        }
        
        func run(_ url: String?, completion: JVoid? = nil) {
            if let url = url,
               let transition = TransactionLink(rawValue: url) {
                if let scripts = transition.scripts() {
                    run(scripts, completion: completion)
                } else {
                    completion?()
                }
            } else {
                completion?()
            }
        }
        
        func run(_ scripts: (input: String, event: String?)?, completion: JVoid? = nil) {
            guard let scripts = scripts else { return }
            let input = scripts.input
            self.webView.evaluateJavaScript(input) { html, error in
                if error == nil {
                    if let event = scripts.event, !event.isEmpty {
                        self.webView.evaluateJavaScript(event) { htmlEvent, errorEvent in
                            completion?()
                        }
                    } else {
                        completion?()
                    }
                } else {
                    completion?()
                }
            }
        }
        /*------------------------------------------------------------------------------------------------------------------------------------------*/
    }
    
    private func reset() {
        redirectScripts = nil
    }
    
    private func endProgress() {
        
        //TODO: Preference feature
        if let preferenceFeatureViewModel = preferenceFeatureViewModel {
            preferenceFeatureViewModel.updateState(webView, completion: {
                Utils.hideProgress()
            })
        } else {
            Utils.hideProgress()
        }
        
        //TODO: Notification
        
        if Utils.hasIncommingNotification() {
            Utils.clearDataIncommingNotification()
        }
    }
    
    private func configFavoriteView() {
        vContainFavorite.roundCorners([.layerMinXMinYCorner, .layerMinXMaxYCorner], radius: 8)
        vContainFavorite.layer.borderWidth = 1
        vContainFavorite.layer.borderColor = UIColor.black.cgColor
        vContainFavorite.setShadowLogin()
    }
    
    private func initialFavoriteObjectIfNeed() {
        let accessU = self.currentUrl?.contains(TransactionLink.stallionReading.url) ?? false
        let accessK = self.currentUrl?.contains(TransactionLink.jockeyDirectory.url) ?? false
        preferenceFeatureViewModel = nil
        if (accessK) {
            preferenceFeatureViewModel = IMTWebViewForFavoriteFeatureViewModel()
        } else if(accessU) {
            preferenceFeatureViewModel = IMTWebViewForRecommendFeatureViewModel()
            preferenceFeatureViewModel?.setCName(currentUrl ?? "")
        } else {
            preferenceFeatureViewModel?.setCName(nil)
        }
    }
    
    private func bindingFavoriteObject() {
        preferenceFeatureViewModel?.onState.bind { [weak self] result in
            guard let weakSelf = self else { return }
            
            if let result = result,
               let isIntial = result.isIntial , !isIntial {
                let state = result.favorite
                let width = 60.0
                weakSelf.lblFavorite.text = weakSelf.preferenceFeatureViewModel?.getButtonTitle()
                caseByCase(state, width: width)
            }
            
            /*---------------------------------------------------------------------------------------*/
            func caseByCase(_ state: FavoritePageState, width: CGFloat) {
                switch weakSelf.preferenceFeatureViewModel {
                case is IMTWebViewForFavoriteFeatureViewModel:
                    favorite(state, width: width)
                    break
                case is IMTWebViewForRecommendFeatureViewModel:
                    recommened(state, width: width)
                    break
                default:
                    break
                }
            }
            
            func favorite(_ state: FavoritePageState, width: CGFloat) {
                
                switch state {
                case .none:
                    self?.vContainFavorite.isHidden = true
                    break
                case .favorite:
                    self?.vContainFavorite.isHidden = false
                    self?.imvFavorite.image = .icFavoritePerson
                    self?.lblFavorite.textColor = .spanishOrange
                    break
                case .unfavorite:
                    self?.vContainFavorite.isHidden = false
                    self?.imvFavorite.image = .icUnFavoritePerson
                    self?.lblFavorite.textColor = .gray
                    break
                }
            }
            
            func recommened(_ state: FavoritePageState, width: CGFloat) {
                switch state {
                case .none:
                    self?.vContainFavorite.isHidden = true
                    break
                case .favorite:
                    self?.vContainFavorite.isHidden = false
                    self?.imvFavorite.image = .icRecommendedHorse
                    self?.lblFavorite.textColor = .spanishOrange
                    break
                case .unfavorite:
                    self?.vContainFavorite.isHidden = false
                    self?.imvFavorite.image = .icUnRecommendedHorse
                    self?.lblFavorite.textColor = .gray
                    break
                }
            }
            /*---------------------------------------------------------------------------------------*/
        }
        
        preferenceFeatureViewModel?.pushListRaceHorseAndJockey = { [weak self] in
            let segment: ListHorsesAndJockeysSegment = self?.preferenceFeatureViewModel is IMTWebViewForFavoriteFeatureViewModel ? .favoriteJockeys : .recommendedHorses
            self?.onPushRaceHorseAndJockeyList?(segment)
        }
    }
    
    private func favoriteObjectHandler() {
        preferenceFeatureViewModel?.setCName(nil)
        
        initialFavoriteObjectIfNeed()
        
        bindingFavoriteObject()
    }
}

extension IMTWebVC: IMTBaseWebVC {
    typealias D = IMTWebVC
    
    func getWebKit() -> WKWebView {
        return self.webView
    }
    
    func getWKDelegate() -> IMTWebVC? {
        return self
    }
    
    func getUserAgent() -> String? {
        return self.userAgent
    }
}

extension IMTWebVC: IMTWedRedirect {
    func increaseRequest() {
        self.numRequest += 1
    }
    
    func redirect(url: String?, html: String?, success: Bool) {
        if(convertHTML) {
            guard let strURL = url,
                  let url = URL(string: strURL),
                  var html = html else { return }
            if let replaceAttributeHTML = replaceAttributeHTML{
                for attr in replaceAttributeHTML {
                    let oldAttribute = attr.key
                    let newAttribute = attr.value
                    html = html.replace(target: oldAttribute, withString: newAttribute)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.webView.loadHTMLString(html, baseURL: url)
            }
        } else {
            guard let url = url,
                  let request = self.request(url: url, post: postMethod) else { return }
            self.webView.load(request)
        }
        
        self.numRequest = 0
    }
}

extension IMTWebVC: IMTNavigationController {
    func getController() -> BaseViewController {
        return self
    }
    
    func getTitleNavigation() -> String {
        return ""
    }
    
    func useLogoApp() -> Bool {
        return true
    }
}

extension IMTWebVC: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utils.showProgress()
        
        favoriteObjectHandler()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        vContainFavorite.isHidden = true
        //TODO: Action
        self.autoAction()
        
        //TODO: Reset prop
        cacheUrl = nil
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.endProgress()
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let request = navigationAction.request
            
            //TODO: Fix case lost asset when returning to the page all version
            WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0), completionHandler:{
                webView.load(request)
            })
        }
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        reset()
        let urlRequest = navigationAction.request.url?.absoluteString ?? ""
        let referer = navigationAction.request.value(forHTTPHeaderField: "Referer") ?? ""
        let asURL = urlRequest == referer
        
        if navigationAction.navigationType == .linkActivated && asURL {
            decisionHandler(.cancel)
            webView.load(navigationAction.request) //
        } else {
            currentUrl = navigationAction.request.url?.absoluteString
            if let delegate = delegate {
                delegate.IMTWebVC(self, orginalUrl: url, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
                redirectScripts = delegate.IMTWebVC(self, orginalUrl: url, redirectScript: navigationAction)
            } else {
                decisionHandler(.allow)
            }
        }
    }
    
    @available(iOS 15.0, *)
    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let accessK = self.currentUrl?.contains(TransactionLink.jockeyDirectory.url) ?? false
        
        if(accessK) {
            preferenceFeatureViewModel?.setCName(message)
            completionHandler()
        } else {
            let alertController = UIAlertController(title: "\(currentUrl ?? "") Page of", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                completionHandler()
            }))
            
            self.present(controller: alertController, animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "\(currentUrl ?? "") Page of", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler(true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completionHandler(false)
        }))
        
        self.present(controller: alertController, animated: true)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "\(currentUrl ?? "") Page of", message: prompt, preferredStyle: .alert)
        alertController .addTextField { textField in
            textField.text = defaultText
        }
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let textField = alertController.textFields?.first as? UITextField {
                completionHandler(textField.text)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completionHandler(nil)
        }))
        
        self.present(controller: alertController, animated: true)
    }
}
