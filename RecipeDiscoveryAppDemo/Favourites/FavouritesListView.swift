//
//  FavouritesListView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI
import SwiftData


struct FavouritesListView: View {
    
    
    @StateObject private var vm = FavouritesViewModel()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    List {
                        ForEach(vm.recipes, id: \.id) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipeID: recipe.id)) {
                                RecipeCellView(recipe: Recipe(entity: recipe))
                            }
                        }
                        .onDelete { indexSet in
                            if let index = indexSet.first {
                                let entity = vm.recipes[index]
                                vm.deleteRecipe(entity)
                            }
                            
                            vm.getFavourites()
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                
                if vm.recipes.isEmpty {
                    EmptyStateView(imageName: "favouriteIcon",
                                   message: "You have no recipes in your favourites.\nPlease add a recipe!")
                }
            }
            
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .alert("Alert", isPresented: $vm.showAlert) {
            Button("OK", role: .cancel) {
            }
        } message: {
            Text(vm.errorMessage ?? "")
        }
        .onAppear {
            vm.getFavourites()
        }
    }
}

#Preview {
    FavouritesListView()
}
