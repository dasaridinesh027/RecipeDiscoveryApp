//
//  AppState.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 15/10/25.
//


import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    static let shared = AppState()
    
    private init() {
        // Optionally read from UserDefaults / Keychain
        isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    func login() {
        isLoggedIn = true
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
    }
    
    func logout() {
        isLoggedIn = false
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
    }
}
