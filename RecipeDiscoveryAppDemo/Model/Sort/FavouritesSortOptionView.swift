//
//  FavouritesSortOptionView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 13/10/25.
//

import SwiftUI

struct FavouritesSortOptionView: View {
    
    @Binding var showFavouritesSortingPopup: Bool
    @ObservedObject var vm: FavouritesViewModel
    
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
                        if vm.sortFavouritesByOptionID == item.id {
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
                    showFavouritesSortingPopup = false
                } label: {
                    DismissButton()
                }
                    .padding(8),
                alignment: .topTrailing
            )
        }
        .transition(.opacity)
        .animation(.easeInOut, value: showFavouritesSortingPopup)
    }
    
    private func applySort(_ id: Int) {
       
        switch id {
            case 1:
                vm.sortDescriptor = [SortDescriptor(\.name, order: .forward)]
            case 2:
                vm.sortDescriptor = [SortDescriptor(\.name, order: .reverse)]
            case 3:
                vm.sortDescriptor = [SortDescriptor(\.cookTimeMinutes, order: .forward)]
            case 4:
                vm.sortDescriptor = [SortDescriptor(\.cookTimeMinutes, order: .reverse)]
            case 5:
                vm.sortDescriptor = [SortDescriptor(\.rating, order: .reverse)]
            case 6:
                vm.sortDescriptor = [SortDescriptor(\.rating, order: .forward)]
            case 7:
                vm.sortDescriptor = [SortDescriptor(\.difficulty, order: .reverse)]
            case 8:
                vm.sortDescriptor = [SortDescriptor(\.difficulty, order: .forward)]
            default:
                vm.sortDescriptor = [SortDescriptor(\.name, order: .forward)]
        }
        vm.sortFavouritesByOptionID = id
        showFavouritesSortingPopup = false
        
        //vm.fetchFavouritesSort()
       
        
    }
}
