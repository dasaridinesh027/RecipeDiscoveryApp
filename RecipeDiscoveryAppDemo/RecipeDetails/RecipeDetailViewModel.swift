//
//  RecipeDetailViewModel.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeDetailViewModel: ObservableObject {
    
    
    @ObservedObject var alertManager = AlertViewManager.shared

    @Published var recipe: Recipe?
    @Published var isLoading = false
    @Published  var isFavourite = false
    
    init() {
     }
    
    /// Loads a recipe by ID
    func loadRecipe(withID recipeID: Int?) async {
        guard let id = recipeID else {
            alertManager.show(title: "Alert", message: "No recipe ID provided.")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        
        do {
            let endpoint = API.Endpoint.recipe(id: id).urlString
            print("Fetching recipe from:", endpoint)
            
            // Fetch the recipe
            let data = try await APIManager.shared.getData(Recipe.self, from: endpoint)
            recipe = data
            print("Recipe fetched:", recipe ?? "nil")
            
        } catch {
            showError(error)
           
        }
    }
        
    private func showError(_ error: Error) {
        alertManager.show(title: "Error", message: error.localizedDescription)
    }
}



