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
    //@StateObject var auth = Authentication()
    @StateObject var auth: Authentication = .shared
    
    var body: some Scene {
        WindowGroup {
            if auth.getLoggedStatus() {
                MainView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    //.environmentObject(auth)
            }
            else {
                LoginView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    //.environmentObject(auth)
            }
        }
    }
}
