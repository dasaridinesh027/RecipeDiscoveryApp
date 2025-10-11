//
//  RecipeModel.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import Foundation


// MARK: - Recipes
struct Recipes: Codable {
    let recipes: [Recipe]
    let total, skip, limit: Int
}

// MARK: - Recipe
struct Recipe: Codable,Hashable,Identifiable,Equatable {
    let id: Int
    let name: String
    let ingredients, instructions: [String]
    let prepTimeMinutes, cookTimeMinutes, servings: Int
    let difficulty: Difficulty
    let cuisine: String
    let caloriesPerServing: Int
    let tags: [String]
    let userID: Int
    let image: String
    let rating: Double
    let reviewCount: Int
    let mealType: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, ingredients, instructions, prepTimeMinutes, cookTimeMinutes, servings, difficulty, cuisine, caloriesPerServing, tags
        case userID = "userId"
        case image, rating, reviewCount, mealType
    }
}

enum Difficulty: String, Codable {
    case easy = "Easy"
    case medium = "Medium"
}

extension Recipe {
    init(entity: RecipeEntity) {
        self.id = entity.id
        self.name = entity.name
        self.ingredients = entity.ingredients
        self.instructions = entity.instructions
        self.prepTimeMinutes = entity.prepTimeMinutes
        self.cookTimeMinutes = entity.cookTimeMinutes
        self.servings = entity.servings
        self.difficulty = Difficulty(rawValue: entity.difficulty) ?? .easy
        self.cuisine = entity.cuisine
        self.caloriesPerServing = entity.caloriesPerServing
        self.tags = entity.tags
        self.userID = entity.userID
        self.image = entity.image
        self.rating = entity.rating
        self.reviewCount = entity.reviewCount
        self.mealType = entity.mealType
    }
}


/*
{
      "id": 1,
      "name": "Classic Margherita Pizza",
      "ingredients": [
        "Pizza dough",
        "Tomato sauce",
        "Fresh mozzarella cheese",
        "Fresh basil leaves",
        "Olive oil",
        "Salt and pepper to taste"
      ],
      "instructions": [
        "Preheat the oven to 475°F (245°C).",
        "Roll out the pizza dough and spread tomato sauce evenly.",
        "Top with slices of fresh mozzarella and fresh basil leaves.",
        "Drizzle with olive oil and season with salt and pepper.",
        "Bake in the preheated oven for 12-15 minutes or until the crust is golden brown.",
        "Slice and serve hot."
      ],
      "prepTimeMinutes": 20,
      "cookTimeMinutes": 15,
      "servings": 4,
      "difficulty": "Easy",
      "cuisine": "Italian",
      "caloriesPerServing": 300,
      "tags": [
        "Pizza",
        "Italian"
      ],
      "userId": 45,
      "image": "https://cdn.dummyjson.com/recipe-images/1.webp",
      "rating": 4.6,
      "reviewCount": 3,
      "mealType": [
        "Dinner"
      ]
    }
*/
