//
//  Settings.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import SwiftUI
import PhotosUI

struct Settings: View {
    
    @ObservedObject var viewModel = SettingsViewModel()
    @State private var image = UIImage()
    @State private var showSheet = false
    @State var selectedItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack {
            Spacer()
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
            Text("Change profile pic")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(.gray)
                .cornerRadius(16)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .onTapGesture {
                    showSheet = true
            }
            HStack {
                if (image.size.width != 0)
                {
                    Text("Apply")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.mint)
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            Task {
                                do
                                {
                                    try await changePicture()
                                }
                                catch
                                {
                                    
                                }
                            }
                        }
                }
            }
            .padding(.bottom, 50)
            .foregroundColor(.mint)
            VStack {
                Button(action: {
                    viewModel.deleteAllCoreData()
                }, label: {
                    Text("Sign out")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.red)
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                })
            }.frame(maxHeight: .infinity,alignment: .bottom)
            Spacer()
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showSheet) {
                // Pick an image from the photo library:
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
    func changePicture() async throws
    {
        print("Picture changed!")
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

