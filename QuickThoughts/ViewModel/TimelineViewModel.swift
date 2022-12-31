//
//  TimelineViewModel.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import KeychainSwift
import CoreData

@MainActor
class TimelineViewModel: ObservableObject
{

    let keychain = KeychainSwift()
    
    @Published var timelineQuickTs: [QuickT] = []
    @Published var timelineUsers: [Int32:User] = [:]
    
    var auth = Authentication.shared
    
    struct Follows: Decodable {
        let idUserFollowed: Int
    }
    
    func fetchFollows() async throws
    {
        let url = URL(string: urlHost+"user/follows?id="+String(auth.getUser().id))!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        do
        {
            let decodedData = try JSONDecoder().decode([Follows].self, from: data)
            
            // TEMPORARY: This needs to use CoreData
            for follow in decodedData {
                auth.getUser().follows?.append(follow.idUserFollowed)
            }
            //auth.getUser().follows = decodedData

        } catch {
            throw ErrorHandler.invalidData
        }
    }
    
    func fetchTimelineQuickTs() async throws
    {
        do
        {
            try await fetchQuickTs(user: auth.getUser())
        }
        catch
        {
          print("ERROR RETREIVING TIMELINE QUICKTS:", error)
        }
        
        // TEMPORARY: Fetch Quickts Users from CoreData
        timelineUsers.removeAll()
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        // TEMPORARY: This needs to be redone to work with only 1 request to the server!!!!
        for quickt in timelineQuickTs.reversed()
        {
            var user: User? = nil
            // Check if user is already in CoreData Persistence
            fetchRequest.predicate = NSPredicate(format: "id == %ld", quickt.userId)
            
            do
            {
                user = try context.fetch(fetchRequest).first
                
                // If not, fetch the user from the backend
                if (user == nil)
                {
                    try await fetchUser(userId: quickt.userId)
                    
                    do
                    {
                       user = try context.fetch(fetchRequest).first
                    } catch {
                        print(error)
                    }
                }
                timelineUsers[quickt.id] = user
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchQuickTs(user: UserT) async throws
    {
        if (!auth.getUser().follows!.isEmpty)
        {
            guard let jsonFollows = try? JSONEncoder().encode(auth.getUser().follows) else {
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
            
            // TEMPORARY: Fetch Quickts from CoreData
            timelineQuickTs.removeAll()
            let context = PersistenceController.shared.container.viewContext
            let fetchRequest = NSFetchRequest<QuickT>(entityName: "QuickT")
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \QuickT.id, ascending: true)]
            fetchRequest.fetchLimit = 50
            let object = try context.fetch(fetchRequest)
            object.forEach { object in
                timelineQuickTs.append(object)
            }
        }
    }
    
    private func fetchUser(userId: Int32) async throws
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
            //timelineUsers[decodedData[0].id] = decodedData[0]
            print(decodedData[0])
            try await UserStorage.shared.importUsers(users: decodedData)
            
        } catch {
            throw ErrorHandler.fetchingUsers
        }
    }
}
