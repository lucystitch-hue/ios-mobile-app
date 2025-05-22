//
//  NetworkManager.swift
//  IMT-iOS
//
//  Created by dev on 06/03/2023.
//

import Foundation
import Alamofire
import SwiftyJSON
import SWXMLHash

class NetworkManager {
    private static var networkManager: NetworkManager!
    
    private var session: Session!
    
    init() {
        let evaluators: [String: ServerTrustEvaluating] = [
            NetworkManager.domain: DisabledTrustEvaluator(),
            NetworkManager.domainPostCode: DisabledTrustEvaluator()
        ]
        
        let manager = ServerTrustManager(evaluators: evaluators)
        self.session = Session(serverTrustManager: manager)
    }
    
    static func share() -> NetworkManager {
        if(networkManager == nil) {
            networkManager = NetworkManager()
        }
        
        return networkManager
    }
}

//MARK: Public
extension NetworkManager {
    func call<R: BaseResponse>(endpoint: EndPoint, showLoading: Bool = true, showError: Bool = true, completion:@escaping((_ response: R?, _ sucess: Bool) -> Void)) {
        
        self.availableNetwork(endpoint: endpoint, showLoading: showLoading) { [weak self](showLoading, url) in
            self?.session.request(url, method: endpoint.method(), parameters: endpoint.param(), encoding: endpoint.encoding(), headers:endpoint.header()).validate().responseDecodable(of: R.self) { [weak self] response in
                self?.validateCode(response: response, showError: showError, completion: { data in
                    print("### response: \(response)")
                    completion(response.value, true)
                    
                    if(showLoading && !Utils.hasIncommingNotification()) {
                        Utils.hideProgress()
                    }
                })
            }
        } unavailable: { showLoading in
            completion(nil, false)
            if(!Utils.hasIncommingNotification()) {
                Utils.hideProgress()
            }
        }
    }
    
    func call<R: JSONModel>(endpoint: EndPoint, showLoading: Bool = true, showError: Bool = true, completion:@escaping((_ response: [R]?, _ success: Bool) -> Void)) {
        
        self.availableNetwork(endpoint: endpoint, showLoading: showLoading) { [weak self](showLoading, url) in
            self?.session.request(url, method: endpoint.method(), parameters: endpoint.param(), headers:endpoint.header()).validate().responseData { response in
                self?.validateCode(response: response, showError: showError, completion: { data in
                    var items: [R] = []
                    if let data = data {
                        let jsons = JSON(data)
                        items = jsons.arrayValue.map{ return R(json: $0)}
                    }
                    
                    completion(items, true)
                })
                
                if(showLoading && !Utils.hasIncommingNotification()) {
                    Utils.hideProgress()
                }
            }
        } unavailable: { showLoading in
            completion(nil, false)
        }
    }
    
    func call<R: JSONModel>(endpoint: EndPoint, showLoading: Bool = true, showError: Bool = true, completion:@escaping((_ response: R?, _ success: Bool) -> Void)) {
        
        self.availableNetwork(endpoint: endpoint, showLoading: showLoading) { [weak self](showLoading, url) in
            self?.session.request(url, method: endpoint.method(), parameters: endpoint.param(), headers:endpoint.header()).validate().responseData { [weak self] response in
                self?.validateCode(response: response, showError: showError, completion: { data in
                    if let data = data {
                        let json = JSON(data)
                        completion(R(json: json), true)
                    } else {
                        completion(nil, false)
                    }
                });
                
                if(showLoading && !Utils.hasIncommingNotification()) {
                    Utils.hideProgress()
                }
            }
        } unavailable: { showLoading in
            completion(nil, false)
        }
    }
    
    func call(endpoint: EndPoint, showLoading: Bool = true, showError: Bool = true, completion:@escaping((_ response: JSON?, _ success: Bool) -> Void)) {
        
        self.availableNetwork(endpoint: endpoint, showLoading: showLoading) { (showLoading, url) in
            AF.request(url, method: endpoint.method(), parameters: endpoint.param(), encoding: endpoint.encoding(), headers:endpoint.header()).validate().responseData { [weak self] response in
                self?.validateCode(response: response, showError: showError, completion: { data in
                    if let data = data {
                        let json = JSON(data)
                        completion(json, true)
                    } else {
                        completion(nil, false)
                    }
                })
                
                if(showLoading && !Utils.hasIncommingNotification()) {
                    Utils.hideProgress()
                }
            }
        } unavailable: { showLoading in
            completion(nil, false)
        }
    }
    
