//
//  Profile.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct Profile: View {
    

    let viewModel: ProfileViewModel?
    var body: some View {
        
        if (viewModel != nil)
        {
            if (viewModel!.user.id == Authentication.shared.getUser().id)
            {
                AuthUserProfileView()
            }
            else
            {
                ExternalUserProfileView(viewModel: viewModel!)
            }
        }
        else
        {
            AuthUserProfileView(backButtonHidden: true)
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

