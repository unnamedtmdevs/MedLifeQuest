//
//  HealthTipModel.swift
//  MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import Foundation

struct HealthTip: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var category: TipCategory
    var relatedSymptoms: [SymptomCategory]
    
    init(id: UUID = UUID(), title: String, content: String, category: TipCategory, relatedSymptoms: [SymptomCategory] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.relatedSymptoms = relatedSymptoms
    }
}

enum TipCategory: String, Codable, CaseIterable {
    case nutrition = "Nutrition"
    case exercise = "Exercise"
    case sleep = "Sleep"
    case stress = "Stress Management"
    case hydration = "Hydration"
    case prevention = "Prevention"
    
    var icon: String {
        switch self {
        case .nutrition: return "leaf.fill"
        case .exercise: return "figure.run"
        case .sleep: return "moon.zzz.fill"
        case .stress: return "brain.head.profile"
        case .hydration: return "drop.fill"
        case .prevention: return "shield.fill"
        }
    }
}

struct HealthReminder: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var time: Date
    var isEnabled: Bool
    var repeatDaily: Bool
    var type: ReminderType
    
    init(id: UUID = UUID(), title: String, time: Date, isEnabled: Bool = true, repeatDaily: Bool = true, type: ReminderType) {
        self.id = id
        self.title = title
        self.time = time
        self.isEnabled = isEnabled
        self.repeatDaily = repeatDaily
        self.type = type
    }
}

enum ReminderType: String, Codable, CaseIterable {
    case medication = "Medication"
    case appointment = "Appointment"
    case exercise = "Exercise"
    case hydration = "Water"
    case custom = "Custom"
    
    var icon: String {
        switch self {
        case .medication: return "pills.fill"
        case .appointment: return "calendar.badge.clock"
        case .exercise: return "figure.run"
        case .hydration: return "drop.fill"
        case .custom: return "bell.fill"
        }
    }
}

struct QuizQuestion: Identifiable, Equatable {
    let id: UUID
    var question: String
    var options: [String]
    var correctAnswerIndex: Int
    var explanation: String
    var category: SymptomCategory
    
    init(id: UUID = UUID(), question: String, options: [String], correctAnswerIndex: Int, explanation: String, category: SymptomCategory) {
        self.id = id
        self.question = question
        self.options = options
        self.correctAnswerIndex = correctAnswerIndex
        self.explanation = explanation
        self.category = category
    }
}

