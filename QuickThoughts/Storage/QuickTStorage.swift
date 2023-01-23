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
    
    private func newBatchInsertRequest(with propertyList: [QuickTDecodable]) -> NSBatchInsertRequest
    {
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
    
    /// Fetch all the QuickTs from CoreData by specific User ID
    func fetchQuickTsCoreData(id: Int32) throws -> [QuickT]
    {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<QuickT>(entityName: "QuickT")
        fetchRequest.predicate = NSPredicate(format: "userId == %ld", id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \QuickT.id, ascending: true)]
        fetchRequest.fetchLimit = 50
        let quickTs = try context.fetch(fetchRequest)
        return quickTs
    }
    
    /// Fetch all the QuickTs from CoreData
    func fetchQuickTsCoreData() throws -> [QuickT]
    {
        /// TEMPORARY: Fetch Quickts from CoreData
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<QuickT>(entityName: "QuickT")
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \QuickT.id, ascending: true)]
        fetchRequest.fetchLimit = 50
        let quickTs = try context.fetch(fetchRequest)
        return quickTs
    }
    
    /// Deletes 1 Object Synchronously
    func deleteQuickT(objectID: NSManagedObject) {
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(objectID)
        /// Save the changes to the context
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    /// Delete all QuitckTs stored in coredata
    func deleteAll()
    {
        let viewContext = PersistenceController.shared.container.viewContext
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: QuickT.fetchRequest())

        do {
            try viewContext.execute(deleteRequest)
        } catch let error as NSError {
            // Handle the error
        }
    }
}
