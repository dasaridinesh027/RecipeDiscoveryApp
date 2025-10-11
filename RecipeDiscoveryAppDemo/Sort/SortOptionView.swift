//
//  SortOptionView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 10/10/25.
//

import SwiftUI

struct SortOptionView: View {
    

    @Binding var showSortingPopup: Bool
    @ObservedObject var vm : RecipeViewModel
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Sort By")
                    .font(.headline)
                    .foregroundColor(.black)
                    .listRowInsets(EdgeInsets())
                Spacer()
                   
            }.frame(maxWidth: .infinity)
                .padding()
                .background(.clear)
              Divider()
            List {
                ForEach(sortOptions) { item in
                    Text(item.title)
                        .onTapGesture {
                            print("item::\(item.id)")
                            switch item.id {
                                case 1:
                                    vm.sortBy = "name"
                                    vm.order = "asc"
                                    break
                                case 2:
                                    vm.sortBy = "name"
                                    vm.order = "desc"
                                    break
                                case 3:
                                    vm.sortBy = "cookingTime"
                                    vm.order = "asc"
                                    break
                                case 4:
                                    vm.sortBy = "cookingTime"
                                    vm.order = "desc"
                                    break
                                case 5:
                                    vm.sortBy = "rating"
                                    vm.order = "asc"
                                    break
                                case 6:
                                    vm.sortBy = "rating"
                                    vm.order = "desc"
                                    break
                                case 7:
                                    vm.sortBy = "difficulty"
                                    vm.order = "asc"
                                    break
                                case 8:
                                    vm.sortBy = "difficulty"
                                    vm.order = "desc"
                                    break
                                default:
                                    break
                            }
                            callSortAPI()
                            self.showSortingPopup = false
                        }
                }
            }.listStyle(PlainListStyle())
            
            
            
        }.frame(width: 300, height: 400)
            .background(Color(.white))
            .cornerRadius(12)
            .shadow(radius: 40)
            .overlay(Button {
                showSortingPopup = false
            } label: {
                DismissButton()
            }, alignment: .topTrailing)
    }
    
    func callSortAPI() {
        vm.recipes.removeAll()
        vm.skip = vm.recipes.count
        let params: [String: Any] = ["limit": vm.limit, "skip": vm.skip,
                                     "sortBy":vm.sortBy, "order": vm.order]
        
        Task{
            await vm.loadRecipesWith(params)
        }
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
                .imageScale(.small)
                .frame(width: 44, height: 44)
                .foregroundColor(.black)
        }
    }
}


