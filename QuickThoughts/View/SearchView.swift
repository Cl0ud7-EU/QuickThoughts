//
//  SearchView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @ObservedObject var viewmodel = SearchViewModel()
    
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    @State private var searchText = ""
    @State private var isEditing = false
    

    
    
    var body: some View {
        
        VStack {
            /// SearchBar
            HStack {
                
                TextField("Search ...", text: $viewmodel.userNameSearch)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.isEditing = true
                    }

                Button(action: {
                    viewmodel.searchUsers()
                }) {
                    Text("Search")
                }
                
                if isEditing {
                    Button(action: {
                        self.isEditing = false
                        self.searchText = ""
                        
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
                ForEach(viewmodel.searchResults, id: \.self) { user in
                    CustomNavLink(destination: Profile(user: UserT())
                        .navBarNewQuickTButtonHidden(value: true)
                        .navBarBackButtonHidden(value: false)
                    ) {
                        Text(user.name)
                    }
                }.listRowBackground(Color.white)
            }
            .scrollContentBackground(.hidden)
        }
    }
    var searchResults: [String] {
            if searchText.isEmpty {
                return names
            } else {
                return names.filter { $0.contains(searchText) }
            }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
