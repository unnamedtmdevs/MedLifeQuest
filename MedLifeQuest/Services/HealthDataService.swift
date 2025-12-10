//
//  HealthDataService.swift
//  X-MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import Foundation

class HealthDataService {
    static let shared = HealthDataService()
    
    private init() {}
    
    func getHealthTips(for symptoms: [Symptom]) -> [HealthTip] {
        let allTips = getAllHealthTips()
        
        if symptoms.isEmpty {
            return Array(allTips.shuffled().prefix(3))
        }
        
        let symptomCategories = Set(symptoms.map { $0.category })
        let relevantTips = allTips.filter { tip in
            !Set(tip.relatedSymptoms).isDisjoint(with: symptomCategories)
        }
        
        if relevantTips.isEmpty {
            return Array(allTips.shuffled().prefix(3))
        }
        
        return Array(relevantTips.shuffled().prefix(3))
    }
    
    func getAdviceForSymptom(_ symptom: Symptom) -> String {
        switch symptom.category {
        case .headache:
            return "Stay hydrated and rest in a quiet, dark room. If headaches persist or worsen, consult a healthcare provider."
        case .fatigue:
            return "Ensure you're getting 7-9 hours of quality sleep. Regular exercise and a balanced diet can help improve energy levels."
        case .digestive:
            return "Eat smaller, more frequent meals. Avoid spicy or fatty foods. Stay hydrated and consider probiotic-rich foods."
        case .respiratory:
            return "Stay hydrated, use a humidifier, and rest. If breathing difficulties persist or worsen, seek medical attention immediately."
        case .musculoskeletal:
            return "Apply ice for acute pain or heat for chronic pain. Gentle stretching and proper posture can help. Consider physical therapy if pain persists."
        case .skin:
            return "Keep the area clean and moisturized. Avoid irritants and allergens. If symptoms persist or worsen, consult a dermatologist."
        case .mental:
            return "Practice stress-reduction techniques like meditation or deep breathing. Regular exercise and adequate sleep are important. Consider speaking with a mental health professional."
        case .other:
            return "Monitor your symptoms carefully. Keep a symptom diary to track patterns. Consult a healthcare provider if symptoms persist or cause concern."
        }
    }
    
    func getQuizQuestions() -> [QuizQuestion] {
        return [
            QuizQuestion(
                question: "How much water should an average adult drink per day?",
                options: ["4 glasses", "8 glasses", "12 glasses", "16 glasses"],
                correctAnswerIndex: 1,
                explanation: "The general recommendation is about 8 glasses (64 ounces) of water per day, though individual needs may vary based on activity level and climate.",
                category: .other
            ),
            QuizQuestion(
                question: "What is the recommended amount of sleep for adults?",
                options: ["5-6 hours", "7-9 hours", "10-12 hours", "4-5 hours"],
                correctAnswerIndex: 1,
                explanation: "Most adults need 7-9 hours of quality sleep per night for optimal health and functioning.",
                category: .fatigue
            ),
            QuizQuestion(
                question: "Which of these is a common trigger for headaches?",
                options: ["Dehydration", "Regular exercise", "Fresh air", "Adequate sleep"],
                correctAnswerIndex: 0,
                explanation: "Dehydration is a common headache trigger. Other triggers include stress, lack of sleep, and certain foods.",
                category: .headache
            ),
            QuizQuestion(
                question: "How often should adults engage in moderate physical activity?",
                options: ["Once a week", "2-3 times per week", "At least 150 minutes per week", "Every day for 2 hours"],
                correctAnswerIndex: 2,
                explanation: "Health organizations recommend at least 150 minutes of moderate-intensity aerobic activity per week for adults.",
                category: .musculoskeletal
            ),
            QuizQuestion(
                question: "What is a healthy resting heart rate for adults?",
                options: ["40-50 bpm", "60-100 bpm", "110-120 bpm", "130-140 bpm"],
                correctAnswerIndex: 1,
                explanation: "A normal resting heart rate for adults ranges from 60 to 100 beats per minute. Athletes may have lower rates.",
                category: .other
            ),
            QuizQuestion(
                question: "Which nutrient is essential for bone health?",
                options: ["Vitamin C", "Calcium", "Iron", "Sodium"],
                correctAnswerIndex: 1,
                explanation: "Calcium is crucial for maintaining strong bones and teeth. Vitamin D also helps with calcium absorption.",
                category: .musculoskeletal
            ),
            QuizQuestion(
                question: "What is the best way to manage stress?",
                options: ["Ignore it", "Regular exercise and relaxation techniques", "Work harder", "Skip meals"],
                correctAnswerIndex: 1,
                explanation: "Regular exercise, relaxation techniques like meditation, adequate sleep, and social support are effective stress management strategies.",
                category: .mental
            ),
            QuizQuestion(
                question: "How can you improve digestive health?",
                options: ["Eat large meals before bed", "Include fiber in your diet", "Drink carbonated drinks", "Skip breakfast"],
                correctAnswerIndex: 1,
                explanation: "A diet rich in fiber, staying hydrated, regular exercise, and eating smaller, frequent meals can improve digestive health.",
                category: .digestive
            )
        ]
    }
    
