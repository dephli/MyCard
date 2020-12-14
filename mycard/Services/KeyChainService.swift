//
//  KeyChainService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/13/20.
//

import Foundation
import Security
import KeychainAccess

struct KeychainService {
    let keychain = Keychain(service: "com.space-jonin.mycard")
    
    var token: String? {
        get {
            if let value = keychain["token"] {
                return value
            }
            return nil
        }
        set {
            keychain["token"] = newValue
        }
    }
}
