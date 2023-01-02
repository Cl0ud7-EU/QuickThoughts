//
//  UserStorage.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData
import Combine

class UserStorage: NSObject, ObservableObject
{

    static let shared: UserStorage = UserStorage()
    
    func importUsers(users: [UserDecodable]) async throws
    {
        guard !users.isEmpty else {return}
        
        let taskContext = PersistenceController.shared.container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importUsers"
        
        try await taskContext.perform {
            let batchInsertRequest = self.newBatchInsertRequest(with: users)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            throw ErrorHandler.coreDataError
        }
    }
    
    private func newBatchInsertRequest(with propertyList: [UserDecodable]) -> NSBatchInsertRequest
    {
        var index = 0
        let total = propertyList.count

        // Provide one dictionary at a time when the closure is called.
        let batchInsertRequest = NSBatchInsertRequest(entity: User.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: propertyList[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }
}
