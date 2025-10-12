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
class FavouritesViewModel: ObservableObject {

    @ObservedObject private var alertManager = AlertManager.shared
    @Published var recipes: [RecipeEntity] = []
    @Published var searchText: String = ""


     let dataManager = SwiftDataManager.shared

    
    init() {
        Task { await fetchFavourites() }
    }

 
    
    func fetchFavourites() async {
         do {
             if searchText.isEmpty {
                 recipes = try await dataManager.fetchRecipes()
             } else {
                 recipes = try await dataManager.fetchRecipes(searchText: searchText)
             }
         } catch {
             showError(error)
         }
     }
    
       func deleteRecipe(_ recipe: RecipeEntity) async {
           do {
               try await dataManager.deleteRecipe(recipe)
               //await fetchFavourites()
               
               // Update local array immediately
               if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
                   recipes.remove(at: index)
               }
           } catch {
               showError(error)
           }
       }
    
    func fetchFavouritesFor(_ query: String) async {
        
        searchText = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchText.isEmpty else {
            alertManager.show(title: "Alert", message: "Please enter a search term")
            return
        }
        
            searchText = query.trimmingCharacters(in: .whitespacesAndNewlines)
            await fetchFavourites()
        }
    
    private func showError(_ error: Error) {
        alertManager.show(title: "Error", message: error.localizedDescription)
    }
}

