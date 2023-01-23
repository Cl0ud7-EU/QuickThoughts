//
//  ImageManager.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation

class ImageManager
{
    static let shared: ImageManager = ImageManager()
    
    func downloadImage(path: String, picPath: String) async throws -> Data
    {
        let ruta = path+"?picPath="+picPath
        
        let url = URL(string: urlHost+ruta)!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.downloadingImage
        }
        return data
    }
    
    func fetchProfilePic(user: User) async throws
    {
        if user.profilePicURL != nil && user.profilePicURL != ""
        {
            let data =  try await downloadImage(path: "pic", picPath: user.profilePicURL!)
            do
            {
                try await ProfilePicStorage.shared.importPic(data: data, idUser: user.id)
            } catch {
                throw ErrorHandler.invalidData
            }
        }
    }
}
