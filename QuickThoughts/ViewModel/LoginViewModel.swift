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

    func logIn() async throws //-> UserT
    {
        let url = URL(string: urlHost+"user?id="+username)!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        do
        {
            let decodedData = try JSONDecoder().decode([UserT].self, from: data)
            //user = UserT(id: decodedData[0].id, name: decodedData[0].name)
      
            // TEMPORARY: This user.id stuff needs to be changed to a key or something like that!!!!
            //keychain.set(String(user.id), forKey: "id")
            keychain.set(String(decodedData[0].id), forKey: "id")
        } catch
        {
            throw ErrorHandler.invalidData
        }
        //return user
    }
}
