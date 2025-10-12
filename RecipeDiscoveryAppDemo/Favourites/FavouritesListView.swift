//
//  FavouritesListView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI
import SwiftData


struct FavouritesListView: View {
    
    @ObservedObject private var alertManager = AlertManager.shared
    @EnvironmentObject var vm: FavouritesViewModel
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    searchView()
                    
                    if vm.recipes.isEmpty {
                        EmptyStateView(imageName: "favouriteIcon",
                                       message: "You have no recipes in your favourites.\nPlease add a recipe!")
                        .padding()
                    }else {
                        List {
                            ForEach(vm.recipes, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeID: recipe.id)) {
                                    RecipeCellView(recipe: Recipe(entity: recipe))
                                }
                            }
                            .onDelete { indexSet in
                                alertManager.showConfirmation(
                                    title: "",
                                    message: "Are you sure? you want to delete this recipe?",
                                    confirmAction: {
                                        print("Confirmed!")
                                        if let index = indexSet.first {
                                            let entity = vm.recipes[index]
                                            Task {
                                                await vm.deleteRecipe(entity)
                                            }
                                        }
                                    }
                                )
                                
                              
                                
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.inline)
            .attachAlertManager(alertManager)
            .onAppear {
                Task { await vm.fetchFavourites() }
            }
        }
        
        
    }
    
    
    
    @ViewBuilder
    func searchView() -> some View {
        HStack(spacing: 8) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Search text field
            TextField("Search recipes...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(8)
                .background(Color.clear)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Spacer()
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                vm.searchText = ""
                                Task {
                                    await vm.fetchFavourites()
                                }
                                
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }else {
                            
                        }
                    }
                )
            
            //Search button
            Button(action: {
                Task {
                    await vm.fetchFavouritesFor(searchText)
                }
            }) {
                Text("Search")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color(.systemGray4))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    FavouritesListView()
}

