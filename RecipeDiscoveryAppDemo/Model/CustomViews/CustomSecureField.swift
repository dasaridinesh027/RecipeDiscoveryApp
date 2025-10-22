//
//  CustomSecureField.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 13/10/25.
//


import SwiftUI

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    var icon: String? = nil
    
    @State private var isSecure: Bool = true
    
    var body: some View {
        HStack(spacing: 10) {
            // Optional icon
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.gray)
            }
            
            // Secure or plain text
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .accessibilityIdentifier(placeholder)
                } else {
                    TextField(placeholder, text: $text)
                        .accessibilityIdentifier(placeholder)
                }
            }
            
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .foregroundColor(.black)
            
            // Toggle button
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
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
    CustomSecureField(placeholder: "Password", text: .constant(""))
        .padding()
        .previewLayout(.sizeThatFits)
}
