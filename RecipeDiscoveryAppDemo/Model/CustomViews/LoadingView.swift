//
//  LoadingView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 11/10/25.
//

import SwiftUI

struct LoadingView: View {
    var message: String = ""
    
    var body: some View {
        
        ZStack {
            Color(.systemBackground)
            .ignoresSafeArea()
            
            // Light blur / dim overlay
          
            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                // Loader
                ProgressView()
                    .scaleEffect(1.4)
                    .tint(.orange)
                
                // Message
                if message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.3), radius: 10, x: 0, y: 4)
            )
            .frame(maxWidth: 250)
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.25), value: message)
        
    }
}

#Preview {
    LoadingView()
}
