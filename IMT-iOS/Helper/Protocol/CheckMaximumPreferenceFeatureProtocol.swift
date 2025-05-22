//
//  CheckMaximumPreferenceFeatureProtocol.swift
//  IMT-iOS
//
//  Created on 28/03/2024.
//
    

import Foundation

protocol CheckMaximumPreferenceFeatureProtocol {
    func getMaximumFromSystem(_ handler: @escaping(JInt))
    func getSysEnvMaximumCode() -> SysEnvCode
    func getMaximum() -> Int
    func setMaximum(_ value: Int)
}

extension CheckMaximumPreferenceFeatureProtocol {
    func getMaximumFromSystem(_ handler: @escaping(JInt)) {
        let networkManager = NetworkManager.share()
        networkManager.call(endpoint: .sysEnv, showLoading: false, completion: responseSysEnv)
        
        func responseSysEnv(_ response: ResponseSysEnv?, success: Bool) {
            let value: Int = Int(response?.getValueFromAysy01(key: getSysEnvMaximumCode()) ?? "") ?? 0
            setMaximum(value)
            handler(value)
        }
    }
}
