//
//  SplashScreenView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 13/10/25.
//


import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color("LaunchBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(isActive ? 1.0 : 0.6)
                    .opacity(isActive ? 1.0 : 0.5)
                    .animation(.easeOut(duration: 1.2), value: isActive)
                
                Text("Recipe Discovery")
                    .font(.title.bold())
                    .foregroundColor(.black)
                
                Text("Find. Cook. Enjoy.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            withAnimation {
                isActive = true
            }
        }
    }
}

