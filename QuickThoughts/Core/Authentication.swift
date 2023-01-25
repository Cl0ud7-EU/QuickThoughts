//
//  Authentication.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import KeychainSwift

@MainActor
class Authentication: ObservableObject {
    
    let keychain = KeychainSwift()
    //private var user: User?
    private var user = User.preview
    @Published private var loggedStatus: Bool = false
    
    static let shared = Authentication()
    
    init()
    {
        do {
            try setLoggedStatus()
        }
        catch {
            print("AUTH ERROR:", error)
        }
    }
    func setLoggedStatus() throws
    {
        if keychain.get("id") != "" && keychain.get("id") != nil
        {
            guard let id = Int32(keychain.get("id")!) else {
                throw ErrorHandler.loginError }
            guard let user = try UserStorage.shared.fetchUserCoreData(id: id)
            else { throw ErrorHandler.coreDataError }
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
    func setUser(user: User)
    {
        self.user = user
    }
    func getUser() -> User
    {
        return user
    }
}
