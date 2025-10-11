//
//  RecipeDetailViewModel.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import Foundation

@MainActor
class RecipeDetailViewModel:ObservableObject {
    
    
    @Published var recipe: Recipe?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert = false
    
  
    
    func loadRecipeWithID(_ recipeID: Int?) async {
        
        guard let id = recipeID else {
            showAlert = true
            errorMessage = "No recipe ID provided."
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        errorMessage = nil
        
        do {
            let endpoint = API.Endpoint.recipe(id: id).urlString
            print("Fetching data from: \(endpoint)")
            let data = try await APIManager.shared.getData(Recipe.self, from: endpoint)
            recipe = data
            
            //recipe = try await APIManager.shared.getDataFromEndpoint(endpoint)
            print("Fetched recipe:", recipe)
        } catch {

            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
}
