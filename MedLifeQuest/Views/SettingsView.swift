//
//  SettingsView.swift
//  X-MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userStateService: UserStateService
    @StateObject private var viewModel = SettingsViewModel()
    @State private var reminderToEdit: ReminderFormData? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "213d62")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // User profile section
                        VStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 80))
                                .foregroundColor(Color(hex: "86b028"))
                            
                            Text(userStateService.userName)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("Health Journey Member")
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.white.opacity(0.7))
                        }
                        .padding(.top, 20)
                        
                        // Health reminders section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Health Reminders")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    reminderToEdit = ReminderFormData()
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(hex: "86b028"))
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            if userStateService.reminders.isEmpty {
                                Text("No reminders set. Add one to stay on track!")
                                    .font(.system(size: 15, design: .rounded))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                            } else {
                                ForEach(userStateService.reminders) { reminder in
                                    ReminderCard(reminder: reminder) { updatedReminder in
                                        userStateService.updateReminder(updatedReminder)
                                    } onDelete: {
                                        userStateService.deleteReminder(reminder)
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        // Settings section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Preferences")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "paintpalette.fill",
                                    title: "Theme",
                                    value: "Coming Soon"
                                ) {}
                            }
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        }
                        
                        // About section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 0) {
                                SettingsRow(
                                    icon: "info.circle.fill",
                                    title: "Version",
                                    value: "1.0.0"
                                ) {}
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                    .padding(.leading, 60)
                                
                                SettingsRow(
                                    icon: "doc.text.fill",
                                    title: "Privacy Policy",
                                    showChevron: true
                                ) {}
                                
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                    .padding(.leading, 60)
                                
                                SettingsRow(
                                    icon: "checkmark.shield.fill",
                                    title: "Terms of Service",
                                    showChevron: true
                                ) {}
                            }
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                        }
                        
                        // Delete account section
                        Button(action: {
                            viewModel.showDeleteConfirmation = true
                        }) {
                            HStack {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 18))
                                
                                Text("Delete Account")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.red.opacity(0.7))
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 30)
                    }
                    .padding(.top, 1)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .sheet(item: $reminderToEdit) { formData in
                AddReminderView(formData: formData) { reminder in
                    userStateService.addReminder(reminder)
                    reminderToEdit = nil
                }
            }
            .alert("Delete Account", isPresented: $viewModel.showDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    viewModel.deleteAccount(userStateService: userStateService)
                }
            } message: {
                Text("Are you sure you want to delete your account? This will erase all your data and reset the app to its initial state.")
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var value: String = ""
    var showChevron: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "4a8fdc"))
                    .frame(width: 28)
                
                Text(title)
                    .font(.system(size: 17, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                if !value.isEmpty {
                    Text(value)
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(.white.opacity(0.6))
                }
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}


struct ReminderCard: View {
    let reminder: HealthReminder
    let onToggle: (HealthReminder) -> Void
    let onDelete: () -> Void
    @State private var isEnabled: Bool
    
    init(reminder: HealthReminder, onToggle: @escaping (HealthReminder) -> Void, onDelete: @escaping () -> Void) {
        self.reminder = reminder
        self.onToggle = onToggle
        self.onDelete = onDelete
        _isEnabled = State(initialValue: reminder.isEnabled)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: reminder.type.icon)
                .font(.system(size: 24))
                .foregroundColor(Color(hex: "4a8fdc"))
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Text(reminder.time.formatted(date: .omitted, time: .shortened))
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    
                    if reminder.repeatDaily {
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 3, height: 3)
                        
                        Text("Daily")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isEnabled)
                .labelsHidden()
                .tint(Color(hex: "86b028"))
                .onChange(of: isEnabled) { newValue in
                    var updatedReminder = reminder
                    updatedReminder.isEnabled = newValue
                    onToggle(updatedReminder)
                }
            
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 16))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct ReminderFormData: Identifiable {
    let id = UUID()
    var title = ""
    var time = Date()
    var repeatDaily = true
    var type: ReminderType = .medication
}

struct AddReminderView: View {
    @Environment(\.dismiss) var dismiss
    @State var formData: ReminderFormData
    let onSave: (HealthReminder) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "213d62")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reminder Title")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            TextField("e.g., Take vitamins", text: $formData.title)
                                .font(.system(size: 17, design: .rounded))
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Type")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Picker("Type", selection: $formData.type) {
                                ForEach(ReminderType.allCases, id: \.self) { type in
                                    HStack {
                                        Image(systemName: type.icon)
                                        Text(type.rawValue)
                                    }
                                    .tag(type)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                            .accentColor(Color(hex: "86b028"))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Time")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            DatePicker("", selection: $formData.time, displayedComponents: .hourAndMinute)
                                .datePickerStyle(.wheel)
                                .labelsHidden()
                                .colorScheme(.dark)
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                        }
                        
                        Toggle(isOn: $formData.repeatDaily) {
                            HStack {
                                Image(systemName: "repeat")
                                    .foregroundColor(Color(hex: "4a8fdc"))
                                Text("Repeat Daily")
                                    .font(.system(size: 17, design: .rounded))
                                    .foregroundColor(.white)
                            }
                        }
                        .tint(Color(hex: "86b028"))
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        
                        Button(action: {
                            let reminder = HealthReminder(
                                title: formData.title,
                                time: formData.time,
                                isEnabled: true,
                                repeatDaily: formData.repeatDaily,
                                type: formData.type
                            )
                            onSave(reminder)
                        }) {
                            Text("Save Reminder")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(formData.title.isEmpty ? Color.gray : Color(hex: "86b028"))
                                .cornerRadius(16)
                        }
                        .disabled(formData.title.isEmpty)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Add Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "86b028"))
                }
            }
        }
    }
}

