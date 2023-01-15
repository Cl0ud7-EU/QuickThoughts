//
//  NavBarKeys.swift
//  Quickthoughts
//
//  Created by Cl0ud7.
//

import Foundation
import SwiftUI

struct NavBarTitleKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct NavBarTextKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct NavBarNewQuickTButtonHiddenKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct NavBarSendQuickTButtonHiddenKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct NavBarBackButtonHiddenKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct NavBarHiddenKey: PreferenceKey {
    
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

struct NavBarStateKey: PreferenceKey {
    
    typealias Value = NavBarStates
    static var defaultValue: NavBarStates = .isVisible
    
    static func reduce(value: inout NavBarStates, nextValue: () -> NavBarStates) {
        value = nextValue()
    }
}

struct EquatableViewContainer: Equatable {
    
    let id = UUID().uuidString
    let view:AnyView
    
    static func == (lhs: EquatableViewContainer, rhs: EquatableViewContainer) -> Bool {
        return lhs.id == rhs.id
    }
}

extension View {
    
    func navBarTitle( title: String) -> some View {
        preference(key: NavBarTitleKey.self, value: title)
    }
    func navBarText( text: String) -> some View {
        preference(key: NavBarTextKey.self, value: text)
    }
    func navBarNewQuickTButtonHidden( value: Bool ) -> some View {
        preference(key: NavBarNewQuickTButtonHiddenKey.self, value: value)
    }
    func navBarSendQuickTButtonHidden( value: Bool ) -> some View {
        preference(key: NavBarSendQuickTButtonHiddenKey.self, value: value)
    }
    func navBarBackButtonHidden( value: Bool ) -> some View {
        preference(key: NavBarBackButtonHiddenKey.self, value: value)
    }
    func navBarHidden( value: Bool ) -> some View {
        preference(key: NavBarHiddenKey.self, value: value)
    }
    func navBarState( value: NavBarStates ) -> some View {
        preference(key: NavBarStateKey.self, value: value)
    }
}

