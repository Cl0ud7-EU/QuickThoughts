//
//  NewQuickTViewModel.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import UIKit

@MainActor
class NewQuickTViewModel:  ObservableObject
{
    
    @Published var text: String
    @Published var imageProfile: UIImage?
    
    let auth = Authentication.shared

    init(text: String) {
        self.text = text
    }

    func sendQuickT(completion: @escaping (NSString) -> Void) throws
    {

        let urlSession = URLSession.shared
        let path = URL(string: urlHost+"newQuickT")!
        
        /// Add data to the QuickT Model
        let newQuickT = QuickT(context: PersistenceController.shared.container.viewContext)
        newQuickT.id = 1 /// Autoincrement in DB
        newQuickT.text = text
        newQuickT.userId = Int32(Authentication.shared.self.getUser().id)
        
        /// Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(newQuickT) else {
            throw ErrorHandler.jsonEncoderError
        }

        var request = URLRequest(url: path)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") /// the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") /// the response expected to be in JSON format

        request.httpBody = jsonData
        urlSession.dataTask(with: request) { data, res, error in
            let jStr = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            completion(jStr!)
        }
        .resume()
        text = ""
    }
    func getPic() async throws
    {
        /// Download ProfilePics if not already saved in CoreData
        let userId = auth.getUser().id
        var image: ProfilePic? = nil
        do
        {
            image = try ProfilePicStorage.shared.fetchProfilePicCoreData(id: userId)
            
            /// If not, fetch the user from the backend
            if (image == nil)
            {
                try await ImageManager.shared.fetchProfilePic(idUser: userId)
                
                do
                {
                    image = try ProfilePicStorage.shared.fetchProfilePicCoreData(id: userId)
                } catch {
                    print(error)
                }
            }
            self.imageProfile = base64DataToImage(image!.data)
        } catch {
            print(error)
        }
    }
}
