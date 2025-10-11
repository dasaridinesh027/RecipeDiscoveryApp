//
//  FavouritesViewModel.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 10/10/25.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
class FavouritesViewModel:ObservableObject {
    
    
    @Published var recipes: [RecipeEntity] = []
    @Published var errorMessage: String?
    @Published var showAlert = false
    
    
    init() {
    }
    
    func getFavourites() {
        print(#function)
        do {
            recipes = try  SwiftDataManager.shared.fetchRecipes()
            print("Fetched recipe:", recipes)
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
        
    }
    
    func deleteRecipe(_ entity: RecipeEntity) {
        do {
           try  SwiftDataManager.shared.deleteRecipe(entity)
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
    
    
    
}

