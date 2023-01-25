//
//  QuickT.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import CoreData

class QuickT: NSManagedObject
{
    /// Unique identifier to avoid duplicates
    @NSManaged var id: Int32
    
    @NSManaged var userId: Int32
    @NSManaged var text: String
    //@NSManaged var imageData: String
    
    
    
    private enum CodingKeys: CodingKey
    {
        case id
        case text
        case userId
        //case imageData
    }
    
}

struct QuickTDecodable: Decodable
{
    let id: Int32
    let text: String
    let userId: Int32
    //let imageData: String

    private enum CodingKeys: String, CodingKey
    {
        case id
        case text
        case userId
        //case imageData
    }
    
    init(form decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int32.self, forKey: .id)
        self.text = try values.decode(String.self, forKey: .text)
        self.userId = try values.decode(Int32.self, forKey: .userId)
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
            "text": self.text,
            "userId": self.userId,
            //"image_url": self.imageData
        ]
    }
}

extension QuickT: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(text, forKey: .text)
        try container.encode(userId, forKey: .userId)
    }
    
    /// An user for use with canvas previews.
    static var preview: [QuickT] {
        let quickTs = QuickT.makePreviews(count: 10)
        return quickTs
    }

    @discardableResult
    static func makePreviews(count: Int) -> [QuickT] {
        var quickTs = [QuickT]()
        let viewContext = PersistenceController.preview.container.viewContext
        for index in 0..<count {
            let quickt = QuickT(context: viewContext)
            quickt.id = Int32(index+1)
            quickt.userId = 1
            quickt.text = "QuickT Test"+String(index+1)
            quickTs.append(quickt)
        }
        return quickTs
    }
}
