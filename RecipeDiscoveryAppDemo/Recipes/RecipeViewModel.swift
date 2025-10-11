//
//  RecipeViewModel.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import Foundation

@MainActor
class RecipeViewModel:ObservableObject {
    
    var recipesModel: Recipes? = nil
    @Published var recipes: [Recipe] = []
    
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert = false
    
    @Published  var hasMoreData = true
    
    var limit:Int = 10
    var skip:Int = 0
    var sortBy:String = ""
    var order:String = ""
   
    
    init() {
    }
    
    
    
    func loadRecipes(_ endpoint: String) async {
        isLoading = true
        defer { isLoading = false }
        
        errorMessage = nil
        
        do {
            //let endpoint = API.Endpoint.recipes.urlString
            print("loadRecipes: \(endpoint)")
            recipesModel = try await APIManager.shared.getData(Recipes.self, from: endpoint)
            recipes = recipesModel?.recipes ?? []
            
            //recipes = try await APIManager.shared.getDataFromEndpoint(endpoint)
            print("Fetched recipes:", recipes)
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
    
    
    func loadRecipesWith(_ parameters: [String: Any]) async{
        
        isLoading = true
        defer { isLoading = false }
        
        errorMessage = nil
        
        do {
            let endpoint = API.Endpoint.recipes.urlString
            print("loadRecipesWith: \(endpoint)")
            
            var components = URLComponents(string: endpoint)
            components?.queryItems = makeQueryItems(from: parameters)
            guard let url = components?.url else {
                throw URLError(.badURL)
            }
            recipesModel = try await APIManager.shared.getData(Recipes.self, from: url.absoluteString)
            
            if recipes.count >= recipesModel?.total ?? 0 {
                hasMoreData = false
            }else{
                recipes.append(contentsOf: recipesModel?.recipes ?? [])
                skip = recipes.count
            }
            
            print("\n Fetched recipesModel:", (recipesModel?.total) ?? 0)
            print("\n Fetched recipes:", recipes.count)
            
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
    }
    
    
}
