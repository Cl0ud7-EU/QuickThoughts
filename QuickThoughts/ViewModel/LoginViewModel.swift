//
//  LoginViewModel.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData
import KeychainSwift


//Local
let urlHost = "http://localhost:3001/";


class LoginViewModel: ObservableObject
{
    
    let keychain = KeychainSwift()
    
    @Published var username: String = ""
    @Published var password: String = ""

    let request = NSFetchRequest<User>(entityName: "User")
    
    var auth = Authentication.shared
    init()
    {
        username = keychain.get("username") ?? ""
        password = keychain.get("password") ?? ""
    }

    func logIn() async throws
    {
        let url = URL(string: urlHost+"user?id="+username)!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        do
        {
            let decodedData = try JSONDecoder().decode([UserDecodable].self, from: data)
            if  (decodedData.count > 0) {
                try await UserStorage.shared.importUsers(users: decodedData)
                
                do
                {
                    let user = try UserStorage.shared.fetchUserCoreData(id: decodedData[0].id)
                    keychain.set(String(decodedData[0].id), forKey: "id")
                    keychain.set(String(decodedData[0].id), forKey: "username")
                } catch {
                    throw ErrorHandler.coreDataError
                }
            }
        } catch {
            throw ErrorHandler.invalidData
        }
    }
}
