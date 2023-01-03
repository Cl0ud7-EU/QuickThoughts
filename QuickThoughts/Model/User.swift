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
}

struct UserDecodable: Decodable
{
    let id: Int32
    let name: String
    let follows: [Int32]?
    let profilePicURL: String?

    private enum CodingKeys: String, CodingKey
    {
        case id
        case name
        case follows
        case profilePicURL
    }
    
    init(form decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int32.self, forKey: .id)
        self.name = try values.decode(String.self, forKey: .name)
        self.follows = try? values.decode([Int32].self, forKey: .follows)
        self.profilePicURL = try? values.decode(String.self, forKey: .profilePicURL)
//        if var imageData = try values.decodeIfPresent(String.self, forKey: .imageData) {
//            self.imageData = imageData
//        } else {
//            self.imageData = ""
//        }
    }

    /// The keys must have the same name as the attributes of the QuickT entity.
    var dictionaryValue: [String : Any]
    {
        [
            "id": self.id,
            "name": self.name,
            "follows": self.follows!,
            "profilePicURL": self.profilePicURL!,
            //"image_url": self.imageData
        ]
    }
}
