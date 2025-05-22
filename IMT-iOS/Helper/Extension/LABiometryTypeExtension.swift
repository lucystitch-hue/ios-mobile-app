//
//  LABiometryTypeExtension.swift
//  IMT-iOS
//
//  Created by dev on 20/08/2023.
//

import Foundation
import LocalAuthentication

extension LABiometryType {
    func convert() -> BiometricAuthenticationStyle {
        switch self {
        case .faceID:
            return .faceId
        case .touchID:
            return .touchId
        case .none:
            return .none
        @unknown default:
            return .none
        }
    }
}
