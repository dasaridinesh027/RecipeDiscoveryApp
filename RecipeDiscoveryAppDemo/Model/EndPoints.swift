//
//  EndPoints.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import Foundation

struct API {
    static let baseURL = "https://dummyjson.com/recipes"
   
    enum Endpoint {
        case recipes
        case recipe(id: Int)
        case search
        case mealType(type: String)
        case tag(type: String)
        
        var urlString: String {
            switch self {
                case .recipes:
                    return "\(API.baseURL)"
                case .recipe(let id):
                    return "\(API.baseURL)/\(id)"
                case .search:
                    return "\(API.baseURL)/search"
                case .mealType(let type):
                    return "\(API.baseURL)/meal-type/\(type)"
                case .tag(type: let type):
                    return "\(API.baseURL)/tag/\(type)"
            }
        }
    }
}
