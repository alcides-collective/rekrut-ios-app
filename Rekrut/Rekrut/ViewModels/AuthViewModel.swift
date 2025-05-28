//
//  AuthViewModel.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let firebaseService = FirebaseService.shared
    
    var error: Error? {
        didSet {
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                errorMessage = nil
                showError = false
            }
        }
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            try await firebaseService.signIn(email: email, password: password)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func signUp(email: String, password: String) async {
        isLoading = true
        error = nil
        
        do {
            try await firebaseService.signUp(email: email, password: password)
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func signOut() {
        do {
            try firebaseService.signOut()
        } catch {
            self.error = error
        }
    }
}