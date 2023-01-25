//
//  ExternalUserProfileView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct ExternalUserProfileView: View {
    
    let authUser: User
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode
    let image = UIImage(named: "ProfileBG")!
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image("ProfileBG")
                    .resizable()
                    .frame(height: 180)
                VStack() {
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
                        VStack {
                            if(authUser.follows != nil)
                            {
                                if (Authentication.shared.getUser().follows!.contains(viewModel.user.id))
                                {
                                    Text("Unfollow")
                                        .font(.headline)
                                        .frame(maxWidth: 100)
                                        .background(.mint)
                                        .cornerRadius(30)
                                        .foregroundColor(.white)
                                        //.padding(.horizontal, 10)
                                        .onTapGesture {
                                            Task {
                                                do
                                                {
                                                    print("Followed")//try await follow()
                                                }
                                                catch
                                                {
                                                    
                                                }
                                            }
                                        }
                                }
                                else
                                {
                                    Text("Follow")
                                        .font(.headline)
                                        .frame(maxWidth: 100)
                                        .background(.mint)
                                        .cornerRadius(30)
                                        .foregroundColor(.white)
                                        //.padding(.horizontal, 10)
                                        .onTapGesture {
                                            Task {
                                                do
                                                {
                                                    print("Unfollowed")//try await follow()
                                                }
                                                catch
                                                {
                                                    
                                                }
                                            }
                                        }
                                }
                            }
                        }
                        .frame(height: 180)
                        .offset(x: -20,y: 70)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
            }
            HStack() {
                ProfileImage(image: (viewModel.imageProfile ?? image), width: 140.0, height: 190.0, lineWidth: 4)
                    .shadow(radius: 7)
                    .offset(y:  -90)
                    .padding(.bottom, -140)
                Text(viewModel.user.name)
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
                        Text(String(viewModel.user.follows?.count ?? 0))
                    })
                    .foregroundColor(.mint)
                }
                HStack {
                    Text("Followers ")
                    Button(action: {
                    }, label: {
                        Text(String(/*viewModel.user.follows?.count ??*/ 1))
                    })
                    .foregroundColor(.mint)
                }
            }
            .frame(width: 130)
            .offset(x: 20)
            
//            QuickTScrollView(timelineQuickTs: viewModel.profileQuickTs, timelineUsers: viewModel.profileTimelineUsers)
//                .navBarHidden(value: true)
//                .navBarState(value: NavBarStates.isHidden)
        }
    }
}

struct ExternalUserProfileView_Previews: PreviewProvider {

    static var previews: some View {
        ExternalUserProfileView(authUser: .preview, viewModel:  ProfileViewModel(user: .preview))
            //.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
