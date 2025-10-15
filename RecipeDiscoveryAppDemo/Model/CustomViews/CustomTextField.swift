//
//  CustomTextField.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 13/10/25.
//
import SwiftUI


struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var isDisabled: Bool = false
    
    var body: some View {
        HStack(spacing: 10) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.gray)
            }
            
            TextField(placeholder, text: $text)
                .disabled(isDisabled)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.black)
        }
        
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

#Preview {

    CustomTextField(placeholder: "Username", text: .constant(""))
        .padding()
        .previewLayout(.sizeThatFits)
}


