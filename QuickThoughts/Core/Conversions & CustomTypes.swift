//
//  Conversions.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import UIKit

func base64DataToImage(_ base64Data: Data?) -> UIImage? {
    
    if let data = base64Data {
        guard let imageData = Data(base64Encoded: data) else { return nil } // You can only access it inside the code block. Outside code block it doesn't exist!
        return UIImage(data: imageData)
    }
    else
    {
        return nil
    }
}
func imageToBase64(_ image: UIImage) -> String? {
    return image.jpegData(compressionQuality: 1)?.base64EncodedString()
}

enum NavBarStates: Int
{
    case isVisible = 0
    case isHidden = 1
}
