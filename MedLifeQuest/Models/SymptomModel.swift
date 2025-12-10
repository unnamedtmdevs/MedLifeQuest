//
//  SymptomModel.swift
//  X-MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import Foundation

struct Symptom: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var severity: SeverityLevel
    var description: String
    var dateLogged: Date
    var category: SymptomCategory
    
    init(id: UUID = UUID(), title: String, severity: SeverityLevel, description: String, dateLogged: Date = Date(), category: SymptomCategory) {
        self.id = id
        self.title = title
        self.severity = severity
        self.description = description
        self.dateLogged = dateLogged
        self.category = category
    }
}

enum SeverityLevel: String, Codable, CaseIterable {
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"
    
    var color: String {
        switch self {
        case .mild: return "86b028"
        case .moderate: return "4a8fdc"
        case .severe: return "213d62"
        }
    }
}

enum SymptomCategory: String, Codable, CaseIterable {
    case headache = "Headache"
    case fatigue = "Fatigue"
    case digestive = "Digestive"
    case respiratory = "Respiratory"
    case musculoskeletal = "Musculoskeletal"
    case skin = "Skin"
    case mental = "Mental Health"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .headache: return "brain.head.profile"
        case .fatigue: return "bed.double.fill"
        case .digestive: return "cross.case.fill"
        case .respiratory: return "lungs.fill"
        case .musculoskeletal: return "figure.walk"
        case .skin: return "paintpalette.fill"
        case .mental: return "heart.fill"
        case .other: return "stethoscope"
        }
    }
}

