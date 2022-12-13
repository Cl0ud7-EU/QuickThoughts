//
//  ErrorHandler.swift
//  QuickThoughts
//
//  Created by Cl0ud7.
//

import Foundation


enum ErrorHandler: Error
{
    case invalidServerResponse
    case invalidData
}

extension ErrorHandler: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return NSLocalizedString("Server response error", comment: "")
        case .invalidData:
            return NSLocalizedString("Invalid data", comment: "")
        }
    }
}

extension ErrorHandler: Identifiable {
    var id: String? {
        errorDescription
    }
}
