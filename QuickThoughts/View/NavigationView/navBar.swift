//
//  navBar.swift
//  Quickthoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct navBar: View {
    
    let titleText: String
//    let subTitleText: String?
    let backButtonHidden: Bool
    let newQuickTButtonHidden: Bool
    let sendQuickTButtonHidden: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    //@EnvironmentObject var NewQuickTVieWModel: NewQuickTViewModel
    @EnvironmentObject var auth: Authentication
    

    let completion = {  (result: NSString)  in print(result) }
    
    var body: some View {
        HStack {
            if !backButtonHidden {
                backButton
                
            }
            else {
                backButton
                    .opacity(0)
            }
            Spacer()
            title
            Spacer()
            if !newQuickTButtonHidden {
//                newQuickTButton
            }
            else if !sendQuickTButtonHidden {
                sendQuickTButton
            }
            else if !backButtonHidden {
                backButton
                    .opacity(0)
            }
            
        }
        .padding()
        .accentColor(.white)
        .background(Color.mint)
    }
}

struct navBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            navBar(titleText: "QuickT", /*subTitleText: nil,*/ backButtonHidden: false, newQuickTButtonHidden: false, sendQuickTButtonHidden: true/*, quickTtext: Binding.constant(nil), newQuickTC: nil*/)
            Spacer()
        }
        
    }
}

extension navBar {
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "chevron.left")
        })
        .frame(width: 100, alignment: .leading)
    }
    
//    private var newQuickTButton: some View {
//
//        CustomNavLink(destination: NewQuickTView()
//            .navBarTitle(title: "QuickT")
//            .navBarNewQuickTButtonHidden(value: true)
//            .navBarSendQuickTButtonHidden(value: false)
//            .navBarBackButtonHidden(value: false)
//        ) {
//            Text("New QuickT")
//        }
//        .foregroundColor(.white)
//        .frame(width: 100)
//        .cornerRadius(6)
//        .overlay(
//            RoundedRectangle(cornerRadius: 6)
//            .stroke(Color.white, lineWidth: 2)
//        )
//    }
    
    private var sendQuickTButton: some View {
        Button(action: {
//            NewQuickTVieWModel.callAPI(userId: auth.user.id , completion: completion)
//            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Send Quickt")
        })
        .frame(width: 100)
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.white, lineWidth: 2)
            )
    }
    
    private var title: some View {
        VStack {
            Text(titleText)
                .font(.title)
                .fontWeight(.semibold)
//            if subTitleText != nil {
//                Text(subTitleText!)
//            }
            
        }
    }
}
