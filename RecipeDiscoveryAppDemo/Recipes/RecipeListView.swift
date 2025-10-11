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
    
    @State private var selectedTag: UUID? = nil
    @State private var searchText = ""
    
    var body: some View {
        ZStack {
            NavigationView {
                
                ZStack {
                    VStack() {
                        searchView()
                        tagsView()
                        recipeList()
                    }
                    
                    if vm.isLoading {
                        LoadingView()
                    }
                }
                .navigationTitle("Recieps")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            print("Sort button tapped")
                            showSortingPopup = true
                            
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .alert("Alert", isPresented: $vm.showAlert) {
                Button("OK", role: .cancel) {
                }
            } message: {
                Text(vm.errorMessage ?? "")
            }
            
            .onAppear() {
                print("\n onAppear called")
                if vm.recipes.isEmpty { loadMoreIfNeeded() }
            }
            .blur(radius: showSortingPopup ? 20 : 0)
            .disabled(showSortingPopup )
            
            if showSortingPopup {
                SortOptionView(showSortingPopup: $showSortingPopup, vm: vm)
            }
        }
        
    }
    
    
    
    @ViewBuilder
    func searchView() -> some View {
        
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search recipes...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .overlay(
                    HStack {
                        Spacer()
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                                callAPI(API.Endpoint.recipes.urlString)
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                            .padding(.trailing, 8)
                        }
                    }
                )
                .padding()
            
            Button("Search") {
                callSearchAPI()
            }
            
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding()
        
    }
    @ViewBuilder
    func tagsView() -> some View {
        HStack() {
            
            ForEach(tagNames) { tagName in
                Button(action: {
                    selectedTag = tagName.id
                    vm.recipes.removeAll()
                    vm.skip = vm.recipes.count
                    callAPI(API.Endpoint.tag(type: tagName.title).urlString)
                    
                }) {
                    Text(tagName.title)
                        .frame(maxWidth: .infinity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                }.padding(5)
                    .frame(height: 40)
                    .foregroundColor(selectedTag == tagName.id ? Color.white : Color.black)
                    .background(selectedTag == tagName.id ? Color.gray : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
        }
        .padding()
    }
    
    @ViewBuilder
    func recipeList() -> some View {
        ZStack {
            if  !vm.recipes.isEmpty {
                // print("\n recipes::\(vm.recipes.count)")
                List{
                    ForEach(vm.recipes){ recipe in
                        NavigationLink(destination: RecipeDetailView(recipeID: recipe.id)) {
                            RecipeCellView(recipe: recipe)
                        }
                        .listStyle(.plain)
                        .onAppear() {
                            
                            if recipe.id == vm.recipes.count {
                                print("\(recipe.id)==\(vm.recipes.count)")
                                loadMoreIfNeeded()
                            }
                            
                        }
                    }
                }
            }else{
                EmptyStateView(imageName: "recipeIcon",
                               message: "No recipes found")
            }
        }
    }
    private func callSearchAPI() {
        
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty {
            vm.showAlert = true
            vm.errorMessage = "Please enter a search term"
        }
        else{
            vm.recipes.removeAll()
            vm.skip = vm.recipes.count
            let params: [String: Any] = ["q": searchText]
            Task{
                await vm.loadRecipesWith(params)
            }
        }
        
    }
    private func callAPI(_ api: String) {
        Task{
            await vm.loadRecipes(api)
        }
    }
    
    private func loadMoreIfNeeded() {
        guard !vm.isLoading, vm.hasMoreData else { return }
        
        let params: [String: Any] = ["limit": vm.limit, "skip": vm.skip,
                                     "sortBy":vm.sortBy, "order": vm.order]
        Task{
            await vm.loadRecipesWith(params)
        }
    }
    
}
#Preview {
    RecipeListView()
}



