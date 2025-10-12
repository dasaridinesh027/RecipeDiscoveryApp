//
//  RecipeListView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 09/10/25.
//

import SwiftUI

struct RecipeListView: View {
    
    @StateObject private var alertManager = AlertManager.shared

    @StateObject private var vm = RecipeViewModel()
    @State var showSortingPopup = false
    
   
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
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
                        ZStack {
                            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                            LoadingView()
                        }
                    }
                }
                .navigationTitle("Recipes")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showSortingPopup = true
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                .attachAlertManager(alertManager)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if vm.recipes.isEmpty {
                            vm.loadMoreIfNeeded()
                        }
                    }
                    
                }
                
                
            }
            
            if showSortingPopup {
                
                SortOptionView(showSortingPopup: $showSortingPopup, vm: vm)
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
                vm.selectedTag = nil
                vm.callSearchAPI(searchText)
                

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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
               
                ForEach(vm.tags, id: \.self) { tagName in
                    Button(action: {
                        vm.selectedTag = tagName
                        vm.recipes.removeAll()
                        vm.skip = vm.recipes.count
                        vm.callAPI(API.Endpoint.tag(type: tagName).urlString)
                    }) {
                        Text(tagName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(vm.selectedTag == tagName ? .white : .black)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(vm.selectedTag == tagName ? Color.blue : Color(.systemGray6))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(vm.selectedTag == tagName ? Color.blue : Color.gray, lineWidth: 1)
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
            } else if vm.isLoading {
                ZStack {
                    Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
                    LoadingView()
                }
            } else {
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



