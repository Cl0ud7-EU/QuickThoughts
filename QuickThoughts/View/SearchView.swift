//
//  SearchView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @ObservedObject var viewModel = SearchViewModel()

    @State private var isEditing = false
    
    var body: some View {
        
        VStack {
            /// SearchBar
            HStack {
                TextField("Search ...", text: $viewModel.userNameSearch)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }
                    .onChange(of: viewModel.userNameSearch) { value in
                        Task {
                            if(!value.isEmpty && value.count > 2)
                            {
                                do
                                {
                                    try await viewModel.searchUsers()
                                }
                                catch {
                                    print("ERROR SEARCHING USERS:", error)
                                }
                            }
                        }
                    }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.viewModel.userNameSearch = ""
                        
                    }) {
                        Text("Cancel")
                    }
                    .padding(.trailing, 10)
                    //.transition(.move(edge: .trailing))
                    //.animation(.default)
                }
            }
            .frame(maxHeight: 50)
            
            List {
                ForEach(viewModel.searchResults, id: \.self) { user in
                    CustomNavLink(destination: Profile(viewModel: ProfileViewModel(user: user))
                        .navBarNewQuickTButtonHidden(value: true)
                        .navBarBackButtonHidden(value: false)
                    ) {
                        Text(String(user.name))
                    }
                }.listRowBackground(Color.white)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
