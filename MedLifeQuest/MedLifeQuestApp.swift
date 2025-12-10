//
//  MedLifeQuestApp.swift
//  MedLifeQuest
//
//  Created by Simon Bakhanets on 10.12.2025.
//

import SwiftUI

@main
struct MedLifeQuestApp: App {
    @StateObject private var userStateService = UserStateService()
    
    var body: some Scene {
        WindowGroup {
            LauncherView()
                .environmentObject(userStateService)
        }
    }
}
