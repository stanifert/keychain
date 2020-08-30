//
//  User.swift
//  Keychain
//
//  Created by Travis W. Stanifer on 8/29/20.
//

import Foundation

struct User: Codable {
    var id: String
    var name: String?
    var email: String
    var password: String
}
