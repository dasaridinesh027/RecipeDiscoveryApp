//
//  RecipeEntity.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 11/10/25.
//

import Foundation
import SwiftData

@Model
final class RecipeEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var ingredientsData: Data
    var instructionsData: Data
    var prepTimeMinutes: Int
    var cookTimeMinutes: Int
    var servings: Int
    var difficulty: String
    var cuisine: String
    var caloriesPerServing: Int
    var tagsData: Data
    var userID: Int
    var image: String
    var rating: Double
    var reviewCount: Int
    var mealTypeData: Data

    init(from recipe: Recipe) {
        self.id = recipe.id
        self.name = recipe.name
        self.ingredientsData = try! JSONEncoder().encode(recipe.ingredients)
        self.instructionsData = try! JSONEncoder().encode(recipe.instructions)
        self.prepTimeMinutes = recipe.prepTimeMinutes
        self.cookTimeMinutes = recipe.cookTimeMinutes
        self.servings = recipe.servings
        self.difficulty = recipe.difficulty.rawValue
        self.cuisine = recipe.cuisine
        self.caloriesPerServing = recipe.caloriesPerServing
        self.tagsData = try! JSONEncoder().encode(recipe.tags)
        self.userID = recipe.userID
        self.image = recipe.image
        self.rating = recipe.rating
        self.reviewCount = recipe.reviewCount
        self.mealTypeData = try! JSONEncoder().encode(recipe.mealType)
    }
    
    var mealType: [String] {
         get {
             (try? JSONDecoder().decode([String].self, from: mealTypeData)) ?? []
         }
         set {
             mealTypeData = try! JSONEncoder().encode(newValue)
         }
     }
    var tags: [String] {
         get {
             (try? JSONDecoder().decode([String].self, from: tagsData)) ?? []
         }
         set {
             tagsData = try! JSONEncoder().encode(newValue)
         }
     }
    var ingredients: [String] {
         get {
             (try? JSONDecoder().decode([String].self, from: ingredientsData)) ?? []
         }
         set {
             ingredientsData = try! JSONEncoder().encode(newValue)
         }
     }
    var instructions: [String] {
         get {
             (try? JSONDecoder().decode([String].self, from: instructionsData)) ?? []
         }
         set {
             instructionsData = try! JSONEncoder().encode(newValue)
         }
     }
}
