//
//  SwiftDataManager.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 11/10/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
class SwiftDataManager {
    
    static let shared = SwiftDataManager()
    
    private init() {}
    
    let context = SharedModelContainer.shared.mainContext
    
    func saveRecipe(_ recipe:Recipe) throws{
        
        let entity = RecipeEntity(from: recipe)
        context.insert(entity)
        
        do {
            try context.save()
            print("Saved all recipes to SwiftData!")
        } catch {
            print("Failed to save: \(error)")
            throw Errors.saveFailed
        }
        
    }
    
    func fetchRecipes() throws -> [RecipeEntity]{
        do {
            let fetchDescriptor = FetchDescriptor<RecipeEntity>(sortBy: [SortDescriptor(\.name)])
            let recipes = try context.fetch(fetchDescriptor)
            return recipes
        } catch {
            print("Failed to fetch recipes: \(error)")
            throw Errors.fetchFailed
        }
    }
    
    func deleteRecipe(_ recipe:RecipeEntity) throws{
        context.delete(recipe)
        do {
            try context.save()    // persist deletion
            print("Deleted \(recipe.name)")
        } catch {
            print("Failed to delete: \(error)")
            throw Errors.deleteFailed
        }
    }
}
