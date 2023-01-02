//
//  TimelineView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct TimelineView: View {
    
    
    
    @ObservedObject var viewModel = TimelineViewModel()
    @EnvironmentObject var auth: Authentication
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 1.0) {
                ForEach(viewModel.timelineQuickTs.reversed(), id: \.id) {
                    QuickT in CustomNavLink(destination: QuickTView(quickt: QuickT)
                        .navBarTitle(title: "QuickT")
                    ) {
                        TimelineQuickTView(quickt: QuickT, user: (viewModel.timelineUsers[QuickT.userId]?.name ?? ""), profileImage: viewModel.base64DataToImage((viewModel.timelineUsers[QuickT.userId]?.profilePic!.data)!) ?? UIImage())
                    }
                }
                .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
                .background(Color.mint.opacity(0.5))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.opacity(0.3))
            .task {
                do
                {
                    try await viewModel.fetchFollows()
                    do
                    {
                        try await viewModel.fetchTimelineQuickTs()
                    }
                    catch {
                        print("ERROR FETCHING TIMELINE QUICKTS:", error)
                    }
                }
                catch {
                    print("ERROR FETCHING FOLLOWERS:", error)
                }
                
            }
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
