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
           HStack(alignment: .top) {
               RemoteImageView(urlString: recipe?.image ?? "", width: 90, height: 60)
               
               VStack(alignment: .leading, spacing: 5) {
                   Text(recipe!.name)
                       .font(.system(size: 15, weight: .medium))
                   HStack {
                       HStack(spacing: 2) {
                           Image(systemName: "clock")
                               .imageScale(.small)
                               .foregroundColor(.gray)
                           Text("\(recipe!.cookTimeMinutes) mins")
                               .font(.system(size: 13, weight: .regular))
                               .minimumScaleFactor(0.7)
                               .foregroundColor(.gray)
                               .lineLimit(1)
                       }
                       
                       Spacer()
                       
                       HStack(spacing: 2) {
                           Image(systemName: "list.clipboard")
                               .imageScale(.small)
                               .foregroundColor(.gray)
                           Text("\(recipe!.servings) Servings")
                               .font(.system(size: 13, weight: .regular))
                               .minimumScaleFactor(0.7)
                               .foregroundColor(.gray)
                               .lineLimit(1)
                       }
                       
                     
                       Spacer()
   
                   }
                   
                   HStack {
                       
                       HStack(spacing: 2) {
                           Image(systemName: "star.leadinghalf.filled")
                               .foregroundColor(.yellow)
                           Text("\(String(format: "%.1f", recipe!.rating))")
                               .font(.system(size: 13, weight: .regular))
                               .lineLimit(1)
                               .minimumScaleFactor(0.5)
                       }
                       
            
                       Spacer()
                       
                       HStack(spacing: 2) {
                           Image(systemName: "smallcircle.filled.circle.fill")
                               .imageScale(.small)
                               .foregroundColor(.black)
                           Text(recipe!.difficulty.rawValue)
                               .font(.system(size: 13, weight: .regular))
                               .foregroundColor(.black)
                               .lineLimit(1)
                               .minimumScaleFactor(0.7)
                       }
      
                       Spacer()
                   }
                   Text(recipe!.cuisine)
                       .font(.system(size: 10, weight: .regular))
                       .frame(maxWidth: .infinity)
                       .lineLimit(1)
                       .minimumScaleFactor(0.5)
                       .frame(width: 60, height: 20)
                       .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1)
                       )
               
                  
               }
               
               Spacer()
               
               
           }
           .padding(0)
       }
}

#Preview {
    RecipeCellView(recipe: nil)
}
