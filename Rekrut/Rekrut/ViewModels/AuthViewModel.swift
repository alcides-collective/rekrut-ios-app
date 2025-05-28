//
//  AuthViewModel.swift
//  Rekrut
//
//  Created by Jakub Dudek on 28/05/2025.
//

import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let firebaseService = FirebaseService.shared
    private(set) var currentNonce: String?
    
    init() {
        // Generate nonce when view model is created
        self.currentNonce = randomNonceString()
    }
    
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
    
    func handleSignInWithAppleResult(_ result: Result<ASAuthorization, Error>) async {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                await signInWithApple(credential: appleIDCredential)
            }
        case .failure(let error):
            self.error = error
        }
    }
    
    private func signInWithApple(credential: ASAuthorizationAppleIDCredential) async {
        isLoading = true
        error = nil
        
        do {
            // Get identity token
            guard let identityToken = credential.identityToken,
                  let identityTokenString = String(data: identityToken, encoding: .utf8) else {
                throw AuthError.invalidCredential
            }
            
            // Use the nonce that was generated when the view model was created
            guard let nonce = currentNonce else {
                throw AuthError.invalidCredential
            }
            
            // Create Firebase credential with the same nonce
            let firebaseCredential = OAuthProvider.appleCredential(
                withIDToken: identityTokenString,
                rawNonce: nonce,
                fullName: credential.fullName
            )
            
            // Sign in with Firebase
            try await firebaseService.signInWithApple(
                credential: firebaseCredential,
                fullName: credential.fullName,
                email: credential.email
            )
            
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
    
    // SHA256 hash function for nonce
    func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Generate secure nonce for Apple Sign In
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

enum AuthError: LocalizedError {
    case invalidCredential
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "Nieprawidłowe dane uwierzytelniające"
        case .unknown:
            return "Wystąpił nieznany błąd"
        }
    }
}