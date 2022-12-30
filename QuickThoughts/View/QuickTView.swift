//
//  QuickTView.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI

struct QuickTView: View {
    
    let quickt: QuickT
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(.mint)
                    .frame(alignment: .leading)
                    .padding(.leading, 30)
                    
                Text(String(quickt.userId))
                    .foregroundColor(.white)
                    .frame(alignment: .leading)
                    .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 10)
            Text(quickt.text ?? "")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .bottom, .trailing], 30)
                .padding(.top, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .frame(maxWidth: .infinity)
        .background(Color.black)
    }
}

//struct QuickTView_Previews: PreviewProvider {
//    static let quickt = QuickT (
//        id: 1,
//        text: "Pois xa estaria, despois de facer unha libreria matemática propia aqui esta, rotación usando quaternions. Mostra angulos de euler pa que sea mais facil de modificar pero internamente a rotacion calculase con quaternions.",
//        userId: 1
//    )
//    static var previews: some View {
//        QuickTView(quickt: quickt)
//    }
//}
