//
//  SplashScreenView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 13/10/25.
//


import SwiftUI

struct SplashScreenView: View {
    @StateObject private var appState = AppState.shared
    
    @StateObject private var alertManager = AlertManager.shared
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                // Show the next screen based on login state
                if appState.isLoggedIn {
                    TabContentView()
                    
                } else {
                    LoginView()
                }
            } else {
                splashContent
            }
        }
        .onAppear {
            // Delay before moving to next screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeIn(duration: 0.5)) {
                    isActive = true
                }
            }
            
        }
    }
    
    private var splashContent: some View {
        ZStack {
            Color("LaunchBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image(systemName: "fork.knife.circle.fill")
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(isActive ? 1.0 : 0.6)
                    .opacity(isActive ? 1.0 : 0.5)
                
                Text("Recipe Discovery")
                    .font(.title2)
                    .foregroundColor(.black)
                
                Text("Find. Cook. Enjoy.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
}
