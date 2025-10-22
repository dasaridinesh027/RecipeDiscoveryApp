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

    @ObservedObject var alertManager = AlertViewManager.shared
    @Published var recipes: [RecipeEntity] = []
    
    var searchText: String = ""
    var sortDescriptor: [SortDescriptor<RecipeEntity>] = [SortDescriptor(\.name, order: .forward)]
    
    @Published var sortFavouritesByOptionID: Int = 1 {
           didSet { Task {  await fetchFavourites(searchText, sortOrder: sortDescriptor) } }
       }
    
     let dataManager = SwiftDataManager.shared

    
    init() {
        Task {
            await fetchFavourites()
        }
    }
    

    func fetchFavourites(_ text: String? = nil, sortOrder: [SortDescriptor<RecipeEntity>] = [SortDescriptor(\.name, order: .forward)]) async {
        
        print("\nfetchFavourites  text:::\(text ?? ""),  Sorting by:", sortDescriptor.map { "\($0.keyPath) (\($0.order == .forward ? "ASC" : "DESC"))\n" })

        
        do {
            recipes = try await dataManager.fetchRecipes(searchText: text, sortBy: sortOrder)
            
        } catch {
            showError(error)
        }
    }
    
    
       func deleteRecipe(_ recipe: RecipeEntity) async {
           do {
               try await dataManager.deleteRecipeByID(recipe.id)
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
        searchText = query
        await fetchFavourites(searchText)

        }
    
    
    func fetchFavouritesSort() {
        
        Task {
            await fetchFavourites(searchText, sortOrder: sortDescriptor)
        }
    }
    
    
    private func showError(_ error: Error) {
        alertManager.show(title: "Error", message: error.localizedDescription)
    }
    

}

