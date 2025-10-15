//
//  LoginViewModel.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 13/10/25.
//

import Foundation
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @ObservedObject private var appState = AppState.shared
    
    let userName: String = "test@test.com"
    let passWord: String = "Abc@12"
    
    @ObservedObject var alertManager = AlertManager.shared
    
    @Published var isLoading = false

    @Published var isLoggedIn = false
    
    init() {
        
    }
    
    
     func login(username: String, password: String) async{
        
         let trimmed = username.normalizedEmail
         guard !trimmed.isEmpty, trimmed.isValidEmail else {
             alertManager.show(title: "Alert", message: "Please enter valid username")
             return
         }
   
         let pass = password.trimmingCharacters(in: .whitespacesAndNewlines)
         guard !pass.isEmpty, pass.isValidPassword else {
             alertManager.show(title: "Alert", message: "Password must be at least 6 characters long, include a letter, number, and special character.")
             return
         
         }
         
        isLoading = true
        
        // Fake delay for demo
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
            
            if username.lowercased() == self.userName && password == self.passWord{
                self.isLoggedIn = true
                self.appState.login()
            } else {
                self.alertManager.show(title: "Error", message: "Invalid credentials. Try again.")
            }
        }
    }
    
}
