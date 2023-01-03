//
//  CustomNavBarContainer.swift
//  Quickthoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct CustomNavBarContainer<Content: View>: View {
    
    let content: Content
    
    //NavBar
    @State private var titleText: String = ""
//    let subTitleText: String?
    @State private var backButtonHidden: Bool = false
    @State private var newQuickTButtonHidden: Bool = false
    @State private var sendQuickTButtonHidden: Bool = true
    @State private var navBarHidden: Bool = false

//    @Binding var quickTtext: String?
    
    init(@ViewBuilder content: ()-> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !navBarHidden {
                navBar(titleText: titleText, /*subTitleText: subTitleText,*/ backButtonHidden: backButtonHidden, newQuickTButtonHidden: newQuickTButtonHidden, sendQuickTButtonHidden: sendQuickTButtonHidden /*, quickTtext: $quickTtext*/)
            }
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea(.container, edges: .top)
        }
        .onPreferenceChange(NavBarTitleKey.self, perform: {
            value in
            self.titleText = value
        })
        .onPreferenceChange(NavBarSendQuickTButtonHiddenKey.self, perform: {
            value in
            self.sendQuickTButtonHidden = value
        })
        .onPreferenceChange(NavBarNewQuickTButtonHiddenKey.self, perform: {
            value in
            self.newQuickTButtonHidden = value
        })
        .onPreferenceChange(NavBarBackButtonHiddenKey.self, perform: {
            value in
            self.backButtonHidden = value
        })
        .onPreferenceChange(NavBarHiddenKey.self, perform: {
            value in
            self.navBarHidden = value
        })
    }
}

struct CustomNavBarContainer_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavBarContainer() {
            Text("Hello")
                .navBarTitle(title: "QuickT")
        }
    }
}
