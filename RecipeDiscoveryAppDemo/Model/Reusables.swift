//
//  Reusables.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 10/10/25.
//

import Foundation
import SwiftUI

// MARK: - Helper to convert dictionary to URLQueryItems
func makeQueryItems(from parameters: [String: Any]) -> [URLQueryItem] {
    parameters.compactMap { key, value in
        if let stringValue = value as? String {
            return URLQueryItem(name: key, value: stringValue)
        } else if let numberValue = value as? NSNumber {
            return URLQueryItem(name: key, value: numberValue.stringValue)
        } else if let boolValue = value as? Bool {
            return URLQueryItem(name: key, value: boolValue ? "true" : "false")
        } else {
            // Ignore values that can't be represented as strings
            return nil
        }
    }
}

func colorForDifficulty(_ difficulty: Difficulty?) -> Color {
    switch difficulty {
    case .easy: return .green
    case .medium: return .orange
    case .none: return .gray
    }
}







