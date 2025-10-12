//
//  RecipeDiscoveryAppDemoApp.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI
import SwiftData

@main
struct RecipeDiscoveryAppDemoApp: App {
    
    var favourites = FavouritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabContentView()
        }
        .modelContainer(SharedModelContainer.shared)
        .environmentObject(favourites)
    }
}

