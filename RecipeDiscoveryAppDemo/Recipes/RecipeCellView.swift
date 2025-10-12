//
//  RecipeCellView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI

struct RecipeCellView: View {
    let recipe: Recipe?

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Recipe image
            RemoteImageView(urlString: recipe?.image ?? "", width: 90, height: 60)
                .cornerRadius(5)

            // Recipe details
            VStack(alignment: .leading, spacing: 6) {
                // Recipe name
                Text(recipe?.name ?? "Unknown Recipe")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.leading)


                // Cook time & servings
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Text("\(recipe?.cookTimeMinutes ?? 0) mins")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }


                    Spacer()

                    HStack(spacing: 3) {
                        Image(systemName: "person.2.fill") 
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.gray)

                        Text("\(recipe?.servings ?? 0) Servings")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }

                }

                // Rating & difficulty
                HStack {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(recipe?.rating ?? 0) ? "star.fill" : "star")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .foregroundColor(.yellow)
                        }
                        
                        Text(String(format: "%.1f", recipe?.rating ?? 0))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black)
                            .lineLimit(1)
                    }


                    Spacer()

                    HStack(spacing: 6) {
                        // Colored circle
                        Circle()
                            .fill(colorForDifficulty(recipe?.difficulty))
                            .frame(width: 10, height: 10)

                        // Difficulty text
                        Text(recipe?.difficulty.rawValue ?? "-")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.black)
                            .lineLimit(1)

                        // Optional: background pill for emphasis
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                    )


                }

                // Cuisine tag
                if let cuisine = recipe?.cuisine, !cuisine.isEmpty {
                    Text(cuisine)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                        .lineLimit(1)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(.systemGray6))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                        )
                }
            }

            Spacer()
        }
        .padding(.vertical, 6)
    }
}


#Preview {
    RecipeCellView(recipe: nil)
}
