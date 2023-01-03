//
//  TimelineView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct TimelineView: View {
    
    @ObservedObject var viewModel = TimelineViewModel()
    //@EnvironmentObject var auth: Authentication
    
    var body: some View {
        QuickTScrollView(timelineQuickTs: viewModel.timelineQuickTs, timelineUsers: viewModel.timelineUsers)
        .task {
            do
            {
                try await viewModel.fetchFollows()
                do
                {
                    try await viewModel.fetchQuickTs()
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

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView()
    }
}
