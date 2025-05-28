//
//  SignUpView.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) private var dismiss
    
    var isFormValid: Bool {
        !email.isEmpty && 
        !password.isEmpty && 
        password == confirmPassword && 
        password.count >= 6
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                VStack(spacing: 10) {
                    Image(systemName: "person.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Utwórz konto")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Dołącz do społeczności Rekrut")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        TextField("twoj@email.com", text: $email)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hasło")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        SecureField("Minimum 6 znaków", text: $password)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.newPassword)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Potwierdź hasło")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        SecureField("Powtórz hasło", text: $confirmPassword)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textContentType(.newPassword)
                    }
                    
                    if !password.isEmpty && password != confirmPassword {
                        Text("Hasła nie są identyczne")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    Task {
                        await viewModel.signUp(email: email, password: password)
                        if viewModel.error == nil {
                            dismiss()
                        }
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Zarejestruj się")
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(isFormValid ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .disabled(!isFormValid || viewModel.isLoading)
                
                Text("Rejestrując się, akceptujesz nasz Regulamin i Politykę Prywatności")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
            }
            .alert("Błąd", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Wystąpił nieznany błąd")
            }
        }
    }
}

#Preview {
    SignUpView()
}