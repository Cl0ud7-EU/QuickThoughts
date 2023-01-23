//
//  SearchViewModel.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation


@MainActor
class SearchViewModel: ObservableObject
{
    @Published var searchResults: [User] = []
    @Published var userNameSearch = ""
    
    func searchUsers() async throws
    {
        
        let url = URL(string: urlHost+"searchUser?name="+userNameSearch)!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        do
        {
            let decodedData = try JSONDecoder().decode([UserDecodable].self, from: data)
            try await UserStorage.shared.importUsers(users: decodedData)
            do
            {
                try searchResults = UserStorage.shared.fetchUsersByNameCoreData(name: userNameSearch)
                
            } catch {
                throw ErrorHandler.coreDataError
            }
            
        } catch {
            throw ErrorHandler.fetchingUsers
        }
//                DispatchQueue.main.async {
//                    self.searchResults = searchResults ?? []
//                }
    }
    
}
