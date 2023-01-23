//
//  AuthUserProfileView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct AuthUserProfileView: View {
    
    @ObservedObject var viewModel = ProfileViewModel(user: Authentication.shared.getUser())
    @Environment(\.presentationMode) var presentationMode
    var backButtonHidden = false
    let image = UIImage(named: "ProfileBG")!
    
    var body: some View {
        CustomNavigationView {
            VStack(spacing: 0) {
                ZStack {
                    Image("ProfileBG")
                                .resizable()
                                .frame(height: 180)
                    if (!backButtonHidden)
                    {
                        HStack() {
                            VStack() {
                                Button(action: { presentationMode.wrappedValue.dismiss() }, label: {
                                    Image(systemName: "arrow.backward.circle.fill")
                                            .symbolRenderingMode(.palette)
                                            .foregroundStyle(.white, .mint)
                                            .font(.largeTitle.weight(.light))
                                            .contentShape(Circle())
                                            .padding()
                                            })
                            }
                            .frame(height: 180)
                            .offset(x: 5, y: -25)
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    if (backButtonHidden)
                    {
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
                            .offset(y: 10)
                            .padding(.trailing)
                        }
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                    }
                }
                HStack() {
                    ProfileImage(image: (viewModel.imageProfile ?? image)!, width: 140.0, height: 190.0, lineWidth: 4)
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
                    .navBarState(value: NavBarStates.isHidden)
            }
        }
        //.navBarHidden(value: true)
        .ignoresSafeArea(edges: .top)
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

struct AuthUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        AuthUserProfileView()
    }
}
