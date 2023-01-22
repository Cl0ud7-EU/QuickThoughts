//
//  ProfilePicStorage.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData
import Combine

class ProfilePicStorage: NSObject, ObservableObject
{
    static let shared: ProfilePicStorage = ProfilePicStorage()
    
    func importPic(data: Data, idUser: Int32) async throws
    {
        let newProfilePic = ProfilePic(context: PersistenceController.shared.container.viewContext)
        newProfilePic.idUser = idUser
        newProfilePic.data = data
        newProfilePic.url = ""

        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
        }
    }
    
    func fetchProfilePicCoreData(id: Int32) throws -> ProfilePic?
    {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<ProfilePic>(entityName: "ProfilePic")
        fetchRequest.predicate = NSPredicate(format: "idUser == %ld", id)
        let profilePic = try context.fetch(fetchRequest).first
        return profilePic
    }
    
    /// Delete all ProfilePicStorage stored in coredata
    func deleteAll()
    {
        let viewContext = PersistenceController.shared.container.viewContext
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: ProfilePic.fetchRequest())

        do {
            try viewContext.execute(deleteRequest)
        } catch let error as NSError {
            // Handle the error
        }
    }
}
