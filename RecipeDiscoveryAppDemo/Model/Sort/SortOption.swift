//
//  SortOption.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 13/10/25.
//

import Foundation

struct SortOption: Identifiable {
    let id: Int
    let title: String
    
    static let all: [SortOption] = [
        SortOption(id: 1, title: "Name ↑"),
        SortOption(id: 2, title: "Name ↓"),
        SortOption(id: 3, title: "Cooking Time (Short) ↑"),
        SortOption(id: 4, title: "Cooking Time (Long) ↓"),
        SortOption(id: 5, title: "Rating (High) ↑"),
        SortOption(id: 6, title: "Rating (Low) ↓"),
        SortOption(id: 7, title: "Difficulty (High) ↑"),
        SortOption(id: 8, title: "Difficulty (Low) ↓"),
    ]
}