    private func getAllHealthTips() -> [HealthTip] {
        return [
            HealthTip(
                title: "Stay Hydrated",
                content: "Drinking adequate water throughout the day helps maintain body temperature, transport nutrients, and flush out toxins. Aim for 8 glasses daily.",
                category: .hydration,
                relatedSymptoms: [.headache, .fatigue, .skin]
            ),
            HealthTip(
                title: "Regular Exercise",
                content: "Physical activity for at least 30 minutes most days can boost energy, improve mood, and strengthen your immune system.",
                category: .exercise,
                relatedSymptoms: [.fatigue, .mental, .musculoskeletal]
            ),
            HealthTip(
                title: "Quality Sleep",
                content: "Aim for 7-9 hours of sleep each night. Establish a regular sleep schedule and create a relaxing bedtime routine.",
                category: .sleep,
                relatedSymptoms: [.fatigue, .headache, .mental]
            ),
            HealthTip(
                title: "Balanced Nutrition",
                content: "Eat a variety of fruits, vegetables, whole grains, and lean proteins. Limit processed foods and excess sugar.",
                category: .nutrition,
                relatedSymptoms: [.digestive, .fatigue, .skin]
            ),
            HealthTip(
                title: "Stress Management",
                content: "Practice relaxation techniques like deep breathing, meditation, or yoga. Take regular breaks and engage in activities you enjoy.",
                category: .stress,
                relatedSymptoms: [.mental, .headache, .digestive]
            ),
            HealthTip(
                title: "Hand Hygiene",
                content: "Wash your hands frequently with soap and water for at least 20 seconds to prevent the spread of infections.",
                category: .prevention,
                relatedSymptoms: [.respiratory, .digestive]
            ),
            HealthTip(
                title: "Posture Awareness",
                content: "Maintain good posture while sitting and standing. Take breaks to stretch if you sit for long periods.",
                category: .prevention,
                relatedSymptoms: [.musculoskeletal, .headache]
            ),
            HealthTip(
                title: "Skin Protection",
                content: "Use sunscreen daily, moisturize regularly, and stay hydrated to maintain healthy skin.",
                category: .prevention,
                relatedSymptoms: [.skin]
            ),
            HealthTip(
                title: "Breathing Exercises",
                content: "Practice deep breathing exercises to reduce stress, improve oxygen flow, and promote relaxation.",
                category: .stress,
                relatedSymptoms: [.respiratory, .mental, .headache]
            ),
            HealthTip(
                title: "Healthy Eating Schedule",
                content: "Eat regular meals at consistent times. Don't skip breakfast, and avoid heavy meals close to bedtime.",
                category: .nutrition,
                relatedSymptoms: [.digestive, .fatigue]
            ),
            HealthTip(
                title: "Social Connections",
                content: "Maintain strong social relationships. Regular interaction with friends and family supports mental and emotional health.",
                category: .stress,
                relatedSymptoms: [.mental]
            ),
            HealthTip(
                title: "Limit Screen Time",
                content: "Reduce screen time before bed to improve sleep quality. Take regular breaks from screens during the day.",
                category: .prevention,
                relatedSymptoms: [.headache, .fatigue, .mental]
            )
        ]
    }
}

