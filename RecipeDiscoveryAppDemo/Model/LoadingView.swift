//
//  LoadingView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 11/10/25.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                ProgressView("Please wait fetching Data...")
                    .tint(.black)
                    .scaleEffect(1)
                
            }
        }
    }
}

#Preview {
    LoadingView()
}