    func callXML(endpoint: EndPoint, showLoading: Bool = true, showError: Bool = true, completion:@escaping((_ xlm: XMLIndexer?, _ success: Bool) -> Void)) {
        
        self.availableNetwork(endpoint: endpoint, showLoading: showLoading) { (showLoading, url) in
            AF.request(url, method: endpoint.method(), parameters: endpoint.param(), headers:endpoint.header()).validate().responseData { [weak self] response in
                self?.validateCode(response: response, showError: showError, completion: {data in
                    if let data = data {
                        let xml = XMLHash.parse(data)
                        completion(xml, true)
                    } else {
                        completion(nil, false)
                    }
                })
                
                if(showLoading && !Utils.hasIncommingNotification()) {
                    Utils.hideProgress()
                }
            }
        } unavailable: { showLoading in
            completion(nil, false)
        }
    }
    
}

//MARK: Private
extension NetworkManager {
    private func getURL(_ endpoint: EndPoint) -> String {
        
        let baseURL = getBaseURL(endpoint)
        let url = "\(baseURL)/\(endpoint.path())"
        
        return url
    }
    
    private func getBaseURL(_ endpoint: EndPoint) -> String {
        switch endpoint {
        case .news:
            return "\(NetworkManager.baseURLRSS)"
        case .holiday:
            return "\(NetworkManager.baseURLHoliday)"
        case .login,
                .checkMail,
                .signup,
                .checkOTP,
                .checkOTPUser,
                .sendOTP,
                .updateUser,
                .deleteUser,
                .changePassword,
                .resetPassword,
                .requestChangeEmail,
                .updateEmail,
                .createAndUpdateUserIPat,
                .ipatList,
                .notificationsCount,
                .notificationList,
                .notificationRead,
                .notificationDetail,
                .updateSetting,
                .setting,
                .urgentNotice,
                .getUser,
                .registFCMToken,
                .dropFCMToken,
                .checkChangePass,
                .checkChangeEmail,
                .getLatestEventDate:
            return "\(NetworkManager.baseURLMain)"
        case .postCode:
            return "\(NetworkManager.baseURLPostCode)"
        default:
            return "\(NetworkManager.baseURL)"
        }
    }
    
    private func availableNetwork(endpoint: EndPoint, showLoading: Bool, available: @escaping((_ showLoading: Bool, _ url: String) -> Void), unavailable: (JBool)? = nil) {
        let connect = (NetworkReachabilityManager.default?.isReachable)!;
        
        if(connect) {
            let url = getURL(endpoint)
            print("### url: \(url) \nparam: \(endpoint.param())")
            
            if(showLoading) {
                Utils.showProgress()
            }
            
            available(showLoading, url)
        } else {
            Utils.postObserver(.showErrorSystem, object: String.error.networkNotConnect)
            unavailable?(showLoading)
            
            if(showLoading && !Utils.hasIncommingNotification()) {
                Utils.hideProgress()
            }
        }
        
    }
    
    private func validateCode<T>(response: AFDataResponse<T>, showError: Bool = true, completion: @escaping((Data?) -> Void)) {
        //Handle logic
        if let data = response.data {
            if let statusCode = response.response?.statusCode,
               statusCode != StatusCodeNetwork.code200.rawValue,
               statusCode != StatusCodeNetwork.code400.rawValue {
                if let object = StatusCodeNetwork(rawValue: statusCode),
                   let message = object.message() {
                    if (showError) {
                        Utils.postObserver(.showErrorSystem, object: message)
                    }
                    
                    if(!Utils.hasIncommingNotification()) {
                        Utils.hideProgress()
                    }
                    
                    completion(nil)
                    return
                } else {
                    if (showError) {
                        let message = response.error?.localizedDescription ?? "Error"
                        Utils.postObserver(.showErrorSystem, object: message)
                    }
                    
                    if(!Utils.hasIncommingNotification()) {
                        Utils.hideProgress()
                    }
                    
                    completion(nil)
                    return
                }
            }
            
            completion(data)
        } else {
            //Handle show error
            if (showError) {
                if let statusCode = response.response?.statusCode {
                    if let object = StatusCodeNetwork(rawValue: statusCode),
                       let message = object.message() {
                        Utils.postObserver(.showErrorSystem, object: message)
                    }
                } else {
                    let message = String.error.networkNotConnect
                    Utils.postObserver(.showErrorSystem, object: message)
                }
            }
            
            if(!Utils.hasIncommingNotification()) {
                Utils.hideProgress()
            }
            
            completion(nil)
        }
    }
}

