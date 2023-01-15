//
//  Profile.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct Profile: View {
    
    // TEMPORARY: Change it to User(coredata)
    let user: UserT
    //@EnvironmentObject var vm: HideBarViewModel
    
    //let defaultimg = UIImage(named: "Cl0ud7")!
    var body: some View {
            if (user.id == Authentication.shared.getUser().id)
            {
                    AuthUserProfileView()
            }
            else
            {
                    ExternalUserProfileView()
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

