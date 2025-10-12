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
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipped()
                    .cornerRadius(8)
                
            case .failure, .empty:
                placeholderImage
            @unknown default:
                placeholderImage
            }
        }
    }
    
    private var placeholderImage: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray6))
                .frame(width: width, height: height)
            
            Image(systemName: "photo.on.rectangle")
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.5, height: height * 0.5)
                .foregroundColor(.accentColor)
        }
    }


}
