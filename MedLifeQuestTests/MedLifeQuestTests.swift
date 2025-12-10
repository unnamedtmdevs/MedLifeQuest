//
//  MedLifeQuestTests.swift
//  MedLifeQuestTests
//
//

import XCTest
@testable import MedLifeQuest

final class MedLifeQuestTests: XCTestCase {
    
    var userStateService: UserStateService!
    var homeViewModel: HomeViewModel!
    var settingsViewModel: SettingsViewModel!
    var healthDataService: HealthDataService!

    override func setUpWithError() throws {
        userStateService = UserStateService()
        homeViewModel = HomeViewModel()
        settingsViewModel = SettingsViewModel()
        healthDataService = HealthDataService.shared
    }

    override func tearDownWithError() throws {
        userStateService = nil
        homeViewModel = nil
        settingsViewModel = nil
    }

    // MARK: - Model Tests
    
    func testSymptomCreation() throws {
        let symptom = Symptom(
            title: "Headache",
            severity: .mild,
            description: "Mild headache",
            category: .headache
        )
        
        XCTAssertEqual(symptom.title, "Headache")
        XCTAssertEqual(symptom.severity, .mild)
        XCTAssertEqual(symptom.category, .headache)
    }
    
    func testHealthTipCreation() throws {
        let tip = HealthTip(
            title: "Stay Hydrated",
            content: "Drink 8 glasses of water",
            category: .hydration,
            relatedSymptoms: [.headache]
        )
        
        XCTAssertEqual(tip.title, "Stay Hydrated")
        XCTAssertEqual(tip.category, .hydration)
        XCTAssertTrue(tip.relatedSymptoms.contains(.headache))
    }
    
    func testHealthReminderCreation() throws {
        let reminder = HealthReminder(
            title: "Take medication",
            time: Date(),
            isEnabled: true,
            repeatDaily: true,
            type: .medication
        )
        
        XCTAssertEqual(reminder.title, "Take medication")
        XCTAssertTrue(reminder.isEnabled)
        XCTAssertTrue(reminder.repeatDaily)
        XCTAssertEqual(reminder.type, .medication)
    }
    
    // MARK: - UserStateService Tests
    
    func testCompleteOnboarding() throws {
        userStateService.completeOnboarding(userName: "Test User")
        
        XCTAssertTrue(userStateService.hasCompletedOnboarding)
        XCTAssertEqual(userStateService.userName, "Test User")
    }
    
    func testAddSymptom() throws {
        let symptom = Symptom(
            title: "Test Symptom",
            severity: .mild,
            description: "Test",
            category: .headache
        )
        
        userStateService.addSymptom(symptom)
        
        XCTAssertEqual(userStateService.symptoms.count, 1)
        XCTAssertEqual(userStateService.symptoms.first?.title, "Test Symptom")
    }
    
    func testDeleteSymptom() throws {
        let symptom = Symptom(
            title: "Test Symptom",
            severity: .mild,
            description: "Test",
            category: .headache
        )
        
        userStateService.addSymptom(symptom)
        XCTAssertEqual(userStateService.symptoms.count, 1)
        
        userStateService.deleteSymptom(symptom)
        XCTAssertEqual(userStateService.symptoms.count, 0)
    }
    
    func testAddReminder() throws {
        let reminder = HealthReminder(
            title: "Test Reminder",
            time: Date(),
            type: .medication
        )
        
        userStateService.addReminder(reminder)
        
        XCTAssertEqual(userStateService.reminders.count, 1)
        XCTAssertEqual(userStateService.reminders.first?.title, "Test Reminder")
    }
    
    func testDeleteReminder() throws {
        let reminder = HealthReminder(
            title: "Test Reminder",
            time: Date(),
            type: .medication
        )
        
        userStateService.addReminder(reminder)
        XCTAssertEqual(userStateService.reminders.count, 1)
        
        userStateService.deleteReminder(reminder)
        XCTAssertEqual(userStateService.reminders.count, 0)
    }
    
