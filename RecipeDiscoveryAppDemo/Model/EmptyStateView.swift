//
//  EmptyStateView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 10/10/25.
//

import SwiftUI

struct EmptyStateView: View {
    let imageName: String
    let message: String
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                
                Text(message)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding()
            }
            .offset(y: -50)
        }
    }
}

#Preview {
    EmptyStateView(imageName: "recipeIcon", message: "No recipes found")
}
