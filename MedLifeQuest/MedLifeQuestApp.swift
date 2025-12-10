//
//  MedLifeQuestApp.swift
//  X-MedLifeQuest
//
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
