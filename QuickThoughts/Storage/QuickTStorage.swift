//
//  QuickTStorage.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData

class QuickTStorage
{
    static let shared: QuickTStorage = QuickTStorage()
    
    func importQuickTs(quickts: [QuickTDecodable]) async throws {
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
}
