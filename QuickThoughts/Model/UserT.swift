//
//  UserT.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation


//**** This is temp, the app will use CoreData ***///

class UserT: Codable {
    var id: Int32    /// UUID
    var name: String
    var follows: [Int]? = []
    
    init() {
      id = 0
      name = ""
    }
    init(id: Int32, name: String) {
        self.id = id
        self.name = name
    }
    struct Follows: Codable {
        let idUserFollowed: [Int32]
    }
}
