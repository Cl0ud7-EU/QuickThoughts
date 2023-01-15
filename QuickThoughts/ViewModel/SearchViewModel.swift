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
    @Published var searchResults: [UserDecodable] = []
    @Published var userNameSearch = ""
    
    func searchUsers()
    {
        let url = URL(string: urlHost+"searchUser")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        let json: [String: Any] = [
            "searchTerm": userNameSearch
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let searchResults = try? JSONDecoder().decode([UserDecodable].self, from: data)

                DispatchQueue.main.async {
                    self.searchResults = searchResults ?? []
                }
            }
        }.resume()
    }
}
