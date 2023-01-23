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
    let user: User
    @Published var profileQuickTs: [QuickT] = []
    @Published var profileTimelineUsers: [Int32:User] = [:]
    @Published var imageProfile: UIImage?
    
    let auth = Authentication.shared
    
    init(user: User)
    {
        self.user = user;
    }
    
    struct Follows: Decodable {
        let idUserFollowed: Int32
    }
    var timelineUsersIds = Set<Int>()
    
    func fetchFollows() async throws
    {
        let url = URL(string: urlHost+"user/follows?id="+String(user.id))!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.invalidServerResponse
        }
        
        do
        {
            let decodedData = try JSONDecoder().decode([Follows].self, from: data)
            
            /// TEMPORARY: This needs to use CoreData
            user.follows?.removeAll()
            for follow in decodedData {
                user.follows?.append(follow.idUserFollowed)
            }
            //user.follows = decodedData

        } catch {
            throw ErrorHandler.invalidData
        }
    }
    
    func fetchQuickTs() async throws
    {
        do
        {
            try await QuickTManager.shared.fetchProfileQuickTs(user: user)
        } catch {
            throw ErrorHandler.fetchQuickTs
        }
        do
        {
            try profileQuickTs = QuickTStorage.shared.fetchQuickTsCoreData(id: user.id)
            
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
        let userId = user.id
        var image: ProfilePic? = nil
        do
        {
            image = try ProfilePicStorage.shared.fetchProfilePicCoreData(id: userId)
            
            /// If not, fetch the user from the backend
            if (image == nil)
            {
                try await ImageManager.shared.fetchProfilePic(user: user)
                
                do
                {
                    image = try ProfilePicStorage.shared.fetchProfilePicCoreData(id: userId)
                } catch {
                    print(error)
                }
            }
            if (image != nil)
            {
                self.imageProfile = base64DataToImage(image!.data)
            }
            
        } catch {
            print(error)
        }
    }
}
