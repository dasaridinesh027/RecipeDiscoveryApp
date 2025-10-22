//
//  RecipeListView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var vm = RecipeViewModel()
    @State var showSortingPopup = false
    
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 10) {
                    searchView()
                    tagsView()
                    
                    
                    recipeList()
                }
                .padding(.top)
                .blur(radius: showSortingPopup ? 20 : 0)
                .disabled(showSortingPopup)
                .animation(.easeInOut, value: showSortingPopup)
                
                
                if vm.isLoading {
                    LoadingView(message: "Please wait fetching Data...")
                    
                }
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.alertManager.showConfirmation(
                                           title: "Logout",
                                           message: "Are you sure you want to logout?",
                                           confirmTitle: "Logout",
                                           cancelTitle: "Cancel",
                                           confirmAction: {
                                               print("Logged out")
                                               AppState.shared.logout()},
                                           cancelAction: {
                                               print("Cancelled")
                                           }
                                       )
                        
                        
                    
                        
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                        .font(.system(size: 14, weight:.medium))
                        .foregroundColor(.accentColor)
                    }
                }
                
            }
            
            .attachAlertManager(vm.alertManager)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if vm.recipes.isEmpty {
                        vm.loadMoreIfNeeded()
                    }
                }
                
            }
            
            
        }.overlay{
            if showSortingPopup {
                
                SortOptionView( showSortingPopup: $showSortingPopup, vm: vm)
                    .transition(.opacity)
            }
        }
        
        
    }
    
    
    @ViewBuilder
    func searchView() -> some View {
        HStack(spacing: 8) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            // Search text field
            TextField("Search recipes...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(8)
                .background(Color.clear)
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Spacer()
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                vm.recipes.removeAll()
                                vm.selectedTag = nil
                                vm.callAPI(API.Endpoint.recipes.urlString)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
            
            //Search button
            Button(action: {
                let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard !trimmedText.isEmpty else {
                    vm.alertManager.show(title: "Alert", message: "Please enter a search term")
                    return
                }
                
                vm.selectedTag = nil
                vm.callSearchAPI(trimmedText)
                
                
            }) {
                Text("Search")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color(.systemGray4))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
    
    
    
    @ViewBuilder
    func tagsView() -> some View {
        HStack() {
            
            Button(action: {
                showSortingPopup = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(
                            LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint: .bottom)
                        )
                    
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            }.padding(.leading, 18)
            
            //if !vm.tags.isEmpty {
            
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    
                    ForEach(vm.tags, id: \.self) { tagName in
                        Button(action: {

                            if vm.selectedTag == tagName {
                               
                                vm.selectedTag = nil
                                vm.recipes.removeAll()
                                vm.skip = 0
                                vm.callAPI(API.Endpoint.recipes.urlString)
                            } else {
                                
                                vm.selectedTag = tagName
                                vm.recipes.removeAll()
                                vm.skip = 0
                                vm.callAPI(API.Endpoint.tag(type: tagName).urlString)
                            }
                        }) {
                            Text(tagName)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(vm.selectedTag == tagName ? .white : .black)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(vm.selectedTag == tagName ? Color.orange : Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(vm.selectedTag == tagName ? Color.orange : Color.gray, lineWidth: 1)
                                )
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                    }
                }
                .padding(.horizontal,6)
                .padding(.vertical, 6)
            }
            // }
        }
    }
    
    
    @ViewBuilder
    func recipeList() -> some View {
        ZStack {
            if !vm.recipes.isEmpty {
                List {
                    ForEach(vm.recipes) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipeID: recipe.id)) {
                            RecipeCellView(recipe: recipe)
                        }
                        .onAppear {
                            if recipe == vm.recipes.last {
                                vm.loadMoreIfNeeded()
                            }
                        }
                    }
                    
                    if vm.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
            }else {
                EmptyStateView(
                    imageName: "recipeIcon",
                    message: "No recipes found"
                )
            }
        }
    }
    
}
#Preview {
    RecipeListView()
}



