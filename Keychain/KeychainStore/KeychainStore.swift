//
//  Keychain.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import Foundation
import Security

open class KeychainStore<T: Codable> {

    public let serviceName: String
    public let uniqueID: String
    open var encoder = JSONEncoder()
    open var decoder = JSONDecoder()

    required public init(serviceName: String = Bundle.main.bundleIdentifier ?? "DefaultService", uniqueID: String) {
        self.serviceName = serviceName
        self.uniqueID = uniqueID
    }

    // Save
    open func save(_ object: T, withAccessibilityOption option: KeychainAccessOption = .whenUnlocked) throws {
        let data = try encoder.encode(generateDict(for: object))
        var query = generateQuery(accessOption: option)
        query[Keys.valueData] = data
        
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            return
        case errSecDuplicateItem:
            try update(object, withAccessOption: option)
        default:
            throw KeychainError.saveFailure
        }
    }
    
    
    // Update
    open func update(_ object: T, withAccessOption option: KeychainAccessOption = .whenUnlocked) throws {
        let data = try encoder.encode(generateDict(for: object))
        var query = generateQuery(accessOption: option)
        query[Keys.valueData] = data
        
        let updateQuery = [Keys.valueData: data]
        let status = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
        switch status {
        case errSecSuccess:
            return
        default:
            throw KeychainError.saveFailure
        }
    }
    
    
    // Get object
    open func object(accessOption: KeychainAccessOption = .whenUnlocked) -> T? {
        var query = generateQuery(accessOption: accessOption)
        query[Keys.matchLimit] = kSecMatchLimitOne
        query[Keys.returnData] = kCFBooleanTrue
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data = result as? Data else {
            return nil
        }
        
        guard let dict = try? decoder.decode([String: T].self, from: data) else {
            return nil
        }
        
        return extractObject(from: dict)
    }
    
    
    // Delete
    open func delete(accessOption option: KeychainAccessOption = .whenUnlocked) {
        let query = generateQuery(accessOption: option)
        SecItemDelete(query as CFDictionary)
    }
    
}



// Helpers
extension KeychainStore {
    
    var key: String {
        return "\(uniqueID)-single-object"
    }
    
    
    func generateDict(for object: T) -> [String: T] {
        return [key: object]
    }
    
    
    func extractObject(from dict: [String: T]) -> T? {
        return dict[key]
    }
    
    
    func generateQuery(accessOption: KeychainAccessOption) -> [String: Any] {
        var query: [String: Any] = [Keys.class: kSecClassGenericPassword]
        query[Keys.attrService] = serviceName
        query[Keys.attrAccessible] = accessOption.attribute
        
        let encodedIdentifier = uniqueID.data(using: .utf8)
        query[Keys.attrGeneric] = encodedIdentifier
        query[Keys.attrAccount] = encodedIdentifier
        
        return query
    }
}


// Keys
extension KeychainStore {
    
    struct Keys {
        
        static var matchLimit: String {
            return kSecMatchLimit as String
        }
        
        static var returnData: String {
            return kSecReturnData as String
        }
        
        static var valueData: String {
            return kSecValueData as String
        }
        
        static var attrAccessible: String {
            return kSecAttrAccessible as String
        }
        
        static var `class`: String {
            return kSecClass as String
        }
        
        static var attrService: String {
            return kSecAttrService as String
        }
        
        static var attrGeneric: String {
            return kSecAttrGeneric as String
        }
        
        static var attrAccount: String {
            return kSecAttrAccount as String
        }
    }
    
}
