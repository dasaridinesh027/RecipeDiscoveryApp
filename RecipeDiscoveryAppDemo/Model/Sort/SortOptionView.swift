//
//  SortOptionView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 10/10/25.
//

import SwiftUI

struct SortOptionView: View {
    
    @Binding var showSortingPopup: Bool
    @ObservedObject var vm: RecipeViewModel

    var body: some View {
        ZStack {
            // Semi-transparent overlay
            Color.white.opacity(0.1)
                .edgesIgnoringSafeArea(.all)
                .zIndex(1)
            
            // Popup content
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    Text("Sort By")
                        .font(.headline)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                Divider()

                // Sort options list
                List(SortOption.all) { item in
                    HStack {
                        Text(item.title)
                            .foregroundColor(.black)
                        Spacer()
                        if vm.sortByOptionID == item.id {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    .contentShape(Rectangle())
                    .onTapGesture {
                        applySort(item.id)
                    }
        
                        
                }
                .listStyle(PlainListStyle())

            }
            .zIndex(2)
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 20)
            .overlay(
                // Close button
                Button {
                    showSortingPopup = false
                } label: {
                    DismissButton()
                }
                .padding(8),
                alignment: .topTrailing
            )
        }
        .transition(.opacity)
        .animation(.easeInOut, value: showSortingPopup)
    }

    private func applySort(_ id: Int) {
        vm.sortByOptionID = id
        switch id {
        case 1: vm.sortBy = "name"; vm.order = "asc"
        case 2: vm.sortBy = "name"; vm.order = "desc"
        case 3: vm.sortBy = "cookingTime"; vm.order = "asc"
        case 4: vm.sortBy = "cookingTime"; vm.order = "desc"
        case 5: vm.sortBy = "rating"; vm.order = "asc"
        case 6: vm.sortBy = "rating"; vm.order = "desc"
        case 7: vm.sortBy = "difficulty"; vm.order = "asc"
        case 8: vm.sortBy = "difficulty"; vm.order = "desc"
        default: break
        }
        vm.callSortAPI()
        showSortingPopup = false
    }
}

struct DismissButton: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .opacity(0.6)

            Image(systemName: "xmark")
                .foregroundColor(.black)
                .frame(width: 20, height: 20)
        }
    }
}




