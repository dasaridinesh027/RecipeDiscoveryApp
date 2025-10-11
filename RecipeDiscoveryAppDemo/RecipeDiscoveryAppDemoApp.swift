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
    
    //var favourites = FavouritesViewModel()
    


    var body: some Scene {
        WindowGroup {
            TabContentView()
        }
        .modelContainer(SharedModelContainer.shared)
        //.environmentObject(favourites)
    }
}


struct SharedModelContainer {
    // Singleton container
    static let shared: ModelContainer = {
        
        let schema = Schema([
            Item.self,
            RecipeEntity.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
        
    }()
}
