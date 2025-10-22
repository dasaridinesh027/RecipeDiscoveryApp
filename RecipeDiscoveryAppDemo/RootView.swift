//
//  RootView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 16/10/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var appState = AppState.shared
   
    
    var body: some View {
        Group {
            if appState.isLoggedIn {
                TabContentView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: appState.isLoggedIn)
    }
}
