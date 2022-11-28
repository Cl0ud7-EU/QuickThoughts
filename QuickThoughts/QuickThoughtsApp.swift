//
//  QuickThoughtsApp.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

@main
struct QuickThoughtsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
