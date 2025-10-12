//
//  RecipeViewModel.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import Foundation
import SwiftUI

@MainActor
class RecipeViewModel: ObservableObject {

    @ObservedObject private var alertManager = AlertManager.shared
    @Published var sortByOptionID: Int? = nil
    
    typealias Tags = [String]
    @Published var tags: [String] = []
    @Published  var selectedTag: String?

    var recipesModel: Recipes? = nil
    @Published var recipes: [Recipe] = []

    @Published var isLoading = false
    @Published var isLoadingMore = false

    @Published var hasMoreData = true

    var limit: Int = 10
    var skip: Int = 0
    var sortBy: String = ""
    var order: String = ""

    init() {
        Task {
            await loadTags()
        }
        
    }

    // MARK: - Initial fetch or refresh
    func loadRecipes(_ endpoint: String) async {
        // Decide loading type based on whether recipes exist
        if recipes.isEmpty { isLoading = true } else { isLoadingMore = true }

        defer {
            isLoading = false
            isLoadingMore = false
        }


        do {
            print("loadRecipes: \(endpoint)")
            recipesModel = try await APIManager.shared.getData(Recipes.self, from: endpoint)
            recipes = recipesModel?.recipes ?? []
            hasMoreData = recipes.count < (recipesModel?.total ?? 0)
            skip = recipes.count
            print("Fetched recipes:", recipes.count)
        } catch {
            showError(error)
        }
    }

    // MARK: - Fetch with query parameters (search, sort, etc.)
    func loadRecipesWith(_ parameters: [String: Any]?) async {
        if recipes.isEmpty { isLoading = true } else { isLoadingMore = true }

        defer {
            isLoading = false
            isLoadingMore = false
        }


        do {
            let endpoint = API.Endpoint.recipes.urlString
            print("loadRecipesWith: \(endpoint)")

            var components = URLComponents(string: endpoint)
            components?.queryItems = makeQueryItems(from: parameters ?? [:])

            guard let url = components?.url else {
                throw URLError(.badURL)
            }

            recipesModel = try await APIManager.shared.getData(Recipes.self, from: url.absoluteString)

            // Append new recipes for pagination
            let newRecipes = recipesModel?.recipes ?? []

            if recipes.count + newRecipes.count >= recipesModel?.total ?? 0 {
                hasMoreData = false
            }

            recipes.append(contentsOf: newRecipes)
            skip = recipes.count

            print("Total fetched recipes:", recipes.count)
        } catch {
            showError(error)
        }
    }
    
    // MARK: - Tags service
    func loadTags() async {

        do {
            let endpoint = API.Endpoint.tags.urlString
            print("loadTags: \(endpoint)")
            let result = try await APIManager.shared.getData(Tags.self, from: endpoint)
            tags = result
            print(" tags:", tags)
        } catch {
            showError(error)
        }
    }

    // MARK: - Pagination
    func loadMoreIfNeeded() {
        // Prevent duplicate calls
        guard !isLoadingMore, hasMoreData else { return }

        let params: [String: Any] = [
            "limit": limit,
            "skip": skip,
            "sortBy": sortBy,
            "order": order
        ]

        Task {
            await loadRecipesWith(params)
        }
    }

     func callAPI(_ api: String) {
        Task{
            await loadRecipes(api)
        }
    }
     func callSortAPI() {
        recipes.removeAll()
        skip = 0
         selectedTag = nil
        let params: [String: Any] = ["limit": limit,
                                     "skip": skip,
                                     "sortBy": sortBy,
                                     "order": order]
        Task {
            await loadRecipesWith(params)
        }
    }
    
     func callSearchAPI(_ searchText: String) {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else {
            alertManager.show(title: "Alert", message: "Please enter a search term")
            return
        }
        
        recipes.removeAll()
        skip = 0
        sortByOptionID = nil
        sortBy = ""
        order = ""
        
        let params: [String: Any] = ["q": trimmedText]
        
        Task { @MainActor in
            await loadRecipesWith(params)
        }
    }
    
    
    private func showError(_ error: Error) {
        alertManager.show(title: "Error", message: error.localizedDescription)
    }
 

}


