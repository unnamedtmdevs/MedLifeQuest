//
//  SettingsViewModel.swift
//  X-MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var showDeleteConfirmation = false
    @Published var showingThemeOptions = false
    
    let availableThemes = [
        Theme(id: "default", name: "Default", primaryColor: "213d62", accentColor: "4a8fdc"),
        Theme(id: "nature", name: "Nature", primaryColor: "1a4d2e", accentColor: "86b028"),
        Theme(id: "ocean", name: "Ocean", primaryColor: "1e3a5f", accentColor: "4a8fdc"),
        Theme(id: "sunset", name: "Sunset", primaryColor: "5c2e7e", accentColor: "e76f51")
    ]
    
    func deleteAccount(userStateService: UserStateService) {
        userStateService.resetAccount()
        showDeleteConfirmation = false
    }
    
    func getTheme(id: String) -> Theme {
        availableThemes.first { $0.id == id } ?? availableThemes[0]
    }
}

struct Theme: Identifiable, Equatable {
    let id: String
    let name: String
    let primaryColor: String
    let accentColor: String
    
    var primaryColorValue: Color {
        Color(hex: primaryColor)
    }
    
    var accentColorValue: Color {
        Color(hex: accentColor)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

