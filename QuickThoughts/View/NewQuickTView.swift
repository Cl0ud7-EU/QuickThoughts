//
//  NewQuickTView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import SwiftUI

struct NewQuickTView: View {
    
    @EnvironmentObject var auth: Authentication
    @EnvironmentObject var viewModel: NewQuickTViewModel
    
    let placeholder: String = "What are you thinking?"
    let maxChar = 350
    @State private var remainingChar: Int = 350
    
    enum FocusField: Hashable {
        case field
    }
    @FocusState private var focusedField: FocusField?
        
    var body: some View {
        NavigationView {
            VStack () {
                HStack {
                    ProfileImage(image: (viewModel.imageProfile ?? UIImage(systemName: "person.circle.fill"))!, width: 35.0, height: 48.0, lineWidth: 1)
                        .frame(alignment: .leading)
                    Spacer()
                    Text(String(remainingChar))
                        .foregroundColor(remainingChar < 40 ? .red : .mint)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 15)
                .padding(.top, 5)
                HStack {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.text)
                            .focused($focusedField, equals: .field)
                            .task {
                                self.focusedField = .field
                            }
                            .onChange(of: viewModel.text) { newText in
                                if newText.count > maxChar {
                                    self.viewModel.text = String(newText.prefix(maxChar))
                                }
                                remainingChar = maxChar - viewModel.text.count;
                            }
                            if viewModel.text == "" {
                                Text(placeholder)
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 12)
                            }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 15)
                .padding(.top, 5)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            remainingChar = maxChar - viewModel.text.count;
            UITextView.appearance().backgroundColor = .clear
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

struct NewQuickTView_Previews: PreviewProvider {
    
    static let textoPrueba = ""
    static let NewQuickTVieWModel = NewQuickTViewModel(text: textoPrueba)
    static var previews: some View {
        NewQuickTView()
            .environmentObject(NewQuickTVieWModel)
    }
}

