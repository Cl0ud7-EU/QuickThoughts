//
//  ProfileImage.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct ProfileImage: View {
    let image: UIImage
    let width: CGFloat
    let height: CGFloat
    let lineWidth: CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: self.width, height: height)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: self.lineWidth)
                    .frame(width: self.width, height: self.height)
                
            }
            .shadow(radius: 7)
    }
}
