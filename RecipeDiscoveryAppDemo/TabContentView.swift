//
//  TabContentView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI

struct TabContentView: View {
    
    @State private var selectedTab = 0
    @StateObject private var favourites = FavouritesViewModel()
    @ObservedObject var alertManager = AlertViewManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            RecipeListView()
                .environmentObject(favourites)
                .tabItem {
                    VStack {
                        Image("recipeIcon")
                        Text("Recipes")
                    }
                }
                .tag(0)
            FavouritesListView()
                .environmentObject(favourites)
                .tabItem {
                    VStack {
                        Image("favouriteIcon")
                        Text("Favourites")
                    }
                }
                .tag(1)
                .badge(favourites.recipes.count > 9 ? "9+" : "\(favourites.recipes.count)")
            
            
            
        }.accentColor(.black)
        .attachAlertManager(alertManager)
        
    }
}

#Preview {
    TabContentView()
}
