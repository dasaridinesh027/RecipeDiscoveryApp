//
//  TabContentView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI

struct TabContentView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
                 RecipeListView()
                     .tabItem {
                         Label("Recipes", image: "recipeIcon")
                     }.tag(0)

                 FavouritesListView()
                     .tabItem {
                         Label("Favourites", image:"favouriteIcon")
                     }
                .tag(1)
            

        }.accentColor(.black)

    }
}

#Preview {
    TabContentView()
}
