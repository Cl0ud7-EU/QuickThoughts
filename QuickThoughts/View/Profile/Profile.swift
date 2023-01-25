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
                AuthUserProfileView(viewModel: ProfileViewModel(user: Authentication.shared.getUser()))
            }
            else
            {
                ExternalUserProfileView(authUser: Authentication.shared.getUser(), viewModel: viewModel!)
            }
        }
        else
        {
            AuthUserProfileView(viewModel: ProfileViewModel(user: Authentication.shared.getUser()), backButtonHidden: true)
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

