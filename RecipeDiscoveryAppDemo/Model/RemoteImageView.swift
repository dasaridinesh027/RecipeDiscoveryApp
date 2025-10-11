//
//  RemoteImageView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 10/10/25.
//

import SwiftUICore
import SwiftUI


struct RemoteImageView: View {
    let urlString: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
          
            case .success(let image):
                // Successfully loaded image
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .cornerRadius(8)
                case .failure, .empty:
                    Image(systemName: "fork.knife.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .foregroundColor(.accentColor)
                        .background(Color(.systemGray6))
                        .clipShape(Rectangle())
                        .cornerRadius(8)
            @unknown default:
                    Image(systemName: "fork.knife.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width, height: height)
                        .foregroundColor(.accentColor)
                        .background(Color(.systemGray6))
                        .clipShape(Rectangle())
                        .cornerRadius(8)
            }
        }
    }
}
