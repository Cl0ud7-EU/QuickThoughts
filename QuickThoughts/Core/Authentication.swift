//
//  Authentication.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import KeychainSwift

class Authentication: ObservableObject {
    
    let keychain = KeychainSwift()
    @Published private var loggedStatus: Bool = false
    
    init() {
        setLoggedStatus()
    }
    func setLoggedStatus() {
        if keychain.get("id") != "" && keychain.get("id") != nil {
//            print (keychain.get("id"))
            loggedStatus = true
        }
        else {
            loggedStatus = false
        }
    }
    func getLoggedStatus() -> Bool {
        return loggedStatus
    }
}
