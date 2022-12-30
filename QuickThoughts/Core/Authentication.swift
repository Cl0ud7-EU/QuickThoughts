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
    @Published private var user: UserT
    @Published private var loggedStatus: Bool = false
    
    static let shared = Authentication()
    
    init()
    {
        user = UserT()
        setLoggedStatus()
        //setLoggedStatus()
    }
    func setLoggedStatus()
    {
        if keychain.get("id") != "" && keychain.get("id") != nil
        {
//            print (keychain.get("id"))
            let user = UserT(id: Int32(keychain.get("id")!)!, name: "Cl0ud7")
            setUser(user: user)
            loggedStatus = true
            
        }
        else
        {
            loggedStatus = false
        }
    }
    func getLoggedStatus() -> Bool
    {
        return loggedStatus
    }
    func setUser(user: UserT)
    {
        self.user = user
    }
    func getUser() -> UserT
    {
        return user
    }
}
