//
//  ProfileViewModel.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData
import UIKit

@MainActor
class ProfileViewModel: ObservableObject
{
    
    @Published var profileQuickTs: [QuickT] = []
    @Published var profileTimelineUsers: [Int32:User] = [:]
    @Published var imageProfile: UIImage?
    @Published var image: UIImage?
    
    let auth = Authentication.shared
    
    struct Follows: Decodable {
        let idUserFollowed: Int
    }
    var timelineUsersIds = Set<Int>()
    
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
                auth.getUser().follows?.append(follow.idUserFollowed)
            }
            //auth.getUser().follows = decodedData

        } catch {
            throw ErrorHandler.invalidData
        }
    }
    
    func fetchQuickTs() async throws
    {
        do
        {
            try await QuickTManager.shared.fetchProfileQuickTs(user: auth.getUser())
            
        } catch {
            throw ErrorHandler.fetchQuickTs
        }
        do
        {
            try profileQuickTs = QuickTStorage.shared.fetchQuickTsCoreData(id: auth.getUser().id)
            
        } catch {
            throw ErrorHandler.coreDataError
        }

        
        /// TEMPORARY: This needs to be redone to work with only 1 request to the server!!!!
        profileTimelineUsers.removeAll()
        for quickt in profileQuickTs.reversed()
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
                        try await ImageManager.shared.fetchProfilePic(idUser: quickt.userId)
                        
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
                profileTimelineUsers[quickt.userId] = user
                /// END
            } catch {
                print(error)
            }
        }
    }
    func getPic() async throws
    {
        /// Download ProfilePics if not already saved in CoreData
        let userId = auth.getUser().id
        var image: ProfilePic? = nil
        do
        {
            image = try ProfilePicStorage.shared.fetchProfilePicCoreData(id: userId)
            
            /// If not, fetch the user from the backend
            if (image == nil)
            {
                try await ImageManager.shared.fetchProfilePic(idUser: userId)
                
                do
                {
                    image = try ProfilePicStorage.shared.fetchProfilePicCoreData(id: userId)
                } catch {
                    print(error)
                }
            }
            self.imageProfile = base64DataToImage(image!.data)
        } catch {
            print(error)
        }
    }
}
