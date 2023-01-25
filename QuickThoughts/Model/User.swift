//
//  User.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData

class User: NSManagedObject
{
    @NSManaged var id: Int32 
    @NSManaged var name: String
    @NSManaged var follows: [Int32]?
    @NSManaged var profilePicURL: String?
    @NSManaged var profilePic: ProfilePic?
    
    
    private enum CodingKeys: CodingKey
    {
        case id
        case name
        case follows
        case profilePicURL
        case profilePic
        //case imageData
    }
}

struct UserDecodable: Decodable, Hashable
{
    let id: Int32
    let name: String
    //let follows: [Int32]?
    let profilePicURL: String?

    private enum CodingKeys: String, CodingKey
    {
        case id
        case name
        //case follows
        case profilePicURL
    }
    
    init(form decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int32.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        //self.follows = try? values.decode([Int32].self, forKey: .follows)
        self.profilePicURL = try? values.decode(String.self, forKey: .profilePicURL)
//        if var imageData = try values.decodeIfPresent(String.self, forKey: .imageData) {
//            self.imageData = imageData
//        } else {
//            self.imageData = ""
//        }
    }

    /// The keys must have the same name as the attributes of the User entity.
    var dictionaryValue: [String : Any]
    {
        [
            "id": self.id,
            "profilePicURL": self.profilePicURL ?? nil,
            "name": self.name,
            //"follows": self.follows!,
            
            //"image_url": self.imageData
        ]
    }
}

extension User: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        //try container.encode(follows, forKey: .follows)
    }
    
    /// An user for use with canvas previews.
    static var preview: User {
        let users = User.makePreviews(count: 1)
        return users[0]
    }

    @discardableResult
    static func makePreviews(count: Int) -> [User] {
        var users = [User]()
        let viewContext = PersistenceController.preview.container.viewContext
        for index in 0..<count {
            let user = User(context: viewContext)
            user.id = Int32(index+1)
            user.name = "Test"+String(index+1)
            users.append(user)
        }
        return users
    }
}
