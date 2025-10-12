//
//  RecipeDetailView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
       
    @ObservedObject private var alertManager = AlertManager.shared

    @EnvironmentObject var favourites: FavouritesViewModel
    let recipeID: Int?

    @StateObject private var vm = RecipeDetailViewModel()
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 10) {
                    RemoteImageView(
                        urlString: vm.recipe?.image ?? "",
                        width: UIScreen.main.bounds.width - 40,
                        height: 200
                    )
                    .shadow(radius: 4)
                    
                    recepieInfoView()
                    nutritionInfoView()
                    ingrediantsView()
                    instructionsView()
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            
            if vm.isLoading {
                LoadingView()
            }
        }
        .navigationTitle("Recipe Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        if !vm.isFavourite {
                            await addToFavourites()
                            alertManager.show(title: "Success", message: "Added to favourites")
                        }else{
                            alertManager.show(title: "Recipe already added to favourites", message: "")
                        }
                  
                        //await addToFavourites()
                    }
                    
                } label: {
                    Image(vm.isFavourite ? "favouriteIconSel" : "favouriteIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
              
            }
        }
        .attachAlertManager(alertManager)
        .task {
            await vm.loadRecipe(withID: recipeID)
            if let recipe = vm.recipe {
                vm.isFavourite = favourites.dataManager.isRecipeFavourite(recipe.id)
               }
        }
    }

    
    @ViewBuilder
    func recepieInfoView() -> some View {
        VStack(alignment: .leading, spacing: 7) {
            
            
            // Recipe name
            Text(vm.recipe?.name ?? "Unknown Recipe")
                .font(.system(size: 20, weight: .bold))
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .multilineTextAlignment(.leading)
            
            
            HStack(spacing: 16) {
                
                // Cook Time
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("\(vm.recipe?.cookTimeMinutes ?? 0) mins")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                
                // Servings
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Text("\(vm.recipe?.servings ?? 0) Servings")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                
                // Difficulty
                HStack(spacing: 4) {
                    Circle()
                        .fill(colorForDifficulty(vm.recipe?.difficulty))
                        .frame(width: 14, height: 14)
                    Text(vm.recipe?.difficulty.rawValue ?? "-")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(1)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                )
            }
            
            // Rating
            HStack(spacing: 16) {
            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(vm.recipe?.rating ?? 0) ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.yellow)
                }
                
                Text(String(format: "%.1f", vm.recipe?.rating ?? 0))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
            }
            
            
            
            HStack {
                // Cuisine tag
                if let cuisine = vm.recipe?.cuisine, !cuisine.isEmpty {
                    Text(cuisine)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                        )
                }
                
                
                Spacer()
                
            }
        }
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    func nutritionInfoView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Nutrition (per serving)")
                .font(.system(size: 16, weight: .medium))
            
            HStack(spacing: 16) {
                // Calories
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.orange)
                    Text("\(vm.recipe?.caloriesPerServing ?? 0) cal")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }

    
    @ViewBuilder
    func ingrediantsView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Indregients")
                .font(.system(size: 16, weight: .medium))
            
            VStack(spacing: 0) {
                ForEach(vm.recipe?.ingredients ?? [], id: \.self) { ingredient in
                    HStack {
                        Text("• \(ingredient)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 14, weight: .regular))
                        
                    }
                    .padding(5)
                    .padding(.horizontal)
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
           
            
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    func instructionsView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Instructions")
                .font(.system(size: 16, weight: .medium))

            
            VStack(alignment: .leading, spacing: 2) {
                ForEach(Array((vm.recipe?.instructions ?? []).enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top) {
                        Text("\(index + 1).")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.gray)
                            .frame(width: 15, alignment: .center)

                        Text(instruction)
                            .font(.system(size: 14, weight: .regular))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.vertical, 2)
                  
                }
            }
            .background(Color.white)
            .padding(.horizontal)
            


            
        }.padding(.horizontal)
    }
    


    
    func addToFavourites() async {
       print(#function)
        guard let recipe = vm.recipe else { return }
        
        do {
            if vm.isFavourite {
                try await favourites.dataManager.deleteRecipeByID(recipe.id)
                vm.isFavourite = false
            } else {
                try await favourites.dataManager.saveRecipe(recipe)
                vm.isFavourite = true
            }
            await favourites.fetchFavourites()
            
            
        } catch {
            alertManager.show(title: "Error", message: error.localizedDescription)
        }
    }



}


#Preview {
    RecipeDetailView(recipeID: nil)
}
