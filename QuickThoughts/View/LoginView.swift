//
//  LoginView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct LoginView: View {
    
    var auth: Authentication = .shared
    
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                ZStack {
                    Text("QuickThoughts")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(Color.mint)
                }
            }
            Spacer()
            HStack {
                TextField("Username", text: $viewModel.username)
                    .padding(4)
                    .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.mint, style: StrokeStyle(lineWidth: 1.0)))
            }
            .padding(20)
            HStack {
                SecureField("Password", text: $viewModel.password)
                    .padding(4)
                    .overlay(RoundedRectangle(cornerRadius: 5.0).strokeBorder(Color.mint, style: StrokeStyle(lineWidth: 1.0)))
            }
            .padding(20)
            Button("LOGIN") {
                Task {
                    do {
                        try await viewModel.logIn()
                        try auth.setLoggedStatus()
                    }
                    catch {
                        print("LOGIN ERROR:", error)
                    }
                }
            }
            .foregroundColor(Color.white)
            .padding(7)
            .frame(width: 200, height: 50)
            .background(RoundedRectangle(cornerRadius: 30).fill(Color.mint))
            Spacer()
            Spacer()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
