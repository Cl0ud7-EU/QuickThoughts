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
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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
}
