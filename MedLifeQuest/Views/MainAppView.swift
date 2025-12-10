//
//  MainAppView.swift
//  X-MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var userStateService: UserStateService
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(1)
        }
        .accentColor(Color(hex: "86b028"))
    }
}

