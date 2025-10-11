//
//  NavigationBarView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI

struct NavigationBarView: View {
    @Environment(\.dismiss) private var dismiss
    var title: String
      var showBackButton: Bool = true
      var trailingButton: (() -> AnyView)? = nil
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Navigation Bar
            HStack {
                if showBackButton {
                    Button(action: { dismiss() }) {
                        HStack() {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20)
                            //Text("Back")
                                //.foregroundColor(.black)
                        }
                    }
                } else {
                    Spacer().frame(width: 60) // reserve space for symmetry
                }

                Spacer()

                Text(title)
                    .font(.title2)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)

                Spacer()

                if let trailing = trailingButton {
                    trailing()
                } else {
                    Spacer().frame(width: 60) // reserve space
                }
            }
            .padding(.horizontal)
            .padding(.vertical)
            Divider()
            

            // Content goes here
            Spacer()
        }
        .frame(height: 70)
    }
}

#Preview {
    NavigationBarView(title: "")
}
