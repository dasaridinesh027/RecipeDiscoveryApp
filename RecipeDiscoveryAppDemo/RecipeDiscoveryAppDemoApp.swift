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
    
   // @State private var showSplash = true
    
    var body: some Scene {
        
//        WindowGroup {
//                if showSplash {
//                    SplashScreenView()
//                        .onAppear {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                withAnimation {
//                                    showSplash = false
//                                }
//                            }
//                        }
//                } else {
//                    TabContentView()
//                }
//            }
        
        WindowGroup {
            SplashScreenView()
        }
        .modelContainer(SharedModelContainer.shared)
    }
}

