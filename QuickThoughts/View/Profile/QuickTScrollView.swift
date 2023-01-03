//
//  QuickTScrollView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct QuickTScrollView: View {
    
    let timelineQuickTs: [QuickT]
    let timelineUsers: [Int32:User]
    
    //let user: User
//
    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 1.0) {
                ForEach(timelineQuickTs.reversed(), id: \.id) { QuickT in
                    CustomNavLink(destination: QuickTView(quickt: QuickT)
                        .navBarTitle(title: "QuickT")
                    ) {
                        TimelineQuickTView(quickt: QuickT, user: (timelineUsers[QuickT.userId]?.name ?? ""), profileImage: base64DataToImage((timelineUsers[QuickT.userId]?.profilePic!.data)!) ?? UIImage())
                    }
                }
            }
            .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
            .background(Color.mint.opacity(0.5))
        }
        //.edgesIgnoringSafeArea(.all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.3))
    }
}

//struct QuickTScrollView_Previews: PreviewProvider {
//    static let user = User(id: 1, name: "Cl0ud7")
//    static let quickTs: [QuickT] = []
//
//    static var previews: some View {
//        QuickTScrollView(timelineQuickTs: quickTs, user: user)
//    }
//}
