//
//  KeychainAccessOption.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import Foundation

public enum KeychainAccessOption: CaseIterable {
    case whenUnlocked
    case thisDeviceOnly
}


internal extension KeychainAccessOption {
    var attribute: CFString {
        switch self {
        case .whenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case .thisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        }
    }
}
