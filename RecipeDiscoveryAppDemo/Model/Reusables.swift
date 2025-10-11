//
//  Reusables.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 10/10/25.
//

import Foundation

func makeQueryItems(from parameters: [String: Any]) -> [URLQueryItem] {
    parameters.compactMap { key, value in
        // Safely convert value to String
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


struct TagName: Identifiable {
    let id = UUID()
    let title: String
}

let tagNames: [TagName] = [
    TagName(title: "Vegetarian"),
    TagName(title: "Dessert"),
    TagName(title: "Pizza"),
    TagName(title: "Quick")
]


struct SortOption: Identifiable {
    let id: Int
    let title: String
}
let sortOptions: [SortOption] = [
    SortOption(id: 1, title: "Name ↑"),
    SortOption(id: 2, title: "Name ↓"),
    SortOption(id: 3, title: "Cooking Time(Short) ↑"),
    SortOption(id: 4, title: "Cooking Time(Long) ↓"),
    SortOption(id: 5, title: "Rating(High) ↑"),
    SortOption(id: 6, title: "Rating(Low) ↓"),
    SortOption(id: 7, title: "Difficulty(High) ↑"),
    SortOption(id: 8, title: "Difficulty(Low) ↓"),
]
