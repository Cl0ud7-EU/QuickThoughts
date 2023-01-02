//
//  QuickTProfileImage.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct QuickTProfileImage: View {
    let UIimage: UIImage
    var body: some View {
        Image(uiImage: UIimage)
            .resizable()
            .frame(width: 35.0, height: 48.0)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 1)
                    .frame(width: 35, height: 48)
                
            }
            .shadow(radius: 7)
    }
}

//struct QuickTProfileImage_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickTProfileImage()
//    }
//}
