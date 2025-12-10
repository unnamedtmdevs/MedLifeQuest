//
//  HomeView.swift
//  MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userStateService: UserStateService
    @StateObject private var viewModel = HomeViewModel()
    @State private var symptomToAdd: SymptomFormData? = nil
    @State private var showQuiz = false
    @State private var selectedSymptom: Symptom? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "213d62")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Welcome header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Hello, \(userStateService.userName)!")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("How are you feeling today?")
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Spacer()
                            
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 44))
                                .foregroundColor(Color(hex: "86b028"))
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // Add symptom button
                        Button(action: {
                            symptomToAdd = SymptomFormData()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                
                                Text("Log New Symptom")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(hex: "4a8fdc"))
                            .cornerRadius(16)
                        }
                        .padding(.horizontal, 20)
                        
                        // Symptoms list
                        if !userStateService.symptoms.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Your Symptoms")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                
                                ForEach(userStateService.symptoms) { symptom in
                                    SymptomCard(symptom: symptom, onTap: {
                                        selectedSymptom = symptom
                                    }, onDelete: {
                                        userStateService.deleteSymptom(symptom)
                                    })
                                    .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        // Health tips section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Health Tips for You")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(Color(hex: "86b028"))
                                    .font(.system(size: 20))
                            }
                            .padding(.horizontal, 20)
                            
                            if viewModel.healthTips.isEmpty {
                                Text("Loading tips...")
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(.horizontal, 20)
                            } else {
                                ForEach(viewModel.healthTips) { tip in
                                    HealthTipCard(tip: tip)
                                        .padding(.horizontal, 20)
                                }
                            }
                        }
                        
                        // Quiz section
                        Button(action: {
                            showQuiz = true
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Test Your Knowledge")
                                        .font(.system(size: 20, weight: .bold, design: .rounded))
                                    
                                    Text("Take an interactive health quiz")
                                        .font(.system(size: 14, design: .rounded))
                                        .opacity(0.9)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 40))
                            }
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "82AF31"), Color(hex: "86b028")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
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
                    Text("MedLifeQuest")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            }
            .sheet(item: $symptomToAdd) { formData in
                AddSymptomView(formData: formData) { symptom in
                    userStateService.addSymptom(symptom)
                    viewModel.loadHealthTips(for: userStateService.symptoms)
                    symptomToAdd = nil
                }
            }
            .sheet(item: $selectedSymptom) { symptom in
                SymptomDetailView(symptom: symptom, advice: viewModel.getAdvice(for: symptom))
            }
            .sheet(isPresented: $showQuiz) {
                QuizView(viewModel: viewModel)
            }
            .onAppear {
                viewModel.loadHealthTips(for: userStateService.symptoms)
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct SymptomCard: View {
    let symptom: Symptom
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: symptom.category.icon)
                    .font(.system(size: 28))
                    .foregroundColor(Color(hex: symptom.severity.color))
                    .frame(width: 50, height: 50)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(symptom.title)
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 8) {
                        Text(symptom.category.rawValue)
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                        
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 3, height: 3)
                        
                        Text(symptom.severity.rawValue)
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(Color(hex: symptom.severity.color))
                    }
                }
                
                Spacer()
                
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
        .buttonStyle(PlainButtonStyle())
    }
}

struct HealthTipCard: View {
    let tip: HealthTip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: tip.category.icon)
                    .font(.system(size: 22))
                    .foregroundColor(Color(hex: "4a8fdc"))
                
                Text(tip.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
            }
            
            Text(tip.content)
                .font(.system(size: 15, design: .rounded))
                .foregroundColor(.white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
    }
}

struct SymptomFormData: Identifiable {
    let id = UUID()
    var title = ""
    var description = ""
    var severity: SeverityLevel = .mild
    var category: SymptomCategory = .other
}

