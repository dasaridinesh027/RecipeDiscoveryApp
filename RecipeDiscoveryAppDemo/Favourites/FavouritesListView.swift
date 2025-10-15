//
//  FavouritesListView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI
import SwiftData


struct FavouritesListView: View {
    
    @EnvironmentObject var vm: FavouritesViewModel
    @State private var searchText = ""
    @State var showFavouritesSortingPopup = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    searchView()
                    favouritesList()
                    
                }
                .padding(.top)
                .blur(radius: showFavouritesSortingPopup ? 20 : 0)
                .disabled(showFavouritesSortingPopup)
                .animation(.easeInOut, value: showFavouritesSortingPopup)
            }
            
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showFavouritesSortingPopup = true
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .attachAlertManager(vm.alertManager)
            .onAppear {
                Task { await vm.fetchFavourites() }
            }
        }.overlay{
            if showFavouritesSortingPopup {
                FavouritesSortOptionView(showFavouritesSortingPopup: $showFavouritesSortingPopup, vm: vm)
                
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
                                    await vm.fetchFavourites(sortOrder: vm.sortDescriptor)
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
                
                let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !query.isEmpty else {
                    vm.alertManager.show(title: "Alert", message: "Please enter a search term")
                    return
                }
                
                Task {
                    await vm.fetchFavouritesFor(query)
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
    
    @ViewBuilder
    func favouritesList() -> some View {
        ZStack {
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
                        vm.alertManager.showConfirmation(
                            title: "Confirmation",
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
}

#Preview {
    FavouritesListView()
}

