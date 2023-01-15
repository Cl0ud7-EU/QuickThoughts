//
//  SettingsViewModel.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation

@MainActor
class SettingsViewModel: ObservableObject
{
    
    func deleteAllCoreData()
    {
        QuickTStorage.shared.deleteAll()
        UserStorage.shared.deleteAll()
        ProfilePicStorage.shared.deleteAll()
    }
}
