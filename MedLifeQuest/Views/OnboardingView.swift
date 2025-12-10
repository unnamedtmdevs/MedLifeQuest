//
//  OnboardingView.swift
//  X-MedLifeQuest
//
//  Created on Dec 10, 2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userStateService: UserStateService
    @State private var currentPage = 0
    @State private var userName = ""
    @State private var showNameInput = false
    
    var body: some View {
        ZStack {
            Color(hex: "213d62")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(currentPage == index ? Color(hex: "86b028") : Color.white.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.top, 60)
                .padding(.bottom, 30)
                
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        icon: "heart.text.square.fill",
                        title: "Track Your Health",
                        description: "Log your symptoms and receive personalized advice to better understand your health patterns.",
                        accentColor: "4a8fdc"
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        icon: "lightbulb.fill",
                        title: "Daily Health Tips",
                        description: "Get personalized health tips based on your logged symptoms to improve your well-being.",
                        accentColor: "86b028"
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        icon: "brain.head.profile",
                        title: "Learn & Grow",
                        description: "Take interactive health quizzes and set reminders to stay on top of your health goals.",
                        accentColor: "82AF31"
                    )
                    .tag(2)
                }
                #if os(iOS)
                .tabViewStyle(.page(indexDisplayMode: .never))
                #endif
                
                VStack(spacing: 20) {
                    if currentPage == 2 {
                        if !showNameInput {
                            Button(action: {
                                withAnimation {
                                    showNameInput = true
                                }
                            }) {
                                Text("Get Started")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color(hex: "86b028"))
                                    .cornerRadius(16)
                            }
                            .padding(.horizontal, 30)
                        } else {
                            VStack(spacing: 16) {
                                TextField("Enter your name", text: $userName)
                                    .font(.system(size: 17, design: .rounded))
                                    .padding()
                                    .background(Color.white.opacity(0.15))
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .accentColor(Color(hex: "86b028"))
                                
                                Button(action: {
                                    if !userName.trimmingCharacters(in: .whitespaces).isEmpty {
                                        userStateService.completeOnboarding(userName: userName)
                                    }
                                }) {
                                    Text("Continue")
                                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 56)
                                        .background(userName.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color(hex: "86b028"))
                                        .cornerRadius(16)
                                }
                                .disabled(userName.trimmingCharacters(in: .whitespaces).isEmpty)
                            }
                            .padding(.horizontal, 30)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    } else {
                        Button(action: {
                            withAnimation {
                                currentPage += 1
                            }
                        }) {
                            Text("Next")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color(hex: "4a8fdc"))
                                .cornerRadius(16)
                        }
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let icon: String
    let title: String
    let description: String
    let accentColor: String
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 100))
                .foregroundColor(Color(hex: accentColor))
                .padding(.bottom, 20)
            
            Text(title)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text(description)
                .font(.system(size: 17, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
        }
    }
}

