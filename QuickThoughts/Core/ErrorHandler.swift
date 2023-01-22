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
    case jsonEncoderError
    case coreDataError
    case loginError
    case fetchingUsers
    case fetchQuickTs
    case downloadingImage
    case sendingQuickT
}

extension ErrorHandler: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return NSLocalizedString("Server response error", comment: "")
        case .invalidData:
            return NSLocalizedString("Invalid data", comment: "")
        case .jsonEncoderError:
            return NSLocalizedString("Error encoding data to Json", comment: "")
        case .coreDataError:
            return NSLocalizedString("Error with coreData", comment: "")
        case .loginError:
            return NSLocalizedString("Login Error", comment: "")
        case .fetchingUsers:
            return NSLocalizedString("Error fetching users", comment: "")
        case .fetchQuickTs:
            return NSLocalizedString("Error fetching quickts", comment: "")
        case .downloadingImage:
            return NSLocalizedString("Error downloading image", comment: "")
        case .sendingQuickT:
            return NSLocalizedString("Error sending QuickT", comment: "")
        }
    }
}

extension ErrorHandler: Identifiable {
    var id: String? {
        errorDescription
    }
}
