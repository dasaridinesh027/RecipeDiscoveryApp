//
//  LoginView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 13/10/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var alertManager = AlertViewManager.shared
    @StateObject private var vm = LoginViewModel()
    
    @State private var username: String = "test@test.com"
    @State private var password: String = "Abc@12"
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.orange.opacity(0.8), Color.red.opacity(0.7)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    
                    VStack(spacing: 10) {
                        Image(systemName: "fork.knife.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .shadow(radius: 8)
                        
                        
                        Text("Recipe Discovery")
                            .font(.system(size: 27, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
                    }
                    .padding(.bottom, 20)
                    
                    CustomTextField(
                        placeholder: "Username",
                        text: $username,
                        icon: "envelope"
                    )
                    
                    CustomSecureField(
                        placeholder: "Password",
                        text: $password,
                        icon: "lock"
                    )
                    .padding(.bottom, 30)
                    
                    HStack() {
                        
                        Spacer()
                        
                        Button {
                            
                            Task {
                                await vm.login(username: username, password: password)
                            }
                        } label: {
                            HStack(spacing: 8) {
                                if vm.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundColor(.white)
                                }
                                
                                Text(vm.isLoading ? "LOGGING IN..." : "LOGIN")
                                    .font(.headline)
                                //.fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 30)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        //.padding(.top, 20)
                        .disabled(vm.isLoading)
                        .animation(.easeInOut(duration: 0.2), value: vm.isLoading)
                    }
                    
                }.padding(.horizontal, 30)
                    .attachAlertManager(vm.alertViewManager)
                
                //                if vm.isLoading {
                //                    LoadingView(message: "Logging in...")
                //                }
                
                
                    .disabled(vm.isLoading)
            }
            .navigationDestination(isPresented: $vm.isLoggedIn) {
                TabContentView().navigationBarBackButtonHidden(true)
            }
            
            
            
        }
    }
}

#Preview {
    LoginView()
}