    func testResetAccount() throws {
        userStateService.completeOnboarding(userName: "Test User")
        let symptom = Symptom(title: "Test", severity: .mild, description: "Test", category: .headache)
        userStateService.addSymptom(symptom)
        
        userStateService.resetAccount()
        
        XCTAssertFalse(userStateService.hasCompletedOnboarding)
        XCTAssertEqual(userStateService.userName, "")
        XCTAssertEqual(userStateService.symptoms.count, 0)
    }
    
    // MARK: - HealthDataService Tests
    
    func testGetHealthTipsWithNoSymptoms() throws {
        let tips = healthDataService.getHealthTips(for: [])
        
        XCTAssertEqual(tips.count, 3)
    }
    
    func testGetHealthTipsWithSymptoms() throws {
        let symptom = Symptom(
            title: "Headache",
            severity: .mild,
            description: "Test",
            category: .headache
        )
        
        let tips = healthDataService.getHealthTips(for: [symptom])
        
        XCTAssertEqual(tips.count, 3)
    }
    
    func testGetAdviceForSymptom() throws {
        let symptom = Symptom(
            title: "Headache",
            severity: .mild,
            description: "Test",
            category: .headache
        )
        
        let advice = healthDataService.getAdviceForSymptom(symptom)
        
        XCTAssertFalse(advice.isEmpty)
        XCTAssertTrue(advice.contains("hydrated") || advice.contains("rest"))
    }
    
    func testGetQuizQuestions() throws {
        let questions = healthDataService.getQuizQuestions()
        
        XCTAssertGreaterThan(questions.count, 0)
        XCTAssertTrue(questions.allSatisfy { $0.options.count > 0 })
        XCTAssertTrue(questions.allSatisfy { $0.correctAnswerIndex < $0.options.count })
    }
    
    // MARK: - HomeViewModel Tests
    
    func testLoadQuizQuestions() throws {
        homeViewModel.loadQuizQuestions()
        
        XCTAssertGreaterThan(homeViewModel.quizQuestions.count, 0)
        XCTAssertEqual(homeViewModel.currentQuizIndex, 0)
        XCTAssertEqual(homeViewModel.quizScore, 0)
        XCTAssertFalse(homeViewModel.showQuizResult)
    }
    
    func testSelectAnswer() throws {
        homeViewModel.loadQuizQuestions()
        let correctAnswer = homeViewModel.quizQuestions[0].correctAnswerIndex
        
        homeViewModel.selectAnswer(correctAnswer)
        
        XCTAssertTrue(homeViewModel.hasAnswered)
        XCTAssertEqual(homeViewModel.selectedAnswer, correctAnswer)
        XCTAssertEqual(homeViewModel.quizScore, 1)
    }
    
    func testSelectWrongAnswer() throws {
        homeViewModel.loadQuizQuestions()
        let correctAnswer = homeViewModel.quizQuestions[0].correctAnswerIndex
        let wrongAnswer = (correctAnswer + 1) % homeViewModel.quizQuestions[0].options.count
        
        homeViewModel.selectAnswer(wrongAnswer)
        
        XCTAssertTrue(homeViewModel.hasAnswered)
        XCTAssertEqual(homeViewModel.selectedAnswer, wrongAnswer)
        XCTAssertEqual(homeViewModel.quizScore, 0)
    }
    
    func testQuizProgress() throws {
        homeViewModel.loadQuizQuestions()
        
        let progress = homeViewModel.quizProgress
        XCTAssertGreaterThan(progress, 0)
        XCTAssertLessThanOrEqual(progress, 1.0)
    }
    
    // MARK: - SettingsViewModel Tests
    
    func testGetTheme() throws {
        let theme = settingsViewModel.getTheme(id: "default")
        
        XCTAssertEqual(theme.id, "default")
        XCTAssertEqual(theme.name, "Default")
    }
    
    func testAvailableThemes() throws {
        XCTAssertGreaterThan(settingsViewModel.availableThemes.count, 0)
        XCTAssertTrue(settingsViewModel.availableThemes.contains { $0.id == "default" })
    }
    
    // MARK: - Color Extension Tests
    
    func testColorFromHex() throws {
        let color = Color(hex: "213d62")
        XCTAssertNotNil(color)
    }

}
