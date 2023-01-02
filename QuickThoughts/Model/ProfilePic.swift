//
//  ProfilePic.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData

class ProfilePic: NSManagedObject
{
    @NSManaged var idUser: Int32
    @NSManaged var url: String
    @NSManaged var data: Data
}

struct ProfilePicDecodable: Decodable
{
    let idUser: Int32
    let url: String
    let data: Data
    
    private enum CodingKeys: String, CodingKey
    {
        case idUser
        case url
        case data
    }
    
    init(from decoder: Decoder) throws
    {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.idUser = try values.decode(Int32.self, forKey: .idUser)
        self.url = try values.decode(String.self, forKey: .url)
        self.data = try values.decode(Data.self, forKey: .data)
        
    }
    
    var dictionaryValue: [String : Any]
    {
        [
            "idUser": self.idUser,
            "url": self.url,
            "data": self.data,
        ]
    }
}
