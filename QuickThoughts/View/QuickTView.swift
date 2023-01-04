//
//  QuickTView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct QuickTView: View {
    
    let quickt: QuickT
    let profileImage: UIImage
    var user: String
    var body: some View {
        VStack {
            HStack {
                ProfileImage(image: profileImage, width: 35.0, height: 48.0, lineWidth: 1)
                    .frame(alignment: .leading)
                    .padding(.leading, 10)
                Text(String(user))
                    .foregroundColor(.black)
                    .frame(alignment: .leading)
                    .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], 15)
            .padding(.top, 5)
            Text(quickt.text)
                .multilineTextAlignment(.leading)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .trailing], 30)
                .padding(.bottom, 5)
                .padding(.top, 5)
            HStack {
                Image(systemName: "message")
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "star")
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "ellipsis")
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], 30)
            .padding([.top, .bottom], 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

//struct QuickTView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickTView(quickt: newQuickT)
//            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//    }
//}