struct AddSymptomView: View {
    @Environment(\.dismiss) var dismiss
    @State var formData: SymptomFormData
    let onSave: (Symptom) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "213d62")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Symptom Name")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            TextField("e.g., Headache", text: $formData.title)
                                .font(.system(size: 17, design: .rounded))
                                .padding()
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .topLeading) {
                                if formData.description.isEmpty {
                                    Text("Describe your symptoms...")
                                        .font(.system(size: 17, design: .rounded))
                                        .foregroundColor(.white.opacity(0.5))
                                        .padding(.top, 16)
                                        .padding(.leading, 12)
                                }
                                
                                TextEditor(text: $formData.description)
                                    .font(.system(size: 17, design: .rounded))
                                    .frame(height: 100)
                                    .padding(8)
                                    .foregroundColor(.white)
                            }
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Picker("Category", selection: $formData.category) {
                                ForEach(SymptomCategory.allCases, id: \.self) { category in
                                    HStack {
                                        Image(systemName: category.icon)
                                        Text(category.rawValue)
                                    }
                                    .tag(category)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding()
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                            .accentColor(Color(hex: "86b028"))
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Severity")
                                .font(.system(size: 16, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Picker("Severity", selection: $formData.severity) {
                                ForEach(SeverityLevel.allCases, id: \.self) { severity in
                                    Text(severity.rawValue).tag(severity)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        Button(action: {
                            let symptom = Symptom(
                                title: formData.title,
                                severity: formData.severity,
                                description: formData.description,
                                category: formData.category
                            )
                            onSave(symptom)
                        }) {
                            Text("Save Symptom")
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
            .navigationTitle("Log Symptom")
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

struct SymptomDetailView: View {
    @Environment(\.dismiss) var dismiss
    let symptom: Symptom
    let advice: String
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "213d62")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Symptom icon and title
                        VStack(spacing: 16) {
                            Image(systemName: symptom.category.icon)
                                .font(.system(size: 60))
                                .foregroundColor(Color(hex: symptom.severity.color))
                            
                            Text(symptom.title)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 20)
                        
                        // Info cards
                        VStack(spacing: 16) {
                            InfoRow(label: "Category", value: symptom.category.rawValue)
                            InfoRow(label: "Severity", value: symptom.severity.rawValue)
                            InfoRow(label: "Logged", value: symptom.dateLogged.formatted(date: .abbreviated, time: .shortened))
                        }
                        
                        if !symptom.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text(symptom.description)
                                    .font(.system(size: 16, design: .rounded))
                                    .foregroundColor(.white.opacity(0.85))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(16)
                        }
                        
                        // Advice section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(Color(hex: "86b028"))
                                
                                Text("Recommended Advice")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            
                            Text(advice)
                                .font(.system(size: 16, design: .rounded))
                                .foregroundColor(.white.opacity(0.85))
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "4a8fdc").opacity(0.3), Color(hex: "86b028").opacity(0.3)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(16)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Symptom Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "86b028"))
                }
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}

struct QuizView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "213d62")
                    .ignoresSafeArea()
                
                if viewModel.showQuizResult {
                    QuizResultView(score: viewModel.quizScore, total: viewModel.quizQuestions.count) {
                        viewModel.restartQuiz()
                    } onDismiss: {
                        dismiss()
                    }
                } else if let question = viewModel.currentQuestion {
                    VStack(spacing: 24) {
                        // Progress bar
                        VStack(spacing: 8) {
                            HStack {
                                Text("Question \(viewModel.currentQuizIndex + 1) of \(viewModel.quizQuestions.count)")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Spacer()
                                
                                Text("Score: \(viewModel.quizScore)")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(Color(hex: "86b028"))
                            }
                            
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 8)
                                        .cornerRadius(4)
                                    
                                    Rectangle()
                                        .fill(Color(hex: "86b028"))
                                        .frame(width: geometry.size.width * viewModel.quizProgress, height: 8)
                                        .cornerRadius(4)
                                }
                            }
                            .frame(height: 8)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        ScrollView {
                            VStack(spacing: 24) {
                                // Question
                                Text(question.question)
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                // Options
                                VStack(spacing: 16) {
                                    ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                                        QuizOptionButton(
                                            text: option,
                                            index: index,
                                            isSelected: viewModel.selectedAnswer == index,
                                            isCorrect: index == question.correctAnswerIndex,
                                            hasAnswered: viewModel.hasAnswered
                                        ) {
                                            viewModel.selectAnswer(index)
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // Explanation (shown after answering)
                                if viewModel.hasAnswered {
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Image(systemName: viewModel.selectedAnswer == question.correctAnswerIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                                .foregroundColor(viewModel.selectedAnswer == question.correctAnswerIndex ? Color(hex: "86b028") : .red)
                                            
                                            Text(viewModel.selectedAnswer == question.correctAnswerIndex ? "Correct!" : "Incorrect")
                                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                                .foregroundColor(.white)
                                        }
                                        
                                        Text(question.explanation)
                                            .font(.system(size: 15, design: .rounded))
                                            .foregroundColor(.white.opacity(0.9))
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(16)
                                    .padding(.horizontal, 20)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    
                                    Button(action: {
                                        withAnimation {
                                            viewModel.nextQuestion()
                                        }
                                    }) {
                                        Text(viewModel.currentQuizIndex < viewModel.quizQuestions.count - 1 ? "Next Question" : "See Results")
                                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 56)
                                            .background(Color(hex: "4a8fdc"))
                                            .cornerRadius(16)
                                    }
                                    .padding(.horizontal, 20)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                            .padding(.bottom, 30)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Health Quiz")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(Color(hex: "86b028"))
                }
            }
        }
    }
}

