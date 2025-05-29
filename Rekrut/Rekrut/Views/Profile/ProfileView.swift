//
//  ProfileView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI
import AuthenticationServices

struct ProfileView: View {
    @StateObject private var firebaseService = FirebaseService.shared
    @StateObject private var authViewModel = AuthViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationView {
            Group {
                if firebaseService.isAuthenticated, let user = firebaseService.currentUser {
                    AuthenticatedProfileView(user: user, authViewModel: authViewModel)
                } else {
                    UnauthenticatedProfileView(authViewModel: authViewModel, colorScheme: colorScheme)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Zamknij") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AuthenticatedProfileView: View {
    let user: User
    let authViewModel: AuthViewModel
    @State private var showingSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                VStack(spacing: 15) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text(user.displayName ?? user.email)
                        .font(.title2)
                        .bold()
                    
                    Text(user.email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                VStack(spacing: 0) {
                    NavigationLink(destination: BookmarkedProgramsView()) {
                        ProfileMenuItem(
                            icon: "bookmark.fill",
                            title: "Zapisane kierunki",
                            count: user.savedPrograms.count
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Divider()
                    
                    ProfileMenuItem(
                        icon: "chart.bar.doc.horizontal.fill",
                        title: "Porównania",
                        count: user.savedComparisons.count
                    )
                    
                    Divider()
                    
                    ProfileMenuItem(
                        icon: "function",
                        title: "Wyniki matury",
                        subtitle: user.maturaScores != nil ? "Zapisane" : "Nie wprowadzone"
                    )
                    
                    Divider()
                    
                    ProfileMenuItem(
                        icon: "gearshape.fill",
                        title: "Ustawienia"
                    )
                }
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .padding(.horizontal)
                
                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Wyloguj się")
                        .font(.headline)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top)
            }
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
    }
}

struct UnauthenticatedProfileView: View {
    let authViewModel: AuthViewModel
    let colorScheme: ColorScheme
    @State private var currentFeatureIndex = 0
    
    let features = [
        "Zapisuj ulubione kierunki",
        "Porównuj programy studiów",
        "Otrzymuj powiadomienia o terminach",
        "Bezpieczne logowanie z Apple ID"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Icon and title
            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .symbolRenderingMode(.hierarchical)
                
                Text("Twój Profil")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Zaloguj się, aby korzystać\nze wszystkich funkcji")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Animated feature display
            VStack(spacing: 20) {
                Text(features[currentFeatureIndex])
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .frame(height: 50)
                    .animation(.easeInOut(duration: 0.3), value: currentFeatureIndex)
                    .transition(.opacity)
                    .id(currentFeatureIndex)
                
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<features.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentFeatureIndex ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentFeatureIndex)
                    }
                }
            }
            .onAppear {
                startFeatureAnimation()
            }
            
            // Sign in with Apple button - direct integration
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                    request.nonce = authViewModel.sha256(authViewModel.currentNonce ?? "")
                },
                onCompletion: { result in
                    Task {
                        await authViewModel.handleSignInWithAppleResult(result)
                    }
                }
            )
            .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
            .frame(height: 50)
            .cornerRadius(10)
            .padding(.top, 20)
            
            Text("Kontynuuj z Apple ID")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal, 60)
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func startFeatureAnimation() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { timer in
            withAnimation {
                currentFeatureIndex = (currentFeatureIndex + 1) % features.count
            }
        }
    }
}

struct ProfileFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    var subtitle: String? = nil
    var count: Int? = nil
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let count = count {
                Text("\(count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(12)
            }
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
        .padding()
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
}