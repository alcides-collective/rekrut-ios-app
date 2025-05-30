//
//  LoginView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentBenefitIndex = 0
    
    let benefits = [
        "Zapisuj ulubione kierunki studiów",
        "Porównuj programy i uczelnie",
        "Otrzymuj spersonalizowane rekomendacje",
        "Śledź terminy rekrutacji",
        "Obliczaj swoje szanse przyjęcia"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                Spacer()
                
                // App branding
                VStack(spacing: 20) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                        .symbolRenderingMode(.hierarchical)
                    
                    VStack(spacing: 8) {
                        Text("Rekrut")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("Twój przewodnik po studiach")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Animated benefit display
                VStack(spacing: 20) {
                    Text(benefits[currentBenefitIndex])
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                        .animation(.easeInOut(duration: 0.3), value: currentBenefitIndex)
                        .transition(.opacity)
                        .id(currentBenefitIndex)
                    
                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(0..<benefits.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentBenefitIndex ? Color.blue : Color.secondary.opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentBenefitIndex)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .onAppear {
                    startBenefitAnimation()
                }
                
                Spacer()
                
                // Sign in with Apple button
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        request.requestedScopes = [.fullName, .email]
                        request.nonce = viewModel.sha256(viewModel.currentNonce ?? "")
                    },
                    onCompletion: { result in
                        Task {
                            await viewModel.handleSignInWithAppleResult(result)
                            if viewModel.error == nil {
                                dismiss()
                            }
                        }
                    }
                )
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .frame(height: 50)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Privacy note
                Text("Twoje dane są bezpieczne dzięki Apple ID")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                    .frame(height: 40)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Zamknij") {
                        dismiss()
                    }
                }
            }
            .alert("Błąd", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Wystąpił problem z logowaniem")
            }
        }
    }
    
    private func startBenefitAnimation() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { timer in
            withAnimation {
                currentBenefitIndex = (currentBenefitIndex + 1) % benefits.count
            }
        }
    }
}

#Preview {
    LoginView()
}