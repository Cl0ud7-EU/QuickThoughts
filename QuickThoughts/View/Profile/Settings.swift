//
//  Settings.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI
import PhotosUI

struct Settings: View {
    
    @State private var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Text("Change photo")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [.mint, .black]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(16)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .foregroundColor(.mint)
                .onTapGesture {
                    showSheet = true
                }
            Button(action: {
            }, label: {
                Text("Change Background Picture")
                    .font(.largeTitle.weight(.light))
            })
            .foregroundColor(.mint)
        }
        HStack {
            Image(uiImage: self.image)
            .resizable()
            .cornerRadius(50)
            .frame(width: 100, height: 100)
            .background(Color.black.opacity(0.2))
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
        }
        .padding(.horizontal, 20)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
