//
//  HomeViewModel.swift
//  MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var healthTips: [HealthTip] = []
    @Published var quizQuestions: [QuizQuestion] = []
    @Published var currentQuizIndex: Int = 0
    @Published var quizScore: Int = 0
    @Published var showQuizResult: Bool = false
    @Published var selectedAnswer: Int? = nil
    @Published var hasAnswered: Bool = false
    
    private let healthDataService = HealthDataService.shared
    
    init() {
        loadQuizQuestions()
    }
    
    func loadHealthTips(for symptoms: [Symptom]) {
        healthTips = healthDataService.getHealthTips(for: symptoms)
    }
    
    func getAdvice(for symptom: Symptom) -> String {
        return healthDataService.getAdviceForSymptom(symptom)
    }
    
    func loadQuizQuestions() {
        quizQuestions = healthDataService.getQuizQuestions().shuffled()
        currentQuizIndex = 0
        quizScore = 0
        showQuizResult = false
        selectedAnswer = nil
        hasAnswered = false
    }
    
    func selectAnswer(_ index: Int) {
        guard !hasAnswered else { return }
        selectedAnswer = index
        hasAnswered = true
        
        if index == quizQuestions[currentQuizIndex].correctAnswerIndex {
            quizScore += 1
        }
    }
    
    func nextQuestion() {
        if currentQuizIndex < quizQuestions.count - 1 {
            currentQuizIndex += 1
            selectedAnswer = nil
            hasAnswered = false
        } else {
            showQuizResult = true
        }
    }
    
    func restartQuiz() {
        loadQuizQuestions()
    }
    
    var currentQuestion: QuizQuestion? {
        guard currentQuizIndex < quizQuestions.count else { return nil }
        return quizQuestions[currentQuizIndex]
    }
    
    var quizProgress: Double {
        guard !quizQuestions.isEmpty else { return 0 }
        return Double(currentQuizIndex + 1) / Double(quizQuestions.count)
    }
}

