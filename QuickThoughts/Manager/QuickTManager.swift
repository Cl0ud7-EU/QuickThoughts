//
//  QuickTManager.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation

class QuickTManager
{
    static let shared: QuickTManager = QuickTManager()
    
    /// Fetch QuickTs from database and save them in CoreData
    func fetchProfileQuickTs(user: User) async throws
    {
        let url = URL(string: urlHost+"user/quickTs?id="+String(user.id))!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }

        do
        {
            let timelineQuickTsD = try JSONDecoder().decode([QuickTDecodable].self, from: data)

            try await QuickTStorage.shared.importQuickTs(quickts: timelineQuickTsD)
        } catch {
            print(error)
            throw ErrorHandler.invalidData
        }
    }
    
    func fetchTimelineQuickTs(user: User) async throws
    {
        if (user.follows != nil)
        {
            guard let jsonFollows = try? JSONEncoder().encode(user.follows) else {
                throw ErrorHandler.jsonEncoderError
            }
            
            let url = URL(string: urlHost+"user/timelineQuickTs")!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = jsonFollows
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw ErrorHandler.invalidServerResponse
            }
            
            do
            {
                let timelineQuickTsD = try JSONDecoder().decode([QuickTDecodable].self, from: data)

                try await QuickTStorage.shared.importQuickTs(quickts: timelineQuickTsD)
            } catch {
                print(error)
                throw ErrorHandler.invalidData
            }
        }
    }
}