//MARK: Utils
extension NetworkManager {
    //MARK: Protocol
    static let `protocol`: String = {
        guard let strDomain = Utils.infoDict["PROTOCOL"] as? String else {
            fatalError("PROTOCOL is not found")
        }
        return strDomain
    }()
    
    static let protocolRSS: String = {
        guard let strDomain = Utils.infoDict["PROTOCOL_RSS"] as? String else {
            fatalError("PROTOCOL RSS is not found")
        }
        return strDomain
    }()
    
    static let protocolHoliday: String = {
        guard let strDomain = Utils.infoDict["PROTOCOL_HOLIDAY"] as? String else {
            fatalError("PROTOCOL HOLIDAY is not found")
        }
        return strDomain
    }()
    
    static let protocolMain: String = {
        guard let strDomain = Utils.infoDict["PROTOCOL_MAIN"] as? String else {
            fatalError("PROTOCOL MAIN is not found")
        }
        return strDomain
    }()
    
    static let protocolPostCode: String = {
        guard let strDomain = Utils.infoDict["PROTOCOL_POSTCODE"] as? String else {
            fatalError("PROTOCOL POSTCODE is not found")
        }
        return strDomain
    }()
    
    //MARK: Domain
    static let domain: String = {
        guard let strDomain = Utils.infoDict["DOMAIN"] as? String else {
            fatalError("DOMAIN is not found")
        }
        return strDomain
    }()
    
    static let domainRSS: String = {
        guard let strDomain = Utils.infoDict["DOMAIN_RSS"] as? String else {
            fatalError("DOMAIN RSS is not found")
        }
        return strDomain
    }()
    
    static let domainHoliday: String = {
        guard let strDomain = Utils.infoDict["DOMAIN_HOLIDAY"] as? String else {
            fatalError("DOMAIN HOLIDAY is not found")
        }
        return strDomain
    }()
    
    static let domainMain: String = {
        guard let strDomain = Utils.infoDict["DOMAIN_MAIN"] as? String else {
            fatalError("DOMAIN MAIN is not found")
        }
        return strDomain
    }()
    
    static let domainPostCode: String = {
        guard let strDomain = Utils.infoDict["DOMAIN_POSTCODE"] as? String else {
            fatalError("DOMAIN POSTCODE is not found")
        }
        return strDomain
    }()
    
    //MARK: URL
    static let baseURL: String = {
        guard let strUrl = Utils.infoDict["BASE_URL"] as? String else {
            fatalError("BASE_URL is not found")
        }
        return strUrl
    }()
    
    static let baseURLRSS: String = {
        guard let strUrl = Utils.infoDict["BASE_URL_RSS"] as? String else {
            fatalError("BASE_URL_RSS is not found")
        }
        return strUrl
    }()
    
    static let baseURLHoliday: String = {
        guard let strUrl = Utils.infoDict["BASE_URL_HOLIDAY"] as? String else {
            fatalError("BASE_URL_HOLIDAY is not found")
        }
        return strUrl
    }()
    
    static let baseURLMain: String = {
        guard let strUrl = Utils.infoDict["BASE_URL_MAIN"] as? String else {
            fatalError("BASE_URL_MAIN is not found")
        }
        return strUrl
    }()
    
    static let baseURLPostCode: String = {
        guard let strUrl = Utils.infoDict["BASE_URL_POSTCODE"] as? String else {
            fatalError("BASE_URL_POSTCODE is not found")
        }
        return strUrl
    }()
}
