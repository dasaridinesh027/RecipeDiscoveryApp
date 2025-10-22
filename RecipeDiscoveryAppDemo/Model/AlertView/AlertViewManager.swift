//
//  AlertViewManager.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 16/10/25.
//

import Foundation
import SwiftUI

@MainActor

class AlertViewManager: ObservableObject {
    static let shared = AlertViewManager()

    @Published var isPresented: Bool = false
    @Published var title: String = ""
    @Published var message: String = ""
    
    @Published var primaryButtonTitle: String? = nil
    @Published var secondaryButtonTitle: String? = nil
    var primaryAction: (() -> Void)? = nil
    var secondaryAction: (() -> Void)? = nil

    private init() {}

    func show(
        title: String,
        message: String,
        buttonTitle: String = "OK",
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButtonTitle = buttonTitle
        self.primaryAction = action
        self.secondaryButtonTitle = nil
        self.secondaryAction = nil
        self.isPresented = true
    }

    func showConfirmation(
        title: String,
        message: String,
        confirmTitle: String = "OK",
        cancelTitle: String = "Cancel",
        confirmAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButtonTitle = confirmTitle
        self.secondaryButtonTitle = cancelTitle
        self.primaryAction = confirmAction
        self.secondaryAction = cancelAction
        self.isPresented = true
    }

    func dismiss() {
        self.isPresented = false
        self.title = ""
        self.message = ""
        self.primaryAction = nil
        self.secondaryAction = nil
    }
}


extension View {
    func attachAlertManager(_ alertManager: AlertViewManager) -> some View {
        self.alert(alertManager.title, isPresented: Binding(
            get: { alertManager.isPresented },
            set: { alertManager.isPresented = $0 }
        )) {
            if let secondaryTitle = alertManager.secondaryButtonTitle {
                Button(secondaryTitle) {
                    alertManager.secondaryAction?()
                    alertManager.dismiss()
                }
            }

            if let primaryTitle = alertManager.primaryButtonTitle {
                Button(primaryTitle) {
                    alertManager.primaryAction?()
                    alertManager.dismiss()
                }
            }
        } message: {
            Text(alertManager.message)
        }
    }
}

