//
//  RecipeDetailView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI
import SwiftData

struct RecipeDetailView: View {
        
    let recipeID: Int?
    
    @StateObject private var vm = RecipeDetailViewModel()
    
    var body: some View {
        NavigationView {
            
            ZStack {
 
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        RemoteImageView(
                            urlString: vm.recipe?.image ?? "",
                            width: UIScreen.main.bounds.width - 40, // or use .frame(maxWidth: .infinity)
                            height: 200
                        )
                        recepieInfoView()
                        nutritionInfoView()
                        ingrediantsView()
                        instructionsView()
                    }
                    .frame(maxWidth: .infinity)
                    
                } .padding()
                
                if vm.isLoading {
                    LoadingView()
                }
            }
            
            
        }   .navigationBarBackButtonHidden(false)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Recipe Details")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        print("tapped")
                        addtoFavourites()
                    }) {
                        Image("favouriteIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                    }
                    
                    
                }
            } .alert("Alert", isPresented: $vm.showAlert) {
                Button("OK", role: .cancel) {
                }
            } message: {
                Text(vm.errorMessage ?? "")
            }
        
            .task {
                await vm.loadRecipeWithID(recipeID)
            }
        
        
        
    }
    
    @ViewBuilder
    func recepieInfoView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(vm.recipe?.name ?? "")
                .font(.system(size: 20, weight: .bold))
            HStack {
                HStack(spacing: 2) {
                    Image(systemName: "clock")
                        .imageScale(.medium)
                        .foregroundColor(.gray)
                    Text("\(vm.recipe?.cookTimeMinutes ?? 0) mins")
                        .font(.system(size: 15, weight: .regular))
                        .minimumScaleFactor(0.7)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                
                HStack(spacing: 2) {
                    Image(systemName: "list.clipboard")
                        .imageScale(.medium)
                        .foregroundColor(.gray)
                    Text("\(vm.recipe?.servings ?? 0) Servings")
                        .font(.system(size: 15, weight: .regular))
                        .minimumScaleFactor(0.7)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                HStack(spacing: 2) {
                    Image(systemName: "smallcircle.filled.circle.fill")
                        .imageScale(.small)
                        .foregroundColor(.black)
                    Text(vm.recipe?.difficulty.rawValue ?? "")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                
                
            }
            
            HStack(spacing: 4) {
                Image(systemName: "star.leadinghalf.filled")
                    .foregroundColor(.yellow)
                Text("\(String(format: "%.1f", vm.recipe?.rating ?? 0.0))")
                    .font(.system(size: 15, weight: .regular))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            
            HStack {
                Text(vm.recipe?.cuisine ?? "")
                    .font(.system(size: 12, weight: .regular))
                    .frame(maxWidth: .infinity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(width: 60, height: 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                
                Spacer()
                
            }
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    func nutritionInfoView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Nutrition (per serving)")
                .font(.system(size: 15, weight: .medium))
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "flame.fill")
                        .imageScale(.medium)
                        .foregroundColor(.orange)
                    Text("\(vm.recipe?.caloriesPerServing ?? 0) calories")
                        .font(.system(size: 15, weight: .regular))
                        .minimumScaleFactor(0.7)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                
                Spacer()
                
                
            }
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    func ingrediantsView() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Indregients")
                .font(.system(size: 15, weight: .medium))
            
            VStack(spacing: 0) {
                ForEach(vm.recipe?.ingredients ?? [], id: \.self) { ingredient in
                    HStack {
                        Text("• \(ingredient)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.system(size: 12, weight: .regular))
                        
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
                .font(.system(size: 15, weight: .medium))

            
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array((vm.recipe?.instructions ?? []).enumerated()), id: \.offset) { index, instruction in
                    HStack(alignment: .top) {
                        Text("\(index + 1).")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                            .frame(width: 15, alignment: .center)

                        Text(instruction)
                            .font(.system(size: 12))
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
    
    func addtoFavourites(){
        
        do {
            try SwiftDataManager.shared.saveRecipe(vm.recipe!)
            
        } catch {
            vm.showAlert = true
            vm.errorMessage = error.localizedDescription
        }
    
    }
}


#Preview {
    RecipeDetailView(recipeID: nil)
}
