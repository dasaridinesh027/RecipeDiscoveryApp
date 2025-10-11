//
//  Errors.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import Foundation

enum Errors: Error {
    case invalidURL
    case responseError
    case requestFailed
    case decodingFailed
    case serverError(Int)
    case unknown
    case saveFailed
    case deleteFailed
    case fetchFailed
}



extension Errors: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return NSLocalizedString("Invalid URL", comment: "Invalid URL")
            case .responseError:
                return NSLocalizedString("Unexpected status code", comment: "Invalid response")
            case .unknown:
                return NSLocalizedString("Unknown error", comment: "Unknown error")
            case .requestFailed:
                    return NSLocalizedString("Failed to connect to the server.", comment: "Request Failed")
            case .decodingFailed:
                return NSLocalizedString("Failed to process the server response.", comment: "Decoding Failed")
            case .serverError(let code):
                return NSLocalizedString( "Server returned an error (code \(code)).", comment: "Server error")
               
            case .saveFailed:
                return NSLocalizedString( "Failed to save data.", comment: "Saving Failed")

            case .deleteFailed:
                return NSLocalizedString( "Failed to delete data.", comment: "Deleting Failed")
            case .fetchFailed:
                return NSLocalizedString( "Failed to fetch data.", comment: "Featching Failed")
        }
    }
}
