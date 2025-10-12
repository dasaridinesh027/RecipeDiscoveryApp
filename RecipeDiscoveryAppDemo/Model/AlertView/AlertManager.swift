//
//  AlertView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 11/10/25.
//

import Foundation
import SwiftUI


struct AppAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let primaryButton: Alert.Button
    let secondaryButton: Alert.Button?
    
}

@MainActor
class AlertManager: ObservableObject {
     static let shared = AlertManager() 
    private init() {}
    
    @Published var currentAlert: AppAlert?
    
    // Simple alert
    func show(title: String, message: String) {
        currentAlert = AppAlert(
            title: title,
            message: message,
            primaryButton: .default(Text("OK")),
            secondaryButton: nil
        )
    }
    
    // Confirmation alert
    func showConfirmation(
        title: String,
        message: String,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        confirmAction: @escaping () -> Void
    ) {
        currentAlert = AppAlert(
            title: title,
            message: message,
            primaryButton: .default(Text(confirmTitle), action: confirmAction),
            secondaryButton: .cancel(Text(cancelTitle))
        )
    }
    

}


extension View {
    func attachAlertManager(_ manager: AlertManager = .shared) -> some View {
        let binding = Binding<AppAlert?>(
            get: { manager.currentAlert },
            set: { manager.currentAlert = $0 }
        )

        return self.alert(item: binding) { alertData in
            if let secondary = alertData.secondaryButton {
                return Alert(
                    title: Text(alertData.title),
                    message: Text(alertData.message),
                    primaryButton: alertData.primaryButton,
                    secondaryButton: secondary
                )
            } else {
                return Alert(
                    title: Text(alertData.title),
                    message: Text(alertData.message),
                    dismissButton: alertData.primaryButton
                )
            }
        }
    }
}



