//
//  AlertView.swift
//  RecipeDiscoveryAppDemo
//
//  Created by My Mac on 11/10/25.
//

import Foundation
import SwiftUI


enum ActiveAlert: Identifiable {
    
    case delete(entityName: String, action: () -> Void)
    case info(title: String, message: String)
    
    var id: UUID {
        UUID()
        }
}

final class AlertManager: ObservableObject {
    
    @Published var activeAlert: ActiveAlert?

    func showDelete(entityName: String, action: @escaping () -> Void) {
        activeAlert = .delete(entityName: entityName, action: action)
    }
    
    func showInfo(title: String, message: String) {
        activeAlert = .info(title: title, message: message)
    }
    

}