struct QuizOptionButton: View {
    let text: String
    let index: Int
    let isSelected: Bool
    let isCorrect: Bool
    let hasAnswered: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if !hasAnswered {
            return isSelected ? Color(hex: "4a8fdc").opacity(0.5) : Color.white.opacity(0.1)
        } else {
            if isCorrect {
                return Color(hex: "86b028").opacity(0.5)
            } else if isSelected && !isCorrect {
                return Color.red.opacity(0.5)
            } else {
                return Color.white.opacity(0.1)
            }
        }
    }
    
    var borderColor: Color {
        if !hasAnswered {
            return isSelected ? Color(hex: "4a8fdc") : Color.white.opacity(0.3)
        } else {
            if isCorrect {
                return Color(hex: "86b028")
            } else if isSelected && !isCorrect {
                return Color.red
            } else {
                return Color.white.opacity(0.3)
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                if hasAnswered {
                    if isCorrect {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "86b028"))
                    } else if isSelected {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor, lineWidth: 2)
            )
            .cornerRadius(12)
        }
        .disabled(hasAnswered)
        .buttonStyle(PlainButtonStyle())
    }
}

struct QuizResultView: View {
    let score: Int
    let total: Int
    let onRestart: () -> Void
    let onDismiss: () -> Void
    
    var percentage: Double {
        Double(score) / Double(total) * 100
    }
    
    var resultMessage: String {
        switch percentage {
        case 90...100:
            return "Excellent! You're a health expert!"
        case 70..<90:
            return "Great job! You know your health facts!"
        case 50..<70:
            return "Good effort! Keep learning!"
        default:
            return "Keep practicing! Health knowledge is power!"
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "trophy.fill")
                .font(.system(size: 80))
                .foregroundColor(Color(hex: "86b028"))
            
            Text("Quiz Complete!")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            VStack(spacing: 12) {
                Text("Your Score")
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                
                Text("\(score)/\(total)")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(Color(hex: "86b028"))
                
                Text(resultMessage)
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: onRestart) {
                    Text("Try Again")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color(hex: "4a8fdc"))
                        .cornerRadius(16)
                }
                
                Button(action: onDismiss) {
                    Text("Close")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(Color(hex: "86b028"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 40)
        }
    }
}

