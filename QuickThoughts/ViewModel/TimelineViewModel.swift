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
class TimelineViewModel: ObservableObject {

    let keychain = KeychainSwift()
    
    @Published var timelineQuickTs: [QuickT] = []
    @Published var timelineUsers: [Int32:UserT] = [:]
    
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
        
        // TEMPORARY: This needs to be redone to work with only 1 request to the server!!!!
        for quickt in timelineQuickTs.reversed()
        {
            try await fetchUser(userId: quickt.userId)
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

                try await importQuickTs(quickts: timelineQuickTsD)
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
    
    private func importQuickTs(quickts: [QuickTDecodable]) async throws {
        guard !quickts.isEmpty else {return}
        
        let taskContext = PersistenceController.shared.container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importQuickTs"
        
        try await taskContext.perform {
            let batchInsertRequest = self.newBatchInsertRequest(with: quickts)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            throw ErrorHandler.coreDataError
        }
    }
    
    private func newBatchInsertRequest(with propertyList: [QuickTDecodable]) -> NSBatchInsertRequest {
        var index = 0
        let total = propertyList.count

        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: QuickT.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: propertyList[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }
    
    // Deletes 1 Object Synchronously
    func deleteQuickT(objectID: NSManagedObject) {
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(objectID)
        // Save the changes to the context
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
            let decodedData = try JSONDecoder().decode([UserT].self, from: data)
            timelineUsers[decodedData[0].id] = decodedData[0]

        } catch {
            throw ErrorHandler.coreDataError
        }
    }
    
}
