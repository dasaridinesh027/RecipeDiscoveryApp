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

  
    @MainActor
    func saveRecipe(_ recipe: Recipe) async throws {
        let entity = RecipeEntity(from: recipe)
        context.insert(entity)
        
        do {
            try context.save()
            print("Saved recipe: \(recipe.name)")
        } catch {
            print("Failed to save: \(error)")
            throw error
        }
    }

    
    @MainActor
    func fetchRecipes() async throws -> [RecipeEntity] {
        let fetchDescriptor = FetchDescriptor<RecipeEntity>(sortBy: [SortDescriptor(\.name)])
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch recipes: \(error)")
            throw error
        }
    }
    
    
    @MainActor
    func deleteRecipeByID(_ id: Int) async throws {
        let descriptor = FetchDescriptor<RecipeEntity>(
            predicate: #Predicate { $0.id == id }
        )
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            do {
                try context.save()
                print("Deleted \(id)")
            } catch {
                print("Failed to delete: \(error)")
                throw error
            }
        }
    }

    
//    @MainActor
//    func fetchRecipes(searchText: String? = nil) async throws -> [RecipeEntity] {
//        var descriptor: FetchDescriptor<RecipeEntity>
//
//        if let query = searchText, !query.isEmpty {
//            descriptor = FetchDescriptor<RecipeEntity>(
//                predicate: #Predicate { recipe in
//                    recipe.name.localizedStandardContains(query)
//                },
//                sortBy: [SortDescriptor(\.name)]
//            )
//        } else {
//            descriptor = FetchDescriptor<RecipeEntity>(
//                sortBy: [SortDescriptor(\.name)]
//            )
//        }
//        
//        
//        do {
//           let recipes: [RecipeEntity] = try context.fetch(descriptor)
//            return recipes
//        } catch {
//            throw error
//        }
//    }
    
    @MainActor
    func fetchRecipes(searchText: String? = nil, sortBy: [SortDescriptor<RecipeEntity>] = [SortDescriptor(\.name, order: .forward)]) async throws -> [RecipeEntity] {
        
        let descriptor: FetchDescriptor<RecipeEntity>
        
        if let query = searchText, !query.isEmpty {
            descriptor = FetchDescriptor<RecipeEntity>(
                predicate: #Predicate { $0.name.localizedStandardContains(query) },
                sortBy: sortBy
            )
        } else {
            descriptor = FetchDescriptor<RecipeEntity>(sortBy: sortBy)
        }
        
        do {
            let recipes: [RecipeEntity] = try context.fetch(descriptor)
            return recipes
        } catch {
            throw error
        }
    }

    
    @MainActor
    func isRecipeFavourite(_ id: Int) -> Bool {
        do {
            let descriptor = FetchDescriptor<RecipeEntity>(
                predicate: #Predicate { $0.id == id }
            )
            let results = try context.fetch(descriptor)
            return !results.isEmpty
        } catch {
            print("Failed to check favourite: \(error)")
            return false
        }
    }


}

struct SharedModelContainer {
    // Singleton container
    static let shared: ModelContainer = {
        
        let schema = Schema([
            Item.self,
            RecipeEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
    }()
}
