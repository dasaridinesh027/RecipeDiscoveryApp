//
//  TagsView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 12/10/25.
//

import SwiftUI

struct TagName: Identifiable {
    let id = UUID()
    let title: String
}

import Foundation
import SwiftUI

struct TagsView: View {
    
    @ObservedObject var recipeViewModel: RecipeViewModel
    
    @State private var selectedTag: UUID?
    @State private var recipes: [String] = []
    @State private var skip = 0
    
    let tagNames: [TagName] = [
        TagName(title: "Vegetarian"),
        TagName(title: "Dessert"),
        TagName(title: "Pizza"),
        TagName(title: "Quick")
    ]
    
    var body: some View {
        VStack {
            tagView()
        }
    }
    
    @ViewBuilder
    func tagView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tagNames) { tagName in
                    Button(action: {
                        selectedTag = tagName.id
                        recipes.removeAll()
                        skip = recipes.count
                        recipeViewModel.callAPI(API.Endpoint.tag(type: tagName.title).urlString)
                    }) {
                        Text(tagName.title)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedTag == tagName.id ? .white : .black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedTag == tagName.id ? Color.blue : Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedTag == tagName.id ? Color.blue : Color.gray, lineWidth: 1)
                            )
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
    }
}
//#Preview {
//    TagsView()
//}
