//
//  NavBarViewModel.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation

class NavBarViewModel: ObservableObject {
 
    var navBarType: States?
    //@Published var isHidden = false
    @Published var NavBarState = States.isVisible
    
    enum States: Int
    {
        case isVisible = 0
        case isHidden = 1
        case onlyBackButton = 2
    }
}
