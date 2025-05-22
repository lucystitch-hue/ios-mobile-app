//
//  AppDelegate.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseCore
import AppsFlyerLib

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let isLogin = checkAutoLogin()
        loadScreen(isLogin: isLogin)
        addObserver()
        config(application)

        cacheLaunchNotification(launchOptions)
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        onChangeEmailFromUniversalLink(userActivity.webpageURL)
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //TODO: Support for base class
        Utils.postObserver(.stateApp, object: ApplicationState.background)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        //TODO: Check login when active
        checkLoginIfNeed()
        
        //TODO: Support for base class
        Utils.postObserver(.stateApp, object: ApplicationState.foreground)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UserManager.share().updateLastLoginDateIfNeed()
        Utils.postObserver(.stateApp, object: ApplicationState.active)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Utils.postObserver(.stateApp, object: ApplicationState.inactive)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        AppsFlyerLib.shared().registerUninstall(deviceToken)
    }
    
    @objc func didLogin(notification: Notification) {
        let isLogin = checkAutoLogin()
        let animate = notification.object as? Bool ?? true
        loadScreen(isLogin: isLogin, animate: animate)
    }
    
    @objc func sendLaunch() {
        AppsFlyerLib.shared().start()
    }
}

extension AppDelegate {
    private func config(_ application: UIApplication) {
        configIQKeyboard()
        configFirebase(application)
        configAppFlyers(application)
        configSwizzle()
    }
    
    private func addObserver() {
        Utils.onObserver(self, selector: #selector(didLogin), name: .didLoginSuccessfully)
        Utils.onObserver(self, selector: #selector(sendLaunch), name: .sendLaunch)
    }
    
    private func checkAutoLogin() -> Bool {
        return !UserManager.share().expired()
    }
    
    private func loadScreen(isLogin: Bool, animate: Bool = true) {
        if(!isLogin) {
            loadLogin(window, animate: animate)
        } else {
            loadMain(window)
        }
        window?.makeKeyAndVisible()
    }
    
    private func loadLogin(_ window: UIWindow?, animate: Bool) {
        let rootVC = showTerms() ? PopupTermVC() : LoginEmailVC(animate: animate)
        let controller = UINavigationController(rootViewController: rootVC)
        controller.isNavigationBarHidden = !showTerms()
        
        window?.rootViewController = controller
    }
    
    private func loadMain(_ window: UIWindow?) {
        /*---------------------------------------------------------------------------------------------*/
        if(UserManager.share().reLogin) {
            push()
        } else {
            window?.rootViewController = SplashVC()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.System.durationLoginAnimate) {
                IMTBiometricAuthentication().security(successCompletion: {
                    verifyEmail()
                }, failureCompletion: { [weak self] _ in
                    self?.loadLogin(window, animate: false)
                })
            }
        }
        /*---------------------------------------------------------------------------------------------*/
        
        func push() {
            pushMainNoUseAuthen()
        }
        
        func verifyEmail() {
            UserManager.share().checkLoginWhenChangeEmail { [weak self] (change, data) in
                if change == true {
                    if let email = data?.email.decrypt() {
                        //TODO: Cache new email when use biometric
                        UserManager.share().updateEmail(email)
                    }
                    self?.loadLogin(window, animate: false)
                    return
                }
                UserManager.share().user = data
                push()
            }
        }
        
        func pushMainUseAuthen() {
            let biometricAuthentication = IMTBiometricAuthentication()
            
            biometricAuthentication.scan { [weak self] in
                self?.window?.rootViewController = self?.getMainScreen()
            } failureCompletion: { message in
                let loginVC = LoginEmailVC(animate: true)
                let controller = UINavigationController(rootViewController: loginVC)
                controller.isNavigationBarHidden = true
                
                window?.rootViewController = controller
            }
        }
        
        func pushMainNoUseAuthen() {
            if let email = Utils.getUserDefault(key: .email) {
                UserManager.share().updateEmail(email)
            }
            self.window?.rootViewController = self.getMainScreen()
        }
    }
    
    private func getMainScreen() -> UIViewController {
        return MainVC()
    }
    
    private func configIQKeyboard() {
        IQKeyboardManager.shared.enable = true
    }
    
    private func configFirebase(_ application: UIApplication) {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    print(error?.localizedDescription as Any)
                }
            }
        )
    }
    
    private func configAppFlyers(_ application: UIApplication) {
        AppsFlyerLib.shared().appsFlyerDevKey = Utils.flyersAppDevKey()
        AppsFlyerLib.shared().appleAppID = Utils.appleAppId()
        AppsFlyerLib.shared().customerUserID
        
        NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("sendLaunch"), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    private func configSwizzle() {
        UIFont.swizzle()
    }
    
    private func showTerms() -> Bool {
        //Handle logic. If need
        return UserManager.share().showTerm()
    }
    
    private func cacheLaunchNotification(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] != nil {
            let dictionary = (launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String : Any])!
            let notification = FIRNotificationModel(dict: dictionary)
            Constants.incomingNotification = notification
        }
    }
    
    private func onChangeEmailFromUniversalLink(_ url: URL?) {
        Utils.postObserver(.openTabToRoot, object: IMTTab.home)
        
        Utils.loadUrl(url) {
            Utils.mainAsync {
                UserManager.share().checkLoginWhenChangeEmail {(change, data) in
                    
                    var message = ""
                    
                    if let change = change, change,
                       let data = data {
                        UserManager.share().user = data
                        UserManager.share().updateEmail(data.email)
                        message = .ShowToastString.changeMailSuccess
                    } else {
                        message = .ShowToastString.changeMailFailure
                    }
                    
                    Utils.mainAsyncAfter(1) {
                        Constants.lastController = HomeVC.nameOfClass
                        Utils.postObserver(.showErrorSystem, object: message)
                    }
                }
            }
        }
    }
    
    private func checkLoginIfNeed() {
        let isLogin = Constants.isLoginScreen
        if(!isLogin) {
            UserManager.share().checkLoginWhenChangeEmail { (change, data) in
                if let change = change, change {
                    guard let data = data else { return }
                    UserManager.share().updateEmail(data.email)
                    Utils.postLogout()
                }
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        NotificationManager.share().updateBadge()
        completionHandler([.alert])
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if(application.applicationState != .active) {
            NotificationManager.share().updateBadge()
        }
        completionHandler(.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response:UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        /*-------------------------------------------------------------------*/
        let expired = UserManager.share().expired()
        if(!expired) {
            guard let dict = response.notification.request.content.userInfo as? [String: Any] else { return }
            push(dict)
        }
        /*-------------------------------------------------------------------*/
        
        func push(_ dict: [String: Any]) {
            Constants.incomingNotification = FIRNotificationModel(dict: dict)
            guard let tab = Constants.incomingNotification?.getType()?.tab() else { return }
            Utils.pushDetailScreenAt(tab)
        }
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        Constants.System.fcmToken = fcmToken ?? ""
        Utils.postObserver(.receivedFCMToken, object: fcmToken ?? "")
    }
    
}
