//
//  UserStorage.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData
import Combine

class UserStorage: NSObject, ObservableObject {
    var users = CurrentValueSubject<[User], Never>([])
    private let userFetchController: NSFetchedResultsController<User>
    
    static let shared: UserStorage = UserStorage()
    
    private override init()
    {
        userFetchController = NSFetchedResultsController(
            fetchRequest: User.fetchRequest(),
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        super.init()
        
        userFetchController.delegate = self
    }
    
    
}

extension UserStorage: NSFetchedResultsControllerDelegate
{
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let users = controller.fetchedObjects as? [User] else
        {
            return
        }
        self.users.value = users
    }
}
