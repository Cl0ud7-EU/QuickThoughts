//
//  CustomNavLink.swift
//  Quickthoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct CustomNavLink<Label, Destination> : View where Label : View, Destination : View {
    let destination: Destination
    let label: Label
    
    init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
    }
    var body: some View {
        NavigationLink(
            destination:
                CustomNavBarContainer(content: {
                    destination
                })
                .navigationBarHidden(true)
            ,
            label: {
                label
        })
    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavLink(
            destination: Text("Destination")) {
            Text("Nav")
            }
    }
}
