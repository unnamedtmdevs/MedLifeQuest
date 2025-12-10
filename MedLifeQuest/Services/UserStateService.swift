//
//  UserStateService.swift
//  MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import Foundation
import SwiftUI

class UserStateService: ObservableObject {
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @AppStorage("userName") var userName: String = ""
    @AppStorage("selectedTheme") var selectedTheme: String = "default"
    
    // Symptom data persistence
    @Published var symptoms: [Symptom] = []
    @Published var reminders: [HealthReminder] = []
    
    private let symptomsKey = "savedSymptoms"
    private let remindersKey = "savedReminders"
    
    init() {
        loadSymptoms()
        loadReminders()
    }
    
    func completeOnboarding(userName: String) {
        self.userName = userName
        self.hasCompletedOnboarding = true
    }
    
    func resetAccount() {
        hasCompletedOnboarding = false
        userName = ""
        selectedTheme = "default"
        symptoms = []
        reminders = []
        UserDefaults.standard.removeObject(forKey: symptomsKey)
        UserDefaults.standard.removeObject(forKey: remindersKey)
    }
    
    func addSymptom(_ symptom: Symptom) {
        symptoms.insert(symptom, at: 0)
        saveSymptoms()
    }
    
    func deleteSymptom(_ symptom: Symptom) {
        symptoms.removeAll { $0.id == symptom.id }
        saveSymptoms()
    }
    
    func addReminder(_ reminder: HealthReminder) {
        reminders.append(reminder)
        saveReminders()
    }
    
    func updateReminder(_ reminder: HealthReminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            saveReminders()
        }
    }
    
    func deleteReminder(_ reminder: HealthReminder) {
        reminders.removeAll { $0.id == reminder.id }
        saveReminders()
    }
    
    private func saveSymptoms() {
        if let encoded = try? JSONEncoder().encode(symptoms) {
            UserDefaults.standard.set(encoded, forKey: symptomsKey)
        }
    }
    
    private func loadSymptoms() {
        if let data = UserDefaults.standard.data(forKey: symptomsKey),
           let decoded = try? JSONDecoder().decode([Symptom].self, from: data) {
            symptoms = decoded
        }
    }
    
    private func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            UserDefaults.standard.set(encoded, forKey: remindersKey)
        }
    }
    
    private func loadReminders() {
        if let data = UserDefaults.standard.data(forKey: remindersKey),
           let decoded = try? JSONDecoder().decode([HealthReminder].self, from: data) {
            reminders = decoded
        }
    }
}

