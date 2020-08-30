//
//  KeychainError.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import Foundation

enum KeychainError: Error {
    case saveFailure
}


extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        return localizedDescription
    }
    
    public var localizedDescription: String {
        return "Unable to save object to keychain."
    }
}
