//
//  TimelineViewModel.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import UIKit
import CoreData
import KeychainSwift


@MainActor
class TimelineViewModel: ObservableObject
{

    let keychain = KeychainSwift()
    
    @Published var timelineQuickTs: [QuickT] = []
    @Published var timelineUsers: [Int32:User] = [:]
    @Published var image: UIImage?
    
    let auth = Authentication.shared
    
    struct Follows: Decodable {
        let idUserFollowed: Int32
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
            
            /// TEMPORARY: This needs to use CoreData
            auth.getUser().follows?.removeAll()
            for follow in decodedData {
                if auth.getUser().follows != nil {
                    auth.getUser().follows?.append(follow.idUserFollowed)
                } else {
                    auth.getUser().follows = [follow.idUserFollowed]
                }
            }
            /// TEMPORARY
//            do {
//                try PersistenceController.shared.container.viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
            //auth.getUser().follows = decodedData

        } catch {
            throw ErrorHandler.invalidData
        }
    }
    
    func fetchQuickTs() async throws
    {
        do
        {
            try await QuickTManager.shared.fetchTimelineQuickTs(user: auth.getUser())
        } catch {
            throw ErrorHandler.fetchQuickTs
        }
        do
        {
            try timelineQuickTs = QuickTStorage.shared.fetchQuickTsCoreData()
            
        } catch {
            throw ErrorHandler.coreDataError
        }
        
        /// TEMPORARY: This needs to be redone to work with only 1 request to the server!!!!
        timelineUsers.removeAll()
        for quickt in timelineQuickTs.reversed()
        {
            /// Check if user is already in CoreData Persistence
            var user: User? = nil
            do
            {
                user = try UserStorage.shared.fetchUserCoreData(id: quickt.userId)
                
                /// If not, fetch the user from the backend
                if (user == nil)
                {
                    try await UserManager.shared.fetchUser(userId: quickt.userId)
                    
                    do
                    {
                        user = try UserStorage.shared.fetchUserCoreData(id: quickt.userId)
                    } catch {
                        print(error)
                    }
                }
                
                /// Check if ProfilePic is already in CoreData Persistence
                var image: ProfilePic? = nil
                do
                {
                    image = try ProfilePicStorage.shared.fetchProfilePicCoreData(id: quickt.userId)
                    
                    /// If not, fetch the ProfilePic from the backend
                    if (image == nil)
                    {
                        try await ImageManager.shared.fetchProfilePic(user: user!)
                        
                        do
                        {
                            image = try ProfilePicStorage.shared.fetchProfilePicCoreData(id: quickt.userId)
                        } catch {
                            print(error)
                        }
                    }
                    user?.profilePic = image
                } catch {
                    print(error)
                }
                timelineUsers[quickt.userId] = user
                /// END
            } catch {
                print(error)
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
            try await UserStorage.shared.importUsers(users: decodedData)
        } catch {
            throw ErrorHandler.fetchingUsers
        }
    }
    
    func downloadImage(idUser: Int32) async throws {

        let url = URL(string: urlHost+"pic")!

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.downloadingImage
        }
        
        do
        {
            try await insertPic(data: data, idUser: idUser)
        } catch {
            throw ErrorHandler.invalidData
        }
    }
    
    func base64DataToImage(_ base64Data: Data) -> UIImage? {
        guard let imageData = Data(base64Encoded: base64Data) else { return nil }
        return UIImage(data: imageData)
    }
    
    func insertPic(data: Data, idUser: Int32) async throws
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
}
