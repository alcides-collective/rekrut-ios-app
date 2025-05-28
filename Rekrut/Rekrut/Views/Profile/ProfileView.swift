//
//  ProfileView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var firebaseService = FirebaseService.shared
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showingLogin = false
    @State private var showingSignUp = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Group {
                if firebaseService.isAuthenticated, let user = firebaseService.currentUser {
                    AuthenticatedProfileView(user: user, authViewModel: authViewModel)
                } else {
                    UnauthenticatedProfileView(
                        showingLogin: $showingLogin,
                        showingSignUp: $showingSignUp
                    )
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
        .sheet(isPresented: $showingLogin) {
            LoginView()
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpView()
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
                    ProfileMenuItem(
                        icon: "bookmark.fill",
                        title: "Zapisane kierunki",
                        count: user.savedPrograms.count
                    )
                    
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
    @Binding var showingLogin: Bool
    @Binding var showingSignUp: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding()
            
            Text("Twój Profil")
                .font(.title)
                .bold()
            
            Text("Zaloguj się, aby zapisać swoje preferencje")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 15) {
                Button(action: {
                    showingLogin = true
                }) {
                    Text("Zaloguj się")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    showingSignUp = true
                }) {
                    Text("Utwórz konto")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(Color.white)
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
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