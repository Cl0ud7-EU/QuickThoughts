//
//  TimelineQuickTView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct TimelineQuickTView: View {
    
    var quickt: QuickT
    var user: String
    var body: some View {
        VStack {
            HStack {
                //QuickTProfileImage()
                    //.frame(alignment: .leading)
                Text(String(user))
                    .foregroundColor(.black)
                    .frame(alignment: .leading)
                    .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.leading, .trailing], 30)
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
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

//struct TimelineQuickTView_Previews: PreviewProvider {
//    static let quickt = QuickT (
//        id: 1,
//        text: "Pois xa estaria, despois de facer unha libreria matemática propia aqui esta, rotación usando quaternions. Mostra angulos de euler pa que sea mais facil de modificar pero internamente a rotacion calculase con quaternions.",
//        userId: 1
//    )
//    static var previews: some View {
//        TimelineQuickTView(quickt: quickt, user: "user")
//    }
//}
