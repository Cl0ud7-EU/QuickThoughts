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
    
    func downloadImage(path: String) async throws -> Data
    {

        let url = URL(string: urlHost+path)!

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw ErrorHandler.downloadingImage
        }
        return data
    }
    
    func fetchProfilePic(idUser: Int32) async throws
    {
        /// TEMPORARY: Change path to the real path
        let data =  try await downloadImage(path: "pic")
        do
        {
            try await ProfilePicStorage.shared.importPic(data: data, idUser: idUser)
        } catch {
            throw ErrorHandler.invalidData
        }
    }
}
