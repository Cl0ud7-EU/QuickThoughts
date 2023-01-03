//
//  Conversions.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation
import UIKit

func base64DataToImage(_ base64Data: Data) -> UIImage? {
    guard let imageData = Data(base64Encoded: base64Data) else { return nil }
    return UIImage(data: imageData)
}
