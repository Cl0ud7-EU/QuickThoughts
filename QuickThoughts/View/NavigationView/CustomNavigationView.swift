//
//  CustomNavigationView.swift
//  Quickthoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct CustomNavigationView<Content:View>: View {
    
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        NavigationView {
            CustomNavBarContainer {
                content
            }
            .navigationBarHidden(true)
        }
    }
}

struct CustomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationView {
            Color.white.ignoresSafeArea()
        }
    }
}
