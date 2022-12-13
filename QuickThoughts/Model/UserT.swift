//
//  UserT.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation


//**** This is temp, the app will use CoreData ***///

class UserT: Codable {
    var id: Int    //UUID
    var name: String
    var follows: [Int]? = []
    
    init() {
      id = 0
      name = ""
    }
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
