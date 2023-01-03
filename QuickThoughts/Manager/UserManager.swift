//
//  UserManager.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation

class UserManager
{
    static let shared: UserManager = UserManager()
    
    /// Fetch User from database and save it in CoreData
    func fetchUser(userId: Int32) async throws
    {
        let url =  URL(string: urlHost+"user?id="+String(userId))!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        do
        {
            let decodedData = try JSONDecoder().decode([UserDecodable].self, from: data)
            
            try await UserStorage.shared.importUsers(users: decodedData)
        } catch {
            throw ErrorHandler.fetchingUsers
        }
    }
}
