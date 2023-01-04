//
//  Profile.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct Profile: View {
    
    @ObservedObject var viewModel = ProfileViewModel()
    
    //let defaultimg = UIImage(named: "Cl0ud7")!
    var body: some View {
        CustomNavigationView {
            VStack(spacing: 0) {
                ZStack {
                    Image("ProfileBG")
                                .resizable()
                                .frame(height: 180)
                    HStack() {
                        VStack() {
                            CustomNavLink(destination: Settings()
                                .navBarTitle(title: "Settings")
                            ){
                                Image(systemName: "gear.circle.fill")
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(.white, .mint)
                                    .font(.largeTitle.weight(.light))
                            }
                            .foregroundColor(.mint)
                            
                            Spacer()
                        }
                        .frame(height: 100)
                        .padding(.trailing)
                    }
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                }//.frame(maxWidth: .infinity)
                    
                
                HStack() {
                    ProfileImage(image: (viewModel.imageProfile ?? UIImage(systemName: "person.circle.fill"))!, width: 140.0, height: 190.0, lineWidth: 4)
                        .shadow(radius: 7)
                        .offset(y:  -90)
                        .padding(.bottom, -140)
                    Text(viewModel.auth.getUser().name)
                            .font(.title)
                            .padding(.top, 0)
    //                        .fixedSize(horizontal: true, vertical: false)
                            .frame(maxWidth: 200, alignment: .leading)
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text("Follows ")
                        Button(action: {
                        }, label: {
                            Text(String(viewModel.auth.getUser().follows?.count ?? 0))
                        })
                        .foregroundColor(.mint)
                    }
                    HStack {
                        Text("Followers ")
                        Button(action: {
                        }, label: {
                            Text(String(viewModel.auth.getUser().follows?.count ?? 0))
                        })
                        .foregroundColor(.mint)
                    }
                }
                .frame(width: 130)
                .offset(x: 20)
                
                QuickTScrollView(timelineQuickTs: viewModel.profileQuickTs, timelineUsers: viewModel.profileTimelineUsers)
                    .navBarHidden(value: true)
            }
        }.ignoresSafeArea(edges: .top)
        .task {
            do
            {
                try await viewModel.fetchFollows()
                do
                {
                    try await viewModel.fetchQuickTs()
                } catch {
                    print("ERROR FETCHING PROFILE QUICKTS:", error)
                }
            }
            catch {
                print("ERROR FETCHING FOLLOWERS:", error)
            }
        }
        .task {
            do
            {
                try await viewModel.getPic()
            } catch {
                print("ERROR GETTING PROFILE PIC:", error)
            }
        }
    }
}

//struct Profile_Previews: PreviewProvider {
//    static let user = User(id: 1, name: "Cl0ud7")
//    static let auth = Authentication(user: user)
//    
//    static var previews: some View {
//        Profile(user: user)
//            .environmentObject(auth)
//    }
//}

