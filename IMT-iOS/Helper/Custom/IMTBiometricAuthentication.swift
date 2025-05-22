//
//  IMTFaceIDAuthentication.swift
//  IMT-iOS
//
//  Created by dev on 17/08/2023.
//

import Foundation
import LocalAuthentication

protocol IMTBiometricAuthenticationProtocol {
    func scan(successCompletion:@escaping(JVoid), failureCompletion: (JBiometricError)?)
    func security(successCompletion:@escaping(JVoid), failureCompletion: (JBiometricError)?)
}

extension IMTBiometricAuthenticationProtocol {
    func scan(successCompletion:@escaping(JVoid), failureCompletion: (JBiometricError)? = nil) {
        let context = LAContext()
        var error: NSError?
        
        //TODO: Handle logic
        if (context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)) {
            let reason = "Identifier yourself"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                if(success) {
                    Utils.mainAsync {
                        Utils.setUserDefault(value: "true", forKey: .didUseBiomatricAuthentication)
                        successCompletion()
                    }
                } else {
                    Utils.mainAsync {
                        guard let authenticationError = authenticationError as? LAError else { return }
                        let errorMessage = getErrorMessage(authenticationError)
                        failureCompletion?(errorMessage)
                    }
                }
            }
        } else {
            Utils.mainAsync {
                let errorMessage = (errorCode: LAError.biometryNotAvailable, message: "The app biometric authentication isn't avaiable")
                failureCompletion?(errorMessage)
            }
        }
    }
    
    func security(successCompletion:@escaping(JVoid), failureCompletion: (JBiometricError)? = nil) {
        let can = IMTBiometricAuthentication.can()
        
        if(can) {
            if(hasStrengthenSecurity()) {
                self.scan(successCompletion: successCompletion, failureCompletion: failureCompletion)
            } else {
                successCompletion()
            }
        } else {
            UserManager.share().disableBiometricAuthenticationFromSetting()
            UserManager.share().disableEnhanceSecuritySetting()
            successCompletion()
        }
    }
    
    private func getErrorMessage(_ error:LAError) -> JMBiometricError {
        var message = ""
        switch error.code {
        case LAError.authenticationFailed:
            message = "Authentication Failed."
            break
        case LAError.userCancel:
            message = "User Cancelled."
            break
        case LAError.userFallback:
            message = "Fallback authentication mechanism selected."
            break
        case LAError.touchIDNotEnrolled:
            message = "Touch ID is not enrolled."
            break
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device."
            break
        case LAError.systemCancel:
            message = "System Cancelled."
            break
        default:
            message = error.localizedDescription
        }
        
        return (error.code, message)
    }
    
    private func hasStrengthenSecurity() -> Bool {
        let value = UserManager.share().didUseEnhanceSecuritySetting()
        return value
    }
}

class IMTBiometricAuthentication: IMTBiometricAuthenticationProtocol {
        
    static public func getStyle() -> BiometricAuthenticationStyle {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Capture these recoverable error thru Crashlytics
            return .none
        }
        
        if #available(iOS 11.0, *) {
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchId
            case .faceID:
                return .faceId
            @unknown default:
                return .none
            }
        } else {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchId : .none
        }
    }
    
    static public func can() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        //TODO: Handle logic
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
}
